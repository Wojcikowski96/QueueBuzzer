import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:PointOwner/Entities/ListsOrder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../Entities/Consumer.dart';
import '../Entities/Point.dart';

class ConsumerStory extends StatefulWidget {
  Point point;
  Consumer consumer;

  ConsumerStory(Point p) {
    this.point = p;
  }

  ConsumerStory.withConsumer(this.point, this.consumer);

  @override
  _ConsumerStoryState createState() {
    if (consumer != null) {
      return _ConsumerStoryState.withPointAndConsumer(point, consumer);
    } else {
      return _ConsumerStoryState.withPoint(point);
    }
  }
}

var storage = FlutterSecureStorage();
// Grid(TextEditingController pointID);

class _ConsumerStoryState extends State<ConsumerStory> {
  String pointName = "Nazwa restauracji";
  int categoryNumber = 0;
  double totalPrice = 0.0;
  List<String> orderProperties = [""];
  List<Widget> singleOrderWidgets = new List();
  List<Widget> basketList;
  List<List<List<Widget>>> all;
  Timer timer;
  var storageOut = FlutterSecureStorage();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String token;

  Point point;
  Consumer consumer;

  factory _ConsumerStoryState.withPoint(Point p) {
    return _ConsumerStoryState().setPoint(p);
  }

  Future<String> loadToken() async {
    return await firebaseMessaging.getToken();
  }

  factory _ConsumerStoryState.withPointAndConsumer(Point p, Consumer c) {
    return _ConsumerStoryState().setPointAndConsumer(p, c);
  }

  _ConsumerStoryState setPoint(Point p) {
    this.point = p;
    this.consumer = Consumer();
    return this;
  }

  _ConsumerStoryState setPointAndConsumer(Point p, Consumer c) {
    this.point = p;
    this.consumer = c;
    return this;
  }

  _ConsumerStoryState();

  @override
  void initState() {
    super.initState();
    print("Order properties w init " + orderProperties[0]);

    //loadToken().then((value) {
    //   this.token = value;
    //  print(value.toString());
    //});

    Future.delayed(Duration.zero, () async {
      //  String tempPointName = (await storage.read(key: "pointName")).toString();
      //  setState(() {
      //   pointName = tempPointName;
      // });
      //  print('Init state');
      List<dynamic> ordersParsed = await getAllOrders();

      List<Widget> tempSingleOrderWidgets = new List();

      for (var order in ordersParsed) {
        List<Widget> orderItems = new List();
        for (int i = 2; i < order.length; i++) {
          orderItems.add(basketItem(order[i][0], order[i][1]));
        }

        tempSingleOrderWidgets.add(singleOrderWidget(order[0], order[1], orderItems));
      }

      setState(() {
        singleOrderWidgets = tempSingleOrderWidgets;
      });

      print("Single order widgets " + singleOrderWidgets.length.toString());

      //generateStory();
    });
  }

  getOrderPropertiesFromJson(json) async {
    String deviceID = (await storage.read(key: "deviceID"));
    int consumerID = int.parse(deviceID);

    List<dynamic> orders = List<Map>.from(json)
        .map((Map model) => ListsOrder.fromJson(model))
        .toList();

    List<dynamic> ordersParsed = new List();

    for (int i = 0; i < orders.length; i++) {
      if (json[i]['consumerId'] == consumerID && json[i]['queueNumber'] > 0) {
        List<dynamic> singleOrder = new List();
        singleOrder.add(await getPointName(json[i]['pointId']));
        singleOrder.add(json[i]['stateName']);
        for (int j = 0; j < json[i]['productList'].length; j++) {
          List<dynamic> singleProduct = new List();
          singleProduct.add(json[i]['productList'][j]['name']);
          singleProduct.add(json[i]['productList'][j]['price']);
          singleOrder.add(singleProduct);
        }
        ordersParsed.add(singleOrder);
      }
    }
    print("OrdersParsed " + ordersParsed.toString());
    return ordersParsed;
  }

  getAllOrders() async {
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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var itemHeight = 270.0;

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Color(this.point.color),
          // leading: IconButton(icon: Icon(Icons.menu), onPressed: (){
          //
          // }),

          title: Text(pointName),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("food.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
              ),
            ),
            child: Column(children: [
              appHeader(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: List.generate(singleOrderWidgets.length,
                      (index) => singleOrderWidgets[index]),
                ),
              ))
            ])));
  }

  Padding singleOrderWidget(String pointName, String statusName, List<Widget> orderItems) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                pointName,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Status zamówienia:",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                statusName,
                style: TextStyle(fontSize: 25),
              ),
              Column(
                children: List.generate(
                    orderItems.length, (index) => orderItems[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding basketItem(String name, double price) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15.0),
        ),
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Text(
                  name,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(price.toString(),
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    textAlign: TextAlign.right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container appHeader() {
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          children: [
            Center(
                child: Text(
              'Twoja historia zamówień:',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            )),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        // ),
      ),
    );
  }

  Future<String> getPointName(int pointID) async {
    String pointName;
    String request = "http://10.0.2.2:8080/point/$pointID";
    var response = await http.get(request);
    var jsonMap =  jsonDecode(response.body) as Map<String, dynamic>;
    pointName = jsonMap["name"];
    return pointName;

  }
}
