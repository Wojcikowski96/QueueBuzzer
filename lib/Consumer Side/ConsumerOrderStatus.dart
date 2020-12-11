import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:PointOwner/PointOwner%20Side/PointMenu.dart';
import 'package:PointOwner/PointOwner%20Side/qrGenerate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../Entities/ListsItem.dart';
import '../Entities/Point.dart';
import 'ConsumerHomeScreen.dart';

class ConsumerOrderStatus extends StatefulWidget {

  Point point;


  ConsumerOrderStatus(Point p) {
    this.point = p;
  }

  @override
  _ConsumerOrderStatusState createState() => _ConsumerOrderStatusState.withPoint(point);

}

getOrderPropertiesFromJson(json) {
  List<dynamic> orders = List<Map>.from(json)
      .map((Map model) => ListsItem.fromJson(model))
      .toList();
  List<String> properties = new List();
  for (int i = 0; i<orders.length; i++){
    if (json[i]['queueNumber'] > 0) {
      properties.add(json[i]['stateName']);
      properties.add(json[i]['queueNumber'].toString());
    }
  }
  return properties;
}

getOrderProperties() async {
  var jsonResponse = null;
  String request = "http://10.0.2.2:8080/consumer-order";
  var response = await http.get(request);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);


    if (jsonResponse != null) {
      var decoded = json.decode(response.body);
      return getOrderPropertiesFromJson(decoded);
    }
  }
}

class _ConsumerOrderStatusState extends State<ConsumerOrderStatus> {

  Point point;
  MaterialColor color = Colors.grey;
  Color colorStatus = Colors.grey;

  factory _ConsumerOrderStatusState.withPoint(Point p) {
    return _ConsumerOrderStatusState()._(p);
  }
  _ConsumerOrderStatusState _(Point p) {
    this.point = p;
    return this;
  }
  _ConsumerOrderStatusState();
  final storageIn = FlutterSecureStorage();
  var storageOut = FlutterSecureStorage();
  String pointID = "4";
  String queueNumber = "0";
  String pointName = "kiedys tu bedize nazwa restauracji";
  String status = 'nothing';
  Timer timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      String tempPointName = (await storageOut.read(key: "pointName")).toString();
      List<String> tempProperties = await getOrderProperties();
      setState(() {
        pointName  = tempPointName;
        queueNumber = tempProperties[1];
        status = tempProperties[0];
        if(status == "ACCEPTED"){
          colorStatus = Color(point.color);

        }
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
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateQr(point)));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
          backgroundColor: Color(this.point.color),
          title: Text(pointName),
          actions: <Widget>[
        SizedBox(
        child: RaisedButton.icon(
            color: Color(this.point.color),
            icon: Icon(Icons.restaurant_menu),
            label: Text("Menu restauracji"),
              onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsumerHomeScreen(point)));
                }
            )
        )]
      ),



      body: ListView(
          children: [
            Center(child: Text('Twój numer',style: TextStyle(fontSize: 40),)),
            number(Color(this.point.color), queueNumber),
            Center(child: Text('Złożone',style: TextStyle(fontSize: 40),)),
            Taken(colorStatus),
            Center(child: Text('W przygotowaniu',style: TextStyle(fontSize: 40),)),
            InProgress(color),
            Center(child: Text('Do odbioru',style: TextStyle(fontSize: 40),)),
            ToPickup(color),
          ],
      ),

    );

    // tutaj
  }
  Container Taken(Color color){

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
  Container InProgress(Color color){
    return new Container(
      width: 150,
      height: 150,
      child: Center(child: Text('2',style: TextStyle(fontSize: 90,color: Colors.white),)),
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),

    );
  }

  Container ToPickup(Color color){
    return new Container(
      width: 150,
      height: 150,
      child: Center(child: Text('3',style: TextStyle(fontSize: 90,color: Colors.white),)),
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),

    );
  }

  Container number(Color color, String number){
    return new Container(
      width: 250,
      height: 250,
      child: Center(child: Text(number,style: TextStyle(fontSize: 90,color: Colors.white),)),
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),

    );

  }





}