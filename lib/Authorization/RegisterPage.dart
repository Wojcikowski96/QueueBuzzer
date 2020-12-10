import 'dart:convert';
import 'package:PointOwner/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'LoginPage.dart';
class registerPage extends StatelessWidget {
  bool isConsumer;
  registerPage(this.isConsumer);
  TextEditingController emailTextEditController = new TextEditingController();
  TextEditingController passwordTextEditController = new TextEditingController();
  final GlobalKey<FormState> inputKey = GlobalKey<FormState>();
  static const SERVER_IP = 'http://10.0.2.2:8080';
  postPointOwner(String email, String password) async {
    var res = await http.post(
        "$SERVER_IP/point-owner",
        body: jsonEncode(<String, String>{
          "emial": email,
          "password": password
        }),
        headers: <String, String>{
          "Content-Type": "application/json"
        }
    );
    return res.statusCode;
  }
  postConsumer(String email, String password) async {
    var res = await http.post(
        "$SERVER_IP/consumer",
        body: jsonEncode(<String, String>{
          "emial": email,
          "password": password
        }),
        headers: <String, String>{
          "Content-Type": "application/json"
        }
    );
    return res.statusCode;
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
                    "register.jpg",
                    width: width * 0.5,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "Zarejestruj się:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Color.fromRGBO(27, 27, 27, 1),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Wpisz swoje dane:",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),

                  SizedBox(height: 25,),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        key: inputKey,
                        validator: (input){
                          if(input.isEmpty){
                            return "Empty";
                          }
                          return null;
                        },
                        controller: emailTextEditController,
                        decoration: InputDecoration(

                            contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.person_outline),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "Email użytkownika",
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
                        key: inputKey,
                        validator:(input){
                          if(input.isEmpty){
                            return "Empty";
                          }
                          return null;
                        },
                        controller: passwordTextEditController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.accessibility_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "Hasło",
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
                        key: inputKey,
                        validator: (input){
                          if(input.isEmpty){
                            return "Empty";

                          }else if(input != passwordTextEditController.text){
                            return "Not Match";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Icon(Icons.accessibility_outlined),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.7),
                            hintText: "Powtórz Hasło",
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
                        if(inputKey.currentState.validate() == "Empty"){
                          displayDialog(context,  "An Error Occurred", "Please fill up every text field");
                        }else if(inputKey.currentState.validate() == "Not Match"){
                          displayDialog(context,  "An Error Occurred", "The passwords do not match");
                        }else{
                          if(isConsumer){
                            //consumerPostRequest
                            if(postConsumer(emailTextEditController.text, passwordTextEditController.text) == 200){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(isConsumer)
                                  )
                              );
                            }else{
                              displayDialog(context,  "An Error Occurred", "An account with this name already exists");
                            }
                          }else{
                            //pointOwnerPostRequest
                            if(postPointOwner(emailTextEditController.text, passwordTextEditController.text) == 200){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(isConsumer)
                                  )
                              );
                            }else{
                              displayDialog(context,  "An Error Occurred", "An account with this email already exists");
                            }
                          }
                        }
                      },
                      child: Text("Zarejestruj"),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      splashColor: Colors.white,
                    ),
                    width: 200,
                    height: 70,
                  ),
                  SizedBox(height: 5,),
                  Text("Masz już konto?",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),

                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Zaloguj"),
                    color: Colors.deepOrange,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    splashColor: Colors.white,

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
