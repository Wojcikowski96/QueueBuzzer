import 'dart:convert';
import 'dart:ui';

import 'package:PointOwner/PointOwner%20Side/qrGenerate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Entities/Point.dart';
import 'PointMenu.dart';
import 'PointOwnerOrderStatus.dart';

class PointHomeScreen extends StatefulWidget {
  Point point;

  @override
  _PointHomeScreenState createState() => _PointHomeScreenState.withPoint(point);

  PointHomeScreen(this.jwt, this.payload, this.point);

  factory PointHomeScreen.fromBase64(String jwt, Point p) {
    p.jwt = jwt;
    p.payload = json.decode(
                      ascii.decode(
                          base64.decode(base64.normalize(jwt.split(".")[1]))
                      ));

    return PointHomeScreen(p.jwt, p.payload, p);
  }

  final String jwt;
  final Map<String, dynamic> payload;
}

class _PointHomeScreenState extends State<PointHomeScreen> {

  Point point;

  factory _PointHomeScreenState.withPoint(Point p) {
    return _PointHomeScreenState().withPoint(p);
  }

  _PointHomeScreenState withPoint(Point p) {
    this.point = p;
    return this;
  }

  _PointHomeScreenState();

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
      // String tempPointName = (await storage.read(key: "pointName")).toString();
      String tempPointName = point.pointsName;
      setState(() {
        pointName  = tempPointName;
      });
    });
  }

    @override
    Widget build(BuildContext context) {

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
                  color: Color(this.point.color),
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
                      MaterialPageRoute(builder: (context) => PointMenu(point)));
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GenerateQr(point)));
                },
              ),
              ListTile(
                title: Text('Order Status'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PointOwnerOrderStatus(point)));
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
  }