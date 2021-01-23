import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'Authorization/LoginPage.dart';
import 'Consumer Side/ConsumerHomeScreen.dart';
import 'Entities/Point.dart';
import 'Style/QueueBuzzerButtonStyle.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final storage = FlutterSecureStorage();

  String scanResult = "";
  bool btnVisible = false;

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
          title: Text(""),
          actions: <Widget>[
            SizedBox(
              child: RaisedButton.icon(
                  color: QueueBuzzerButtonStyle.color,
                  icon: Icon(Icons.fastfood),
                  label: Text("Zaloguj sie jako punkt"),
                onPressed: () {
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      content: Text('Yay! A SnackBar!')
                      ));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage(false)));
              }
              ),
              )
          ]
        ),

      body: Container(

        child: Center(
          child: Column(children: <Widget>[
            SizedBox(
              height: 65,
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
            SizedBox(
              height: 5,
            ),
            Text("Skąd chcesz zamówić jedzonko?",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),

            SizedBox(height: 100),
            SizedBox(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: QueueBuzzerButtonStyle.border,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(true)));
                },
                child: Text("Zaloguj się",
                  style: QueueBuzzerButtonStyle.textStyle,
                ),
                color: QueueBuzzerButtonStyle.color,
                textColor: QueueBuzzerButtonStyle.textColor,
                padding: QueueBuzzerButtonStyle.padding,
                splashColor: QueueBuzzerButtonStyle.splashColor,
              ),
              width: QueueBuzzerButtonStyle.width,
              height: QueueBuzzerButtonStyle.height,
            ),
            QueueBuzzerButtonStyle.span,
            SizedBox(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: QueueBuzzerButtonStyle.border,
                ),
                onPressed: scanQR,
                child: Text("Skanuj",
                  style: QueueBuzzerButtonStyle.textStyle,
                ),
                color: QueueBuzzerButtonStyle.color,
                textColor: QueueBuzzerButtonStyle.textColor,
                padding: QueueBuzzerButtonStyle.padding,
                splashColor: QueueBuzzerButtonStyle.splashColor,
              ),
              width: QueueBuzzerButtonStyle.width,
              height: QueueBuzzerButtonStyle.height,
            ),
            QueueBuzzerButtonStyle.span,
            Visibility(
                visible: btnVisible,
                child: SizedBox(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: QueueBuzzerButtonStyle.border,
                    ),
                    onPressed: () async {
                      await storage.write(key: "pointID", value: scanResult);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ConsumerHomeScreen(Point.withId(int.parse(scanResult)))));
                    },
                    child: Text("Kontynuj",
                      style: QueueBuzzerButtonStyle.textStyle,
                    ),
                    color: QueueBuzzerButtonStyle.color,
                    textColor: QueueBuzzerButtonStyle.textColor,
                    padding: QueueBuzzerButtonStyle.padding,
                    splashColor: QueueBuzzerButtonStyle.splashColor,
                  ),
                  height: QueueBuzzerButtonStyle.height,
                  width: QueueBuzzerButtonStyle.width,
                ),
                )
            ]
          ),
        )
      )
    );
  }

}