import 'dart:convert';
import 'dart:ui';

import 'package:PointOwner/PointOwner%20Side/qrGenerate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Entities/ListsItem.dart';
import '../Entities/Point.dart';
import 'AddProduct.dart';
import 'ConfigScreen.dart';
import 'EditProduct.dart';
import 'PointHomeScreen.dart';
import 'PointOwnerOrderStatus.dart';

class PointMenu extends StatefulWidget {
  Point point;

  PointMenu(Point p) {
    this.point = p;
  }
  @override
  _PointMenuState createState() => _PointMenuState.withPoint(point);
}

// Grid(TextEditingController pointID);

class _PointMenuState extends State<PointMenu> {
  final storage = FlutterSecureStorage();
  Point point;

  factory _PointMenuState.withPoint(Point p) {
    return _PointMenuState().withPoint(p);
  }
  _PointMenuState withPoint(Point p) {
    this.point = p;
    return this;
  }

  _PointMenuState();

  @override
  void initState() {
    print("Point menu init state");
    super.initState();
    Future.delayed(Duration.zero, () {
      getPointItems();
    });
  }

  int categoryNumber = 0;

  String pointID = "4";
  List<String> uniqueCategories = ['placeholder'];
  List<Widget> gridChild = [];

  List<List<Widget>> gridChildren = [
    [Container()]
  ];

  getPointItems() async {
    //TODO:Skorzystac z metody Poit.getPointInfo()

    List<String> categories = new List();

    var jsonResponse = null;
    var pointID = (await storage.read(key: "pointID")).toString();
    // String request = "http://10.0.2.2:8080/point/" + sharedPreferences.getString('token') + "/products";
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
          for (dynamic item in posts) {
            if (category == item.category.toString()) {
              tempGridChild.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Item(item.productID, item.name, item.price,
                        item.category, item.img),
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
        print(uniqueCategories);
      }
    }
  }

  Image getImage(String imgUrl) {
    return imgUrl == null
        ? Image.asset("pizza.jpg", height: 110, width: 110)
        : Image.network(imgUrl.replaceAll("localhost", "10.0.2.2"),
            height: 110, width: 110);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var itemHeight = 243.0;
    return Scaffold(
      backgroundColor: Colors.white54,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Color(this.point.color),
              ),
            ),
            ListTile(
              title: Text('Strona główna punktu'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PointOwnerOrderStatus(this.point)));
              },
            ),
            ListTile(
              title: Text('Podgląd menu'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Ustawienia Punktu'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Generator QR'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GenerateQr(point)));
              },
            ),
            ListTile(
              title: Text('Customize point'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfigScreen(point)));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
          // leading: IconButton(icon: Icon(Icons.menu), onPressed: (){
          //
          // }),
          backgroundColor: Color(this.point.color),
          title: Text(point.pointsName),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.people),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: Text('Tu chyba nic jednak nie bedzie')));
                })
          ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(this.point.color),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddProduct(point)));
          // setState(() {
          //   // gridChild.add(Padding(
          //   //     padding: const EdgeInsets.all(8.0),
          //   //     child: Container(
          //   //         child: Item("<Nazwa produktu>", "<cena>", "<kategoria>"),
          //   //         decoration: BoxDecoration(
          //   //           borderRadius: BorderRadius.circular(15.0),
          //   //           color: Colors.white70,
          //   //         ))));
          // });
        },
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

  Container Item(int productId, String productName, String price,
      String category, String imgUrl) {
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
                  ],
                ),
                Expanded(
                    child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [getImage(imgUrl)],
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
                    Map<String, dynamic> paramMap = {
                      "id": productId.toString(),
                      "name": productName,
                      "price": price.toString(),
                      "category": category,
                      "img": imgUrl,
                      "point": point
                    };
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProduct(paramMap)));
                  },
                  child: Text("Edytuj"),
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

  Container scrollingCategories(String category) {
    return Container(
      child: Text(
        category + ':',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }

  getPageNum(int page) {
    setState(() {
      categoryNumber = page;
    });
    print("Bieżąca strona");
    print(categoryNumber);
    print(uniqueCategories[categoryNumber]);
  }
}
