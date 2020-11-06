import 'dart:convert';

import 'package:PointOwner/PointHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'PointHomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'RegisterPage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = true;

  static const SERVER_IP = 'http://10.0.2.2:8080';
  final storage = FlutterSecureStorage();



  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Future<String> attemptLogIn(String username, String password) async {
    print('password:$password');
    print('usrname:$username');
    print('serverip:$SERVER_IP');
    var res = await http.post(
        "$SERVER_IP/auth",
        body: jsonEncode(<String, String>{
          "username": username,
          "password": password
        }),
        headers: <String, String>{
          "Content-Type": "application/json"
        }
    );
    if(res.statusCode == 200) return res.body;
    return null;
  }

  Future<int> attemptSignUp(String username, String password) async {
    var res = await http.post(
        '$SERVER_IP/signup',
        body: {
          "username": username,
          "password": password
        }
    );
    return res.statusCode;

  }

  signIn(String id, email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var username = emailController.text;
    var password = passwordController.text;
    var jwt = await attemptLogIn(username, password);
    if(jwt != null) {
      storage.write(key: "jwt", value: jwt);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PointHomeScreen.fromBase64(jwt)
          )
      );
    } else {
      displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
    }

    // var jsonResponse = null;
    // var response = await http.get("http://10.0.2.2:8080/point-owner/covid19@gmail.com");
    // if(response.statusCode == 200) {
    //   jsonResponse = json.decode(response.body);
    //   if(jsonResponse != null) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     String s = jsonResponse['point']['id'].toString();
    //     sharedPreferences.setString("token", s);
    //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PointHomeScreen()), (Route<dynamic> route) => false);
    //   }
    //   print(response.body.toString());
    // } else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   print(response.body.toString());
    // }
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
                    "restaurant.png",
                    width: width * 0.5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Zaloguj się:",
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
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Icon(Icons.person_outline),
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.7),
                        hintText: "Nazwa punktu",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.deepOrange,
                            width: 2
                          )
                        ),
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.deepOrange,
                          )
                      )
                      ),
                    )
                  ),
                  SizedBox(height: 25,),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        controller: passwordController,
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
                                color: Colors.deepOrange,
                                width: 2
                              )
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.deepOrange,
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
                      //emailController.text == "" || passwordController.text == "" ? null :
                      onPressed: () {
                        if (!(emailController.text == "" || passwordController.text == "")) {
                          print('onPressed started');
                          setState(() {
                            _isLoading = false;
                          });
                          signIn(emailController.text, passwordController.text);
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                        }

                      },
                      child: Text("Zaloguj"),
                      color: Colors.deepOrange,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      splashColor: Colors.white,
                    ),
                    width: 200,
                    height: 70,
                  ),
                  SizedBox(height: 5,),
                  Text("Nie masz u nas konta?",
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => registerPage()),
                      );
                    },
                    child: Text("Zarejestruj"),
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
