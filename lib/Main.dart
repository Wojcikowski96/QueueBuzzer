import 'package:PointOwner/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String token;

  @override
  void initState() {
    setFirebase();
    loadToken().then((value) {
      this.token = value;
      print(value.toString());
    });
  }

  Future<String> loadToken() async {
    return await firebaseMessaging.getToken();
  }


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

void setFirebase() {
  var initializationSettingsIOS = IOSInitializationSettings();



  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _firebaseMessaging.configure(
    onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    onMessage: (message) async {
      print("onMessage: $message");
    },
    onLaunch: (message) async {
      print("onLaunch: $message");
    },
    onResume: (message) async {
      print("onResume: $message");
    },
  );

  _firebaseMessaging.getToken().then((String token) {
    print("Push Messaging token: $token");
    // Push messaging to this token later
  });

}

Future<String> onSelect(String data) async {
  print("onSelectNotification $data");
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("myBackgroundMessageHandler message: $message");
  int msgId = int.tryParse(message["data"]["msgId"].toString()) ?? 0;
  print("msgId $msgId");
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      'your channel description', color: Colors.blue.shade800,
      importance: Importance.Max,
      priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  flutterLocalNotificationsPlugin.show(msgId,
      message["data"]["msgTitle"],
      message["data"]["msgBody"], platformChannelSpecifics,
      payload: message["data"]["data"]);

  return Future<void>.value();
}