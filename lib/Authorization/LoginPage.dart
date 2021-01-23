import 'dart:convert';

import 'package:PointOwner/Consumer%20Side/ConsumerHomeScreen.dart';
import 'package:PointOwner/PointOwner%20Side/PointOwnerOrderStatus.dart';
import 'package:PointOwner/Style/QueueBuzzerButtonStyle.dart';

import '../Entities/Point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  String SERVER_IP = 'http://10.0.2.2:8080';
  final storage = FlutterSecureStorage();

  Point point;



  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Future<String> attemptLogIn(String username, String password) async {
    try {
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
      print(userType);
      if (res.statusCode == 200) {
        if ((widget.isConsumer == true && userType == "Consumer") ||
            (widget.isConsumer == false && userType == "PointOwner")) {
          return jsonDecode(res.body)["jwt"];
        }
      }
    } on Exception catch(e) {
      print(e.toString());
    }

      return null;
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
        point = new Point.withIdAndName(jsonPoint["id"], jsonPoint["name"], jsonPoint['colour'], jsonPoint['logoImg']);
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
    print(widget.isConsumer);
    var jwt = await attemptLogIn(pointEmail, password);
    if(jwt != null) {
      storage.write(key: "jwt", value: jwt);
      int response = await getPointByMail(pointEmail);
      point.jwt = jwt;
      point.payload = json.decode(
          ascii.decode(
              base64.decode(base64.normalize(jwt.split(".")[1]))
          ));
      if (response == 200) {
        if(widget.isConsumer){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>ConsumerHomeScreen(point)
              )
          );

        }else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>PointOwnerOrderStatus(point)
              )
          );
        }

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
                        borderRadius: QueueBuzzerButtonStyle.border,
                      ),
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
                      child: Text("Zaloguj",
                        style: QueueBuzzerButtonStyle.textStyle,
                      ),
                      color: QueueBuzzerButtonStyle.color,
                      textColor: QueueBuzzerButtonStyle.textColor,
                      padding: QueueBuzzerButtonStyle.padding,
                      splashColor: QueueBuzzerButtonStyle.splashColor,
                    ),
                    width: QueueBuzzerButtonStyle.width,
                    height: QueueBuzzerButtonStyle.height,
                  ),
                  QueueBuzzerButtonStyle.span,
                  Text("Nie masz u nas konta?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),

                  ),
                  QueueBuzzerButtonStyle.span,
                  SizedBox(child:
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: QueueBuzzerButtonStyle.border,
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => registerPage(widget.isConsumer)),
                      );
                    },
                      child: Text("Zarejestruj",
                        style: QueueBuzzerButtonStyle.textStyle,
                      ),
                      color: QueueBuzzerButtonStyle.color,
                      textColor: QueueBuzzerButtonStyle.textColor,
                      padding: QueueBuzzerButtonStyle.padding,
                      splashColor: QueueBuzzerButtonStyle.splashColor,
                    ),
                    height: QueueBuzzerButtonStyle.height,
                    width: QueueBuzzerButtonStyle.width,
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
