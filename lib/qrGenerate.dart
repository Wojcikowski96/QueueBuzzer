import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

import 'Point.dart';

class GenerateQr extends StatefulWidget {

  Point point;

  GenerateQr(Point p) {
    this.point = p;
  }

  @override
  State<StatefulWidget> createState() => _GenerateQrState.withPoint(point);
}

class _GenerateQrState extends State<GenerateQr> {
  Point point;
  final TextEditingController qrdataFeed = new TextEditingController();
  String qrData = "";


  factory _GenerateQrState.withPoint(Point p) {
    return _GenerateQrState().withPoint(p);
  }
  _GenerateQrState withPoint(Point p) {
    this.point = p;
    qrData = point.pointID.toString();
    qrdataFeed.text = point.pointsName;
    return this;
  }
  _GenerateQrState(); // already generated qr code when the page opens

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generator QR'),
        actions: <Widget>[],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImage(
              //plce where the QR Image will be shown
              data: qrData,
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              "Punkt: ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0, color: Colors.blueAccent),
            ),
            Text(
              qrdataFeed.text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.0, color: Colors.redAccent),
            ),
            /*TextField(
              controller: qrdataFeed,
              decoration: InputDecoration(
                hintText: "Punkt: " + qrdataFeed.text,
              ),
            ),*/
            Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: FlatButton(
                padding: EdgeInsets.all(15.0),
                onPressed: () async {

                  if (qrdataFeed.text.isEmpty) {        //a little validation for the textfield
                    setState(() {
                      qrData = "";
                    });
                  } else {
                    setState(() {
                      qrData = qrdataFeed.text;
                    });
                  }

                },
                child: Text(
                  "Druk",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue, width: 3.0),
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            )
          ],
        ),
      ),
    );
  }

}