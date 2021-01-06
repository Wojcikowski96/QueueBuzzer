
import 'dart:ui';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'Authorization/LoginPage.dart';
import 'Consumer Side/ConsumerHomeScreen.dart';
import 'Entities/Point.dart';

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

            SizedBox(height: 130,),
            SizedBox(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(true)));
                },
                child: Text("Zaloguj się",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                color: Colors.deepOrange,
                textColor: Colors.black,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                splashColor: Colors.white,
              ),
              width: 150,
              height: 40,
            ),
            SizedBox(height: 20,),
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
                    String deviceId = "1";
                    deviceId = deviceId.replaceAll(new RegExp(r'[^0-9]'),'');
                    await storage.write(key: "deviceID", value: deviceId);
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
  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}