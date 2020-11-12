import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EditProduct extends StatelessWidget {


  static const SERVER_IP = 'http://10.0.2.2:8080';
  Map <String,String> paramMap= {
    "name":"Name",
    "price":"0.0",
    "category":"Category"
  };

  EditProduct( Map <String,String> pMap){
    paramMap = pMap;
  }


  final TextEditingController productName = new TextEditingController();
  final TextEditingController productCategory = new TextEditingController();
  final TextEditingController productPrice = new TextEditingController();

  Future<String> patchProduct() async {
    var storage = FlutterSecureStorage();
    var pointID = (await storage.read(key: "pointID")).toString();
    print(pointID);
    var res = await http.patch(
        "$SERVER_IP/product",
        body: jsonEncode(<String, dynamic>{
          "category": productCategory.text,
          "name": productName.text,
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                      color: Color.fromRGBO(27, 27, 27, 1),
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
                      child: TextFormField(
                        controller: productName,
                        initialValue: paramMap["name"],
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
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent,
                                    width: 2
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blueAccent,
                                )
                            )
                        ),
                      )
                  ),

                  SizedBox(height: 25,),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: productCategory,
                        initialValue: paramMap["category"],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.assignment_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "kategoria",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent,
                                    width: 2
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blueAccent,
                                )
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 25,),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: productPrice,
                        initialValue: paramMap["price"],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.attach_money_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "cena",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent,
                                    width: 2
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blueAccent,
                                )
                            )
                        ),
                      )
                  ),

                  SizedBox(height: 25,),
                  SizedBox(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                      onPressed: (){
                          patchProduct();
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
}
