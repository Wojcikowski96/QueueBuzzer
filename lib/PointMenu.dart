import 'dart:convert';
import 'dart:ui';

import 'package:PointOwner/AddProduct.dart';
import 'package:PointOwner/EditProduct.dart';
import 'package:PointOwner/PointHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PointMenu extends StatefulWidget {
  @override
  _PointMenuState createState() => _PointMenuState();
}

// Grid(TextEditingController pointID);

class ListsItem {
  String name, price, category;

  ListsItem();

  ListsItem.construct(String name, String price, String category) {
    this.name = name;
    this.price = price;
    this.category = category;
  }

  static fromJson(json) {
    ListsItem p = new ListsItem();
    print(json);
    p.name = json['name'];
    p.price = json['price'].toString();
    p.category = json['category'];
    return p;
  }
}

class _PointMenuState extends State<PointMenu> {
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getPointItems();
    });
  }

  static int categoryNumber=0;

  String pointID = "4";
  List<String> uniqueCategories = new List();
  List<Widget> gridChild = [];

  List<List<Widget>> gridChildren = new List();

  getPointItems() async {
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
            .map((Map model) => ListsItem.fromJson(model))
            .toList();

        List<List<Widget>> tempGridChildren = gridChildren.toList();

        for (dynamic item in posts) {
          categories.add(item.category.toString());
        }

        List<String> tempUniqueCategories = categories.toSet().toList();

        for (String category in tempUniqueCategories) {
          List<Widget> tempGridChild = gridChild.toList();
          tempGridChild.add(Center(
            child: Text(
              'Twoje menu: ' + category,
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ));
          for (dynamic item in posts) {
            if (category == item.category.toString()) {
              tempGridChild.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Item(item.name, item.price, item.category),
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
                color: Colors.deepOrange,
              ),
            ),
            ListTile(
              title: Text('Strona główna punktu'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PointHomeScreen.fromBase64(
                            storage.read(key: "jwt").toString())));
              },
            ),
            ListTile(
              title: Text('Edytuj menu'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.of(context).pop();
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
          ],
        ),
      ),
      appBar: AppBar(
          // leading: IconButton(icon: Icon(Icons.menu), onPressed: (){
          //
          // }),
          title: Text("Nazwa restauracji"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.people),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: Text('Tu chyba nic jednak nie bedzie')));
                })
          ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddProduct()));
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
    );
  }

  Container Item(String productName, String price, String category) {
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
                  children: [
                    Image.asset(
                      "pizza.jpg",
                      height: 110,
                      width: 110,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProduct({
                                  "name": productName,
                                  "price": price.toString(),
                                  "category": category,
                                })));
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
  getPageNum(int page) {
    setState(() {
      categoryNumber=page;
    });
    print('Bieżąca strona');
    print(page);
  }
}
