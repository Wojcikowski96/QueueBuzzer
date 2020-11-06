import 'package:PointOwner/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:PointOwner/LoginPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final storage = FlutterSecureStorage();
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Właściciel Punktu',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new Scaffold(body: new WelcomeScreen()),
    );
  }

}