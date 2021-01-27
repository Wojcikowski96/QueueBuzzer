import 'dart:convert';
import 'package:PointOwner/Style/QueueBuzzerButtonStyle.dart';
import 'package:PointOwner/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'LoginPage.dart';
class registerPage extends StatefulWidget {
  bool isConsumer;
  registerPage(this.isConsumer);
  static const SERVER_IP = 'http://10.0.2.2:8080';

  @override
  _registerPageState createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  TextEditingController emailTextEditController = new TextEditingController();

  TextEditingController passwordTextEditController = new TextEditingController();

  final inputKey = GlobalKey<FormState>();

  Future<int>postPointOwner(String email, String password) async {
    var res = await http.post(
        "${registerPage.SERVER_IP}/point-owner",
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

  Future<int> postConsumer(String email, String password) async {
    var res = await http.post(
        "${registerPage.SERVER_IP}/consumer",
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
        resizeToAvoidBottomInset: false,   //new line
        body: Form(
            key: inputKey,
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
                        validator: (input){
                          if(input.isEmpty){
                            return "Empty";

                          }else if(input != passwordTextEditController.text){
                            return "Passwords does not Match";
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
                Builder(
                  builder: (context) => SizedBox(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: QueueBuzzerButtonStyle.border,
                      ),

                      onPressed: () async{
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (!inputKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text('You enetered wrong values')));
                          // Fluttertoast.showToast(
                          //     msg: 'Zarejestrowano użytkownika',
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.CENTER,
                          //     timeInSecForIos: 1,
                          //     backgroundColor: Colors.green,
                          //     textColor: Colors.white
                          // );
                        // if(emailInputKey.currentState.validate() == "Empty" ||
                        //     passwordInputKey.currentState.validate() == "Empty" ||
                        //     repeatedPasswordInputKey.currentState.validate() == "Empty") {
                        //   displayDialog(context,  "An Error Occurred", "Please fill up every text field");
                        // } else if(repeatedPasswordInputKey.currentState.validate() == "Not Match") {
                        //   displayDialog(context,  "An Error Occurred", "The passwords do not match");
                        } else {
                          if(widget.isConsumer){
                            //consumerPostRequest
                            if( await postConsumer(emailTextEditController.text, passwordTextEditController.text) == 201){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(widget.isConsumer)
                                  )
                              );
                            }else{
                              displayDialog(context,  "An Error Occurred", "An account with this name already exists");
                            }
                          }else{
                            //pointOwnerPostRequest
                            if(await postPointOwner(emailTextEditController.text, passwordTextEditController.text) == 201){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(widget.isConsumer)
                                  )
                              );
                            }else{
                              displayDialog(context,  "An Error Occurred", "An account with this email already exists");
                            }
                          }
                        }
                      },
                      child: Text("Zarejestruj", style: QueueBuzzerButtonStyle.textStyle,),
                      color: QueueBuzzerButtonStyle.color,
                      textColor: QueueBuzzerButtonStyle.textColor,
                      padding: QueueBuzzerButtonStyle.padding,
                      splashColor: QueueBuzzerButtonStyle.splashColor,
                    ),
                    width: QueueBuzzerButtonStyle.width,
                    height: QueueBuzzerButtonStyle.height,
                  ),
                ),
                  QueueBuzzerButtonStyle.span,
                  Text("Masz już konto?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),

                  ),
                  QueueBuzzerButtonStyle.span,
                  SizedBox(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: QueueBuzzerButtonStyle.border,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Zaloguj", style: QueueBuzzerButtonStyle.textStyle,),
                      color: QueueBuzzerButtonStyle.color,
                      textColor: QueueBuzzerButtonStyle.textColor,
                      padding: QueueBuzzerButtonStyle.padding,
                      splashColor: QueueBuzzerButtonStyle.splashColor,
                    ),
                    width: QueueBuzzerButtonStyle.width,
                    height: QueueBuzzerButtonStyle.height,
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
