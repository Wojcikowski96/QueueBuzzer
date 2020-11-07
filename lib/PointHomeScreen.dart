import 'dart:convert';
import 'dart:ui';

import 'package:PointOwner/PointMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PointHomeScreen extends StatefulWidget {
  @override
  _PointHomeScreenState createState() => _PointHomeScreenState();

  PointHomeScreen(this.jwt, this.payload);

  factory PointHomeScreen.fromBase64(String jwt) =>
      PointHomeScreen(
          jwt,
          json.decode(
              ascii.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );

  final String jwt;
  final Map<String, dynamic> payload;
}

class ListsItem {
  String name, price, category;

   static fromJson(json) {
    ListsItem p = new ListsItem();
    print(json);
    p.name = json['name'];
    p.price = json['price'];
    p.category = json['category'];
    return p;
  }
}

class _PointHomeScreenState extends State<PointHomeScreen> {

  var storage = FlutterSecureStorage();
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
          child: Text('Twoje menu:',
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

  String pointName = "kiedys tu bedize nazwa restauracji";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      String tempPointName = (await storage.read(key: "pointName")).toString();
      setState(() {
        pointName  = tempPointName;
      });
    });
  }

    @override
    Widget build(BuildContext context) {
      var screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      return Scaffold(
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
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Edytuj menu'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PointMenu()));
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
            title: Text(pointName),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.people), onPressed: () {
                Scaffold.of(context).showSnackBar(new SnackBar(
                    content: Text('Yay! A SnackBar!')
                ));
              })
            ]
        ),


        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.deepOrange,
        //   child: Icon(Icons.add),
        //   onPressed: () {
        //     //tutaj dodac dodawanie do bazy
        //     setState(() {
        //       gridChild.add(Container(
        //           child: SimpleFoldingCell(
        //             frontWidget: FrontWidget("Pizza", "20.0", "Italia"),
        //             innerTopWidget: InnerTopWidget(),
        //             innerBottomWidget: InnerBottomWidget(),
        //
        //             cellSize: Size(screenWidth, itemHeight),
        //             // padding: EdgeInsets.all(8.0)
        //           )
        //       ),);
        //     });
        //   },
        // ),
        body: Container(
          // child: GridView.count(
          //   crossAxisCount: 1,
          //   childAspectRatio: (screenWidth / itemHeight),
          //   children: List.generate(
          //       gridChild.length, (index) => gridChild[index]),
          // ),
        ),
      );

      // tutaj
    }

  // Container FrontWidget(String productName, String productPrice, String productCategory) {
  // // Container FrontWidget() {
  //   return Container(
  //       color: Colors.white12,
  //       alignment: Alignment.center,
  //       child: Row(children: <Widget>[
  //         Expanded(
  //           // flex: 1,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(15.0),
  //                 color: Colors.deepOrange,
  //               ),
  //               child: Container(
  //                   child: Row(children: <Widget>[
  //                     Container(
  //                       child: Align(
  //                         alignment: Alignment.center,
  //                         child: Text(productPrice,
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 15,
  //
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(),
  //                   ])
  //               ),
  //             )
  //         ),
  //         Expanded(
  //           // flex: 2,
  //             child: Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(15.0),
  //                   color: Colors.white70,
  //                 ),
  //                 child: Container(
  //                   child: Column(children: <Widget>[
  //                     Container(
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Text(productName,
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 15,
  //
  //                           ),),
  //                       ),
  //                     ),
  //                     Image.asset("pizza.jpg",
  //                       height: 100,
  //                       width: 100,
  //                     ),
  //
  //                     Text('productCategory'
  //                     ),
  //                     SizedBox(
  //                       child: RaisedButton(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         onPressed: () {
  //
  //                         },
  //                         child: Text("Edytuj"),
  //                         color: Colors.deepOrange,
  //                         textColor: Colors.white,
  //                         padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
  //                         splashColor: Colors.white,
  //                       ),
  //                       width: 100,
  //                       height: 40,
  //                     ),
  //                   ]),
  //
  //
  //                 )
  //             )
  //         )
  //       ])
  //   );
  // }
  // Container InnerTopWidget() {
  //   return Container(
  //       color: Colors.blueGrey
  //
  //   );
  // }
  // Container InnerBottomWidget() {
  //   return Container(
  //       color: Colors.white
  //   );
  // }
  }