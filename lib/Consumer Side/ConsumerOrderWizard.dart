import 'dart:convert';
import 'dart:ui';

import 'package:PointOwner/Consumer%20Side/ConsumerHomeScreen.dart';
import 'package:PointOwner/Consumer%20Side/ConsumerOrderStatus.dart';
import 'package:PointOwner/Entities/Consumer.dart';
import 'package:PointOwner/Entities/Point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsumerOrderWizard extends StatefulWidget {

  Point point;
  Consumer consumer;

  ConsumerOrderWizard();

  ConsumerOrderWizard.withConsumer(this.point, this.consumer);

  @override
  State<StatefulWidget> createState() {
    if (consumer != null) {
      return _ConsumerOrderWizardState.withPointAndConsumer(point, consumer);
    } else {
      return _ConsumerOrderWizardState.withPoint(point);
    }
  }

}

class _ConsumerOrderWizardState extends State<ConsumerOrderWizard> {

  String pointName = "Nazwa restauracji";
  double totalPrice = 0.0;
  Point point;
  Consumer consumer;

  _ConsumerOrderWizardState();

  factory _ConsumerOrderWizardState.withPointAndConsumer(Point p, Consumer c) {
    return _ConsumerOrderWizardState().setPointAndConsumer(p, c);
  }

  factory _ConsumerOrderWizardState.withPoint(Point p) {
    return _ConsumerOrderWizardState().setPoint(p);
  }

  _ConsumerOrderWizardState setPointAndConsumer(Point p, Consumer c) {
    this.point = p;
    this.consumer = c;
    return this;
  }

  _ConsumerOrderWizardState setPoint(Point p) {
    this.point = p;
    this.consumer = Consumer();
    return this;
  }

  @override
  void initState() {
    super.initState();

    totalPrice = consumer.totalPrice();
    Future.delayed(Duration.zero, () async {
      String tempPointName = (await storage.read(key: "pointName")).toString();
      setState(() {
        pointName = tempPointName;
      });
      print('Init state');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,   //new line
        appBar: AppBar(
            title: Text(pointName),
            actions: <Widget>[
              SizedBox(
                child: RaisedButton.icon(
                    color: Colors.deepOrange,
                    icon: Icon(Icons.autorenew_outlined, color: Colors.white),
                    label: Text("Powrót do menu"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConsumerHomeScreen(point)));
                    }),
              )
        ]),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 43.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildOrderHeader(),
                Expanded(
                  child: _buildOrderList()
                ),
                _buildOrderSummary(context)
              ],
            ),
            ),
        );
  }

  Widget _buildOrderHeader() {
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          children: [
            Center(
                child: Text(
                  'Twoje zamówienie:',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.amber[300],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                'Osób w kolejce: ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: Text(
                '5',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.amber[300],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                'Średni czas oczekiwania: ',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            FutureBuilder<dynamic>(
              future: getProperties(),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(snapshot.data[1] + " s",
                      style: TextStyle(color: Colors.black, fontSize: 30));
                else if (snapshot.hasError) return Text(snapshot.error);
                return Text("Await for data");
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        // ),
      ),
    );
  }

  Widget _buildOrderList() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: consumer.basket.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.amber[100 + (index*100%1000)],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
              backgroundImage: NetworkImage("https://images.medicinenet.com/images/article/main_image/low-fiber-diet.jpg"),
            ),
                title: Text(consumer.basket.elementAt(index).name),
                trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[300],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(consumer.basket.elementAt(index).price)
                )
            )
          );

        }
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.amber[300],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              'Łączna kwota:',
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            totalPrice.toStringAsFixed(2) + ' PLN',
            style: TextStyle(fontSize: 30),
          ),
          RaisedButton(
              child: Text('Zamów'),
              color: Colors.deepOrange,
              onPressed: () {
                placeOrder();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConsumerOrderStatus(point))
                );
              })
        ],
      )
    );
  }

  Future<void> placeOrder() async {
    const SERVER_IP = 'http://10.0.2.2:8080';

    var res = await http.post("$SERVER_IP/consumer-order",
        body: jsonEncode(<String, dynamic>{
          "consumerId": 1,
          "pointId": point.pointID,
          "productsIds": getProductIdsFromBasket(),
          "stateName": "ACCEPTED",
        }),
        headers: <String, String>{"Content-Type": "application/json"}
    );
  }

  List<int> getProductIdsFromBasket() {
    List<int> ids = new List<int>();
    consumer.basket.forEach((element) {
      ids.add(element.productID);
    });
    return ids;
  }

}