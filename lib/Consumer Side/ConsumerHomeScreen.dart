import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:PointOwner/Consumer%20Side/ConsumerOrderWizard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../Entities/Consumer.dart';
import '../Entities/ListsItem.dart';
import '../Entities/Point.dart';
import 'ConsumerOrderStatus.dart';
import 'ConsumerStory.dart';

class ConsumerHomeScreen extends StatefulWidget {
  Point point;
  Consumer consumer;

  ConsumerHomeScreen(Point p) {
    this.point = p;
  }

  ConsumerHomeScreen.withConsumer(this.point, this.consumer);

  @override
  _ConsumerHomeScreenState createState() {
    if (consumer != null) {
      return _ConsumerHomeScreenState.withPointAndConsumer(point, consumer);
    } else {
      return _ConsumerHomeScreenState.withPoint(point);
    }
  }
}

var storage = FlutterSecureStorage();
// Grid(TextEditingController pointID);

getPropertiesFromJson(json) {
  List<String> properties = new List();
  properties.add(json['name']);
  properties.add(json['avgAwaitTime'].toString());
  return properties;
}

getProperties() async {
  var jsonResponse = null;
  var pointID = (await storage.read(key: "pointID")).toString();
  String request = "http://10.0.2.2:8080/point/" + pointID;
  var response = await http.get(request);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);

    if (jsonResponse != null) {
      var decoded = json.decode(response.body);
      return getPropertiesFromJson(decoded);
    }
  }
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  String pointName = "Nazwa restauracji";
  int categoryNumber = 0;
  double totalPrice = 0.0;
  List<String> orderProperties = [""];
  Timer timer;
  var storageOut = FlutterSecureStorage();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String token;


  Point point;
  Consumer consumer;



  factory _ConsumerHomeScreenState.withPoint(Point p) {
    return _ConsumerHomeScreenState().setPoint(p);
  }

  Future<String> loadToken() async {
    return await firebaseMessaging.getToken();
  }

  factory _ConsumerHomeScreenState.withPointAndConsumer(Point p, Consumer c) {
    return _ConsumerHomeScreenState().setPointAndConsumer(p, c);
  }

  _ConsumerHomeScreenState setPoint(Point p) {
    this.point = p;
    this.consumer = Consumer();
    return this;
  }

  _ConsumerHomeScreenState setPointAndConsumer(Point p, Consumer c) {
    this.point = p;
    this.consumer = c;
    return this;
  }

  _ConsumerHomeScreenState();

  @override
  void initState() {
    super.initState();
    print("Order properties w init " + orderProperties[0]);

    loadToken().then((value) {
      this.token = value;
      print(value.toString());
    });
    getPointInfo();

    Future.delayed(Duration.zero, () async {
      getPointItems();
      String tempPointName = (await storage.read(key: "pointName")).toString();
      setState(() {
        pointName = tempPointName;
      });
      print('Init state');
    });
  }

  getPointInfo() async {
    var pointID = (await storage.read(key: "pointID")).toString();
    String request = "http://10.0.2.2:8080/point/" + pointID;
    var response = await http.get(request);
     var jsonMap =  jsonDecode(response.body) as Map<String, dynamic>;
     this.point.imgUrl =  jsonMap['logoImg'];
     var hexString = jsonMap['colour'];
     final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    this.point.color = int.parse(buffer.toString(), radix: 16);
  }

  Image getImage(String imgUrl) {
    return imgUrl == null ? Image.asset("pizza.jpg", height: 110, width: 110) : Image.network(imgUrl.replaceAll("localhost", "10.0.2.2"), height: 110, width: 110);
  }

  String pointID = "4";
  List<String> uniqueCategories = ['placeholder'];
  List<Widget> gridChild = [];
  List<List<Widget>> gridChildren = [
    [Container()]
  ];
  List<Widget> basketItems = [];

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var itemHeight = 270.0;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Color(this.point.color),
        // leading: IconButton(icon: Icon(Icons.menu), onPressed: (){
        //
        // }),
          leading: Builder(
              builder: (ctx) => Stack(
                alignment: Alignment.bottomRight,
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_basket_outlined),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                  productsNumIcon(getProductIdsFromBasket().length)

                ],
              )),
          title: Text(pointName),
          actions: <Widget>[
            SizedBox(
              child: RaisedButton.icon(
                  color: Color(this.point.color),
                  icon: Icon(Icons.autorenew_outlined, color: Colors.white),
                  label: Text(orderProperties[0], style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConsumerOrderStatus(point)));
                  }),
            ),
            SizedBox(
              child: RaisedButton.icon(
                  color: Color(this.point.color),
                  icon: Icon(Icons.history, color: Colors.white),
                  label: Text(orderProperties[0], style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConsumerStory(point)));
                  }),
            )
          ]),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              // padding: EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 8.0),
              padding: EdgeInsets.all(10.0),
              child: this.point.imgUrl == null ? Image(color: Color(this.point.color), image: AssetImage('basket2.png')) : Image.network(this.point.imgUrl.replaceAll("localhost", "10.0.2.2"), height: 110, width: 110)
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / itemHeight * 3.2),
                  children: List.generate(
                      basketItems.length, (index) => basketItems[index]),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    'Łączna kwota:',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    totalPrice.toStringAsFixed(2) + ' PLN',
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
            ),
            RaisedButton(
                child: Text('Zamów'),
                color: Color(this.point.color),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConsumerOrderWizard.withConsumer(point, consumer)));
                  // placeOrder();
                  // timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getOrderProperties());
                  // Navigator.pop(context);
                  // Scaffold.of(context).showSnackBar(new SnackBar(
                  //     content: Text('Złożyłeś zamówienie!')
                  // ));
                })
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("food.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.darken),
          ),
        ),
        child: Column(children: [
          appHeader(),
          scrollingCategories(uniqueCategories[categoryNumber]),
          Expanded(
            child: PageView.builder(
              itemCount: uniqueCategories.length,
              scrollDirection: Axis.horizontal,
              reverse: false,
              onPageChanged: getPageNum,
              itemBuilder: (BuildContext context, int index) {
                return new GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / itemHeight),
                  children: List.generate(gridChildren[index].length,
                          (index2) => gridChildren[index][index2]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Container Item(String productName, String price, String category,
      bool availability, int productID, String description, String imgUrl) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    productName,
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('Cena:', style: TextStyle(fontSize: 20)),
                    Text(price),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Kategoria:', style: TextStyle(fontSize: 20)),
                    Text(category),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Dostępny:', style: TextStyle(fontSize: 20)),
                    Text(availability.toString()),
                  ],
                ),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          getImage(imgUrl),
                      ],
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    addToBasket(productName, price, productID);
                    increaseTotalPrice(price);
                  },
                  child: Text("Do koszyka"),
                  color: Colors.white12,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  splashColor: Colors.white,
                ),
                width: 100,
                height: 30,
              ),
              SizedBox(width: 20,),
              SizedBox(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    displayDialog(context, description);
                  },
                  child: Text("Szczegóły"),
                  color: Colors.white12,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  splashColor: Colors.white,
                ),
                width: 100,
                height: 30,
              ),
            ],
          )
        ]));
  }

  Container appHeader() {
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          children: [
            Center(
                child: Text(
                  'Menu restauracji:',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                'Osób w kolejce: ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              child: Text(
                '5',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                'Średni czas oczekiwania: ',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            FutureBuilder<dynamic>(
              future: getProperties(),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(snapshot.data[1],
                      style: TextStyle(color: Colors.white, fontSize: 30));
                else if (snapshot.hasError) return Text(snapshot.error);
                return Text("Await for data");
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        // ),
      ),
    );
  }

  Container scrollingCategories(String category) {
    return Container(
      child: Text(
        category + ':',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }

  Container basketItem(String name, String price, int productID) {
    return new Container(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Text(
                name,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(price,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.right),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                color: Colors.white,
                icon: Center(child: Icon(Icons.delete, size: 30.0)),
                onPressed: () {
                  removeFromBasket(
                      ListsItem.constructSimple(name, price, productID));
                  decreaseTotalPrice(price);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  addToBasket(String name, String price, int productID) {
    consumer.addToBasket(ListsItem.constructSimple(name, price, productID));

    List<Widget> tempBasketItems = new List<Widget>();
    consumer.basket.forEach((element) {
      tempBasketItems
          .add(basketItem(element.name, element.price, element.productID));
    });

    setState(() {
      basketItems = tempBasketItems;
    });
  }

  removeFromBasket(ListsItem item) {
    consumer.removeFromBasket(item);

    List<Widget> tempBasketItems = new List<Widget>();
    consumer.basket.forEach((element) {
      tempBasketItems
          .add(basketItem(element.name, element.price, element.productID));
    });

    setState(() {
      basketItems = tempBasketItems;
    });
  }

  String getNumOfPeople() {
    return '5';
  }

  String avgWaitTime(String waittime) {
    return waittime;
  }

  getPageNum(int page) {
    setState(() {
      categoryNumber = page;
    });
  }

  getPointItems() async {
    List<String> categories = new List();
    var jsonResponse = null;
    var pointID = (await storage.read(key: "pointID")).toString();
    String request = "http://10.0.2.2:8080/point/" + pointID + "/products";
    var response = await http.get(request);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Iterable iterable = json.decode(response.body);
        List<dynamic> posts = List<Map>.from(iterable)
            .map((Map model) => ListsItem.productFromJson(model))
            .toList();

        gridChildren.removeAt(0);

        List<List<Widget>> tempGridChildren = gridChildren.toList();

        for (dynamic item in posts) {
          categories.add(item.category.toString());
          print(item.toString());
        }

        List<String> tempUniqueCategories = categories.toSet().toList();

        for (String category in tempUniqueCategories) {
          List<Widget> tempGridChild = gridChild.toList();
          //tempGridChild.add(scrollingCategories(category));
          for (dynamic item in posts) {
            if (category == item.category.toString()) {
              tempGridChild.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Item(item.name, item.price, item.category,
                        item.avaliability, item.productID, item.description, item.img),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white70,
                    ),
                  ),
                ),
              );
            }
          }
          tempGridChildren.add(tempGridChild);
        }

        setState(() {
          gridChildren = tempGridChildren;
          uniqueCategories = tempUniqueCategories;
        });
      }
    }
  }

  Future<void> placeOrder() async {
    const SERVER_IP = 'http://10.0.2.2:8080';

    var res = await http.post("$SERVER_IP/consumer-order",
        body: jsonEncode(<String, dynamic>{
          "consumerId": 1,
          "pointId": point.pointID,
          "productsIds": getProductIdsFromBasket(),
          "stateName": "ACCEPTED",
          "fireBaseToken": this.token,
        }),
        headers: <String, String>{"Content-Type": "application/json"}
        );
  }

  List<int> getProductIdsFromBasket() {
    List<int> ids = new List<int>();
    consumer.basket.forEach((element) {
      ids.add(element.productID);
    });
    return ids;
  }

  increaseTotalPrice(String price) {
    totalPrice = totalPrice + double.parse(price);
  }

  decreaseTotalPrice(String price) {
    totalPrice = totalPrice - double.parse(price);
    if (totalPrice < 0) totalPrice = -1 * totalPrice;
  }
  Opacity productsNumIcon(int productsLength){

    if(productsLength != 0){
      return Opacity(
          opacity: 1.0,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
            ),
            child: Center(child: Text(getProductIdsFromBasket().length.toString(), style: TextStyle(fontSize: 15, color: Color(this.point.color)),)),
          )
      );
    }else{
      return Opacity(
          opacity: 0.0,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
            ),
            child: Center(child: Text(getProductIdsFromBasket().length.toString(), style: TextStyle(fontSize: 15, color: Color(this.point.color)),)),
          )
      );
    }

  }


  void displayDialog(BuildContext context, String text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(title: Text("Opis potrawy:"), content: Text(text)),
  );
}

