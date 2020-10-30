import 'package:flutter/material.dart';
import 'package:PointOwner/loginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Właściciel Punktu',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: loginPage(),
    );
  }

}