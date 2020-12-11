import 'dart:convert';

import 'package:PointOwner/Entities/Point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfigScreen extends StatefulWidget {
  Point point;

  @override
  _ConfigScreenState createState() => _ConfigScreenState(point);

  ConfigScreen(this.point);
}

class _ConfigScreenState extends State<ConfigScreen> {
  Point point;

  RegExp regExp = new RegExp(
    r"^#[0-9a-f]{3}([0-9a-f]{3})?$",
    caseSensitive: false,
    multiLine: false,
  );
  _ConfigScreenState(this.point);

  final _color = new TextEditingController();

  Future<void> sendColorChange() async {
    var jsonBody = jsonEncode(<String, dynamic>{
      "colour": _color.text,
    });
     var response =  await http.patch('http://10.0.2.2:8080/point/${this.point.pointID}', headers: <String, String>{
      "Content-Type": "application/json"
    }, body: jsonBody);
     if(response == 201) {
       setState(() => this.point.color = Point.convertHtmlColorIntoInt(this._color.text));
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Point customization"),
        centerTitle: true,
        backgroundColor: Color(this.point.color),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: TextFormField(
                controller: _color,
                validator: (value) => regExp.hasMatch(value) ? null : "Enter a color in hexadecimal. Like #FFFFFFFFF",
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text("Change color"),
                color: Color(this.point.color),
                onPressed: sendColorChange,
              ),
            )
          ],
        ),
      )
    );
  }
}