import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../Consumer Side/ConsumerHomeScreen.dart';
import '../Entities/Point.dart';
import 'PointMenu.dart';

class EditProduct extends StatelessWidget {
  static const SERVER_IP = 'http://10.0.2.2:8080';
  File _image;
  String productId;
  Point point;

  final picker = ImagePicker();
  String pictureName = "Ścieżka";

  Map<String, dynamic> paramMap = {
    "id": "ID",
    "name": "Name",
    "price": "0.0",
    "category": "Category",
    "img": "Picture",
    "point": null
  };

  final TextEditingController productName = new TextEditingController();
  final TextEditingController productCategory = new TextEditingController();
  final TextEditingController productPrice = new TextEditingController();
  final TextEditingController productPicture = new TextEditingController();

  EditProduct(Map<String, dynamic> pMap) {
    paramMap = pMap;
    productId = paramMap["id"];
    point = paramMap["point"];
    productName.text = paramMap["name"];
    productCategory.text = paramMap["category"];
    productPrice.text = paramMap["price"];
    productPicture.text = paramMap["img"];
  }

  Future<String> patchProduct() async {

    print(point.pointsName);
    var res =
        await http.patch("$SERVER_IP/product/$productId", //dodac /ID produktu
            body: jsonEncode(<String, dynamic>{
              "category": productCategory.text,
              "name": productName.text,
              "price": double.parse(productPrice.text),
            }),
            headers: <String, String>{"Content-Type": "application/json"});
    print(res.statusCode);
    print(res.body);

    if (res.statusCode != 201) {
      return res.body;
    } else {
      return null;
    }
  }

  uploadFile() async {
    var postUri = Uri.parse("$SERVER_IP/product/$productId/image");
    var request = new http.MultipartRequest("POST", postUri);

    request.files.add(http.MultipartFile(
      'file',
      _image.readAsBytes().asStream(),
      _image.lengthSync(),
      filename: "Obrazek żarełka",
      contentType: MediaType('image', 'jpeg'),
    ));
    http.StreamedResponse r = await request.send();
    print(r.statusCode);
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);

      pictureName = basename(pickedFile.path);
      productPicture.text = pictureName;
    } else {
      print('No image selected.');
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
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: productName,
                        // initialValue: paramMap["name"],
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.assignment_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            // hintText: "Nazwa produktu",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blueAccent,
                                ))),
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: productCategory,
                        // initialValue: paramMap["category"],
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.assignment_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "kategoria",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blueAccent,
                                ))),
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: productPrice,
                        // initialValue: paramMap["price"],
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.attach_money_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "cena",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blueAccent,
                                ))),
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: productPicture,
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(1),
                        ],
                        // initialValue: paramMap["category"],
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.assignment_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: pictureName,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blueAccent,
                                ))),
                        onTap: () {
                          getImage();
                        },
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        uploadFile();
                        patchProduct();

                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PointMenu(point)));
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
