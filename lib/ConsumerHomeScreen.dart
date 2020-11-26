import 'dart:convert';
import 'dart:ui';
import 'package:PointOwner/ConsumerOrderStatus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'ListsItem.dart';
import 'Point.dart';

class ConsumerHomeScreen extends StatefulWidget {
  Point point;

  ConsumerHomeScreen(Point p) {
    this.point = p;
  }

  @override
  _ConsumerHomeScreenState createState() =>
      _ConsumerHomeScreenState.withPoint(point);
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
  int totalPrice = 0;

  Point point;

  factory _ConsumerHomeScreenState.withPoint(Point p) {
    return _ConsumerHomeScreenState()._(p);
  }
  _ConsumerHomeScreenState _(Point p) {
    this.point = p;
    return this;
  }

  _ConsumerHomeScreenState();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      getPointItems();
      String tempPointName = (await storage.read(key: "pointName")).toString();
      setState(() {
        pointName = tempPointName;
      });
    });
  }

  String pointID = "4";
  List<String> uniqueCategories = ['placeholder'];
  List<Widget> gridChild = [];
  List<List<Widget>> gridChildren = [
    [Container()]
  ];
  List<Widget> basketItems = [Container()];

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
                        item.avaliability),
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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var itemHeight = 270.0;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          // leading: IconButton(icon: Icon(Icons.menu), onPressed: (){
          //
          // }),
          title: Text(pointName),
          actions: <Widget>[
            SizedBox(
              child: RaisedButton.icon(
                  color: Colors.deepOrange,
                  icon: Icon(Icons.shopping_basket_outlined),
                  label: Text("Status zamówienia"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConsumerOrderStatus(point)));
                  }),
            )
          ]),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                'Zawartość koszyka:',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                image: DecorationImage(image: AssetImage('basket.png')),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: (screenWidth / itemHeight * 3.2),
                children: List.generate(
                    basketItems.length, (index) => basketItems[index]),
              ),
            ),
            RaisedButton(
                child: Text('Zamów'),
                color: Colors.deepOrange,
                onPressed: () {})
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

  Container Item(
      String productName, String price, String category, bool availability) {
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
                    Image.asset(
                      "pizza.jpg",
                      height: 150,
                      width: 150,
                    )
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
                    /*
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConsumerOrderStatus(point)));
                     */
                    addToBasket(productName, price);
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

  Container basketItem(String name, String price) {
    return new Container(
      height: 30,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(price,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.right),
            ),
            SizedBox(
              width: 20,
            ),

              SizedBox(
                width:50,
                child: IconButton(
                    color: Colors.white,
                    icon:Center(child: Icon(Icons.delete, size: 30.0)),
                   onPressed: (){

                   },

                   // child: Center(
                        //child: Text('X',
                            //style: TextStyle(fontSize: 20, color: Colors.white),
                            //textAlign: TextAlign.center)),
                    //shape: RoundedRectangleBorder(
                        // set the value to a very big number like 100, 1000...
                        //borderRadius: BorderRadius.circular(100)),
                    //onPressed: () {}),
              ),
              ),

          ],
        ),
      ),
    );
  }

  addToBasket(String name, String price) {
    List<Widget> tempBasketItems = basketItems;
    tempBasketItems.add(basketItem(name, price));
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
    print('Bieżąca strona');
    print(page);
  }
}
