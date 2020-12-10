import 'dart:convert';

import '../Entities/Point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../PointOwner Side/PointHomeScreen.dart';
import 'package:http/http.dart' as http;
import 'RegisterPage.dart';


class LoginPage extends StatefulWidget {
  bool isConsumer;
  @override
  _LoginPageState createState() => _LoginPageState();
  LoginPage(this.isConsumer);

}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = true;

  static const SERVER_IP = 'http://10.0.2.2:8080';
  final storage = FlutterSecureStorage();

  Point point;



  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Future<String> attemptLogIn(String username, String password) async {
    // print('password:$password');
    // print('usrname:$username');
    // print('serverip:$SERVER_IP');
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

    var userType = jsonDecode(res.body)["userType"];
    if (res.statusCode == 200) {
      if ((widget.isConsumer == true && userType == "consumer") ||
          (widget.isConsumer == false && userType == "pointOwner")) {
        return jsonDecode(res.body)["jwt"];
      }
      return null;
    }
  }
  Future<int> attemptSignUp(String username, String password) async {
    var res = await http.post(
        '$SERVER_IP/signup',
        body: {
          "username": username,
          "password": password
        },
    );
    return res.statusCode;

  }

  Future<int> getPointByMail(String pointEmail) async {
    var res = await http.get(
        "$SERVER_IP/point-owner/" + pointEmail
    );
    if(res.statusCode != 200) {
      displayDialog(context, "An Error Occurred", "No account was found matching that pointEmail");
      print(res.body);
    } else {
      var jsonResponse = json.decode(res.body);
      var jsonPointEncoded = json.encode(jsonResponse["point"]);
      var jsonPoint = json.decode(jsonPointEncoded);

      if (jsonPoint != null) {
        storage.write(key: "pointName", value: jsonPoint["name"]);
        storage.write(key: "pointID", value: jsonPoint["id"].toString());
        point = new Point.withIdAndName(jsonPoint["id"], jsonPoint["name"]);
      }
      print(jsonPoint["name"]);
      print(jsonPointEncoded);
      print(res.body);
    }
    return res.statusCode;
  }

  signIn(String id, email) async {
    var pointEmail = emailController.text;
    var password = passwordController.text;
    var jwt = await attemptLogIn(pointEmail, password);
    if(jwt != null) {
      storage.write(key: "jwt", value: jwt);
      int response = await getPointByMail(pointEmail);
      if (response == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PointHomeScreen.fromBase64(jwt, point)
            )
        );
      }
    } else {
      displayDialog(context, "An Error Occurred", "No account was found matching that Email and password");
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
                        obscureText: true,
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
                          MaterialPageRoute(builder: (context) => registerPage(widget.isConsumer)),
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
