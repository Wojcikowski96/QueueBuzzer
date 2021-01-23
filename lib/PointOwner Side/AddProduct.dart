import 'dart:collection';
import 'dart:convert';

import 'package:PointOwner/Style/QueueBuzzerButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Entities/Point.dart';
import 'PointMenu.dart';


class AddProduct extends StatefulWidget {

  Point point;

  AddProduct(Point p) {
    this.point = p;
  }
  @override
  _AddProductPageState createState() => _AddProductPageState.withPoint(this.point);
}

class _AddProductPageState extends State<AddProduct> {

  Point point;

  factory _AddProductPageState.withPoint(Point p) {
    return _AddProductPageState()._(p);
  }
  _AddProductPageState _(Point p) {
    this.point = p;
    return this;
  }
  _AddProductPageState();


  final TextEditingController productName = new TextEditingController();
  final TextEditingController productCategory = new TextEditingController();
  final TextEditingController productDescription = new TextEditingController();
  final TextEditingController productPrice = new TextEditingController();

  static const SERVER_IP = 'http://10.0.2.2:8080';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    Future<String> submitProduct() async {
      //create request
      //post post request
      //   {
      //     "avaliability": true,
      //   "category": "string",
      //   "description": "string",
      //   "name": "string",
      //   "point": 0,
      //   "price": 0
      // }
      var storage = FlutterSecureStorage();
      var pointID = (await storage.read(key: "pointID")).toString();
      print(pointID);
      var res = await http.post(
          "$SERVER_IP/product",
          body: jsonEncode(<String, dynamic>{
              "avaliability": true,
              "category": productCategory.text,
              "description": productDescription.text,
              "name": productName.text,
              "point": int.parse(pointID),
              "price": double.parse(productPrice.text)
          }),
          headers: <String, String>{
            "Content-Type": "application/json"
          }
      );
      print(res.statusCode);
      print(res.body);

      if(res.statusCode != 201) {
        return res.body;
      } else {
        return null;
      }
    }

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                width: width,
                child: Column(children: <Widget>[
                  SizedBox(
                    height: height * 0.08,

                  ),
                  Image.asset(
                    "editProduct.png",
                    width: width * 0.5,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "Edit Product:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: QueueBuzzerButtonStyle.textColor,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Uzupelnij dane produktu:",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),

                  SizedBox(height: 25,),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        controller: productName,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.assignment_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "Nazwa produktu",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: QueueBuzzerButtonStyle.border,
                                borderSide: BorderSide(
                                    color: QueueBuzzerButtonStyle.color,
                                    width: 2
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: QueueBuzzerButtonStyle.border,
                                borderSide: BorderSide(
                                  width: 2,
                                  color: QueueBuzzerButtonStyle.color,
                                )
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 25,),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        controller: productCategory,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.assignment_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "Kategoria",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: QueueBuzzerButtonStyle.border,
                                borderSide: BorderSide(
                                    color: QueueBuzzerButtonStyle.color,
                                    width: 2
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: QueueBuzzerButtonStyle.border,
                                borderSide: BorderSide(
                                  width: 2,
                                  color: QueueBuzzerButtonStyle.color,
                                )
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 25,),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        minLines: 3,
                        controller: productDescription,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
                            // prefixIcon: Padding(
                            //   padding: const EdgeInsets.only(left: 10, right: 10),
                            //   // child: Icon(Icons.assignment_outlined),
                            // ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "Opis produktu",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: QueueBuzzerButtonStyle.border,
                                borderSide: BorderSide(
                                    color: QueueBuzzerButtonStyle.textColor,
                                    width: 2
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: QueueBuzzerButtonStyle.border,
                                borderSide: BorderSide(
                                  width: 2,
                                  color: QueueBuzzerButtonStyle.textColor,
                                )
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 25,),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        controller: productPrice,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.attach_money_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "Cena",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: QueueBuzzerButtonStyle.border,
                                borderSide: BorderSide(
                                    color: QueueBuzzerButtonStyle.color,
                                    width: 2
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: QueueBuzzerButtonStyle.border,
                                borderSide: BorderSide(
                                  width: 2,
                                  color: QueueBuzzerButtonStyle.color,
                                )
                            )
                        ),
                      )
                  ),

                  SizedBox(height: 25,),
                  SizedBox(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: QueueBuzzerButtonStyle.border,
                      ),

                      onPressed: () async {
                          if (await submitProduct() != null) {
                            displayDialog(context, "An Error Occurred", "No account was found matching that pointEmail");
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PointMenu(this.point)
                                )
                            );
                          }
                      },
                      child: Text("Potwierdż"),
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      splashColor: Colors.white,
                    ),
                    width: 200,
                    height: 70,
                  ),

                ]))));
  }
  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                title: Text(title),
                content: Text(text)
            ),
      );
}
