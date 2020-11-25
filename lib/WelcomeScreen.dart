import 'dart:ui';

import 'package:PointOwner/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'ConsumerHomeScreen.dart';
import 'Point.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final storage = FlutterSecureStorage();

  String scanResult = "";
  bool btnVisible = false;

  //function that launches the scanner
  Future scanQR() async {
    String cameraScanResult = await scanner.scan();
    setState(() {
      scanResult = cameraScanResult;
      btnVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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

        child: Center(
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
              "Witam w mojej kuchni: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Color.fromRGBO(27, 27, 27, 1),
              ),
            ),
            scanResult == '' ? Text('') : Text(scanResult),
            /**/
            SizedBox(
              height: 5,
            ),
            Text("Skąd chcesz zamówić jedzonko?",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),

            SizedBox(height: 200,),
            SizedBox(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                onPressed: scanQR,
                child: Text("Skanuj",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
                color: Colors.deepOrange,
                textColor: Colors.black,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                splashColor: Colors.white,
              ),
              width: 250,
              height: 70,
            ),

            Visibility(
                visible: btnVisible,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  onPressed: () async {
                    await storage.write(key: "pointID", value: scanResult);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConsumerHomeScreen(Point.withId(int.parse(scanResult)))));
                  },
                  child: Text("Kontynuj",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  color: Colors.deepOrange,
                  textColor: Colors.black,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  splashColor: Colors.white,
                )),
            ]
          ),
        )
      )
    );
  }
}