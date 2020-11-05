import 'dart:convert';
import 'dart:ui';

import 'package:PointOwner/LoginPage.dart';
import 'package:PointOwner/PointHomeScreen.dart';
import 'package:PointOwner/PointMenu.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
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

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(icon: Icon(Icons.menu), onPressed: (){
        //
        // }),
          title: Text(""),
          actions: <Widget>[
            SizedBox(
              child: RaisedButton.icon(
                  color: Colors.deepOrange,
                  icon: Icon(Icons.fastfood),
                  // child: Center(child: Text("Zaloguj sie jako punkt")),
                  label: Text("Zaloguj sie jako punkt"),
                onPressed: () {
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      content: Text('Yay! A SnackBar!')
                      ));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
              }
              ),
              )
          ]
        ),

      body: Container(

        child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Image.asset(
            "restaurant.png",
            width: width * 0.5,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Sieeeemanko witam w mojej kuchni:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: Color.fromRGBO(27, 27, 27, 1),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text("Skąd chcesz zamówić jedzonko?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey)),

          ]
        )
      )
    );

  }
}