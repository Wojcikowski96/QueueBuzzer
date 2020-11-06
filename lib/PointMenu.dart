import 'dart:convert';
import 'dart:ui';

import 'package:PointOwner/EditProduct.dart';
import 'package:PointOwner/PointHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  void initState() {
    super.initState();
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    getPointItems();
  }

  String pointID = "4";

  List<Widget> gridChild = [
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("food.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Text(
            'Twoje menu:',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),

        // ),
      ),
    ),
  ];

  getPointItems() async {
    var screenWidth = MediaQuery.of(context).size.width;
    var itemHeight = 220.0;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    // String request = "http://10.0.2.2:8080/point/" + sharedPreferences.getString('token') + "/products";
    String request = "http://10.0.2.2:8080/point/" + "1" + "/products";
    var response = await http.get(request);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Iterable iterable = json.decode(response.body);
        List<dynamic> posts = List<Map>.from(iterable)
            .map((Map model) => ListsItem.fromJson(model))
            .toList();
        List<Widget> tempGridChild = gridChild.toList();
        for (dynamic item in posts) {
          tempGridChild.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(child: Item(item.name, item.price, item.category),
                  //child: SimpleFoldingCell(
                  //frontWidget: FrontWidget(
                  //item.name, item.price, item.category),
                  //innerTopWidget: InnerTopWidget(item.name),
                  //innerBottomWidget: InnerBottomWidget(item.name),

                  //cellSize: Size(screenWidth, itemHeight),
                  //)
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
              color: Colors.white70,
            ),
              ),
            ),
          );
        }
        setState(() {
          gridChild = tempGridChild;
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PointHomeScreen()));
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
                  Scaffold.of(context).showSnackBar(
                      new SnackBar(content: Text('Yay! A SnackBar!')));
                })
          ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            gridChild.add(
              Container(
                  child: SimpleFoldingCell(
                frontWidget: FrontWidget("Pizza", "20.0", "Italia"),
                // innerTopWidget: InnerTopWidget(),
                innerBottomWidget: InnerBottomWidget("Pizza"),

                cellSize: Size(screenWidth, itemHeight),
                // padding: EdgeInsets.all(8.0)
              )),
            );
          });
        },
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: (screenWidth / itemHeight),
          children:
              List.generate(gridChild.length, (index) => gridChild[index]),
        ),
      ),
    );
  }

  Container FrontWidget(
      String productName, String productPrice, String productCategory) {
    // Container FrontWidget() {

    return Container(
        alignment: Alignment.center,
        child: Row(children: <Widget>[
          Expanded(
              // flex: 1,
              child: Container(
            child: Container(
                child: Row(children: <Widget>[
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    productPrice,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(),
            ])),
          )),
          Expanded(
              // flex: 2,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white70,
                  ),
                  child: Container(
                    child: Column(children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            productName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Image.asset(
                        "pizza.jpg",
                        height: 100,
                        width: 100,
                      ),
                      Text('productCategory'),
                      SizedBox(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProduct()));
                          },
                          child: Text("Edytuj"),
                          color: Colors.blueGrey,
                          textColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          splashColor: Colors.white,
                        ),
                        width: 100,
                        height: 40,
                      ),
                    ]),
                  )))
        ]));
  }

  Container InnerTopWidget(String productName) {
    return Container(
      color: Colors.black,
      child: Text(productName),
    );
  }

  Container InnerBottomWidget(String productName) {
    return Container(
      color: Colors.red,
      child: Text(productName),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProduct()));
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
}
