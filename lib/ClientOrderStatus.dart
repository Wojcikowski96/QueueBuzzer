import 'dart:convert';
import 'dart:ui';

import 'package:PointOwner/ClientHomeScreen.dart';
import 'package:PointOwner/PointMenu.dart';
import 'package:PointOwner/qrGenerate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Point.dart';

class ClientOrderStatus extends StatefulWidget {

  Point point;

  ClientOrderStatus(Point p) {
    this.point = p;
  }

  @override
  _ClientOrderStatusState createState() => _ClientOrderStatusState.withPoint(point);

}


class _ClientOrderStatusState extends State<ClientOrderStatus> {

  Point point;

  factory _ClientOrderStatusState.withPoint(Point p) {
    return _ClientOrderStatusState()._(p);
  }
  _ClientOrderStatusState _(Point p) {
    this.point = p;
    return this;
  }
  _ClientOrderStatusState();

  var storage = FlutterSecureStorage();
  String pointID = "4";

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
                    MaterialPageRoute(builder: (context) => PointMenu(this.point)));
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

              },
            ),
          ],
        ),
      ),
      appBar: AppBar(

          title: Text(pointName),
          actions: <Widget>[
        SizedBox(
        child: RaisedButton.icon(
            color: Colors.deepOrange,
            icon: Icon(Icons.restaurant_menu),
            label: Text("Menu restauracji"),
              onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientHomeScreen(point)));
                }
            )
        )]
      ),



      body: ListView(
          children: [
            Center(child: Text('Złożone',style: TextStyle(fontSize: 40),)),
            Taken(Colors.deepOrange),
            Center(child: Text('W przygotowaniu',style: TextStyle(fontSize: 40),)),
            InProgress('grey'),
            Center(child: Text('Do odbioru',style: TextStyle(fontSize: 40),)),
            ToPickup('grey'),
          ],
      ),
    );

    // tutaj
  }
  Container Taken(MaterialColor color){
    return new Container(
      width: 150,
      height: 150,
      child: Center(child: Text('1',style: TextStyle(fontSize: 90,color: Colors.white),)),
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),

    );
  }
  Container InProgress(String color){
    return new Container(
      width: 150,
      height: 150,
      child: Center(child: Text('2',style: TextStyle(fontSize: 90,color: Colors.white),)),
      decoration: new BoxDecoration(
        color: Colors.deepOrange,
        shape: BoxShape.circle,
      ),

    );
  }

  Container ToPickup(String color){
    return new Container(
      width: 150,
      height: 150,
      child: Center(child: Text('3',style: TextStyle(fontSize: 90,color: Colors.white),)),
      decoration: new BoxDecoration(
        color: Colors.deepOrange,
        shape: BoxShape.circle,
      ),

    );
  }


}