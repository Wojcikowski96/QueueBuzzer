import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Entities/ListsOrder.dart';
import '../Entities/Point.dart';
import 'PointHomeScreen.dart';

class PointOwnerOrderStatus extends StatefulWidget {

  Point point;

  PointOwnerOrderStatus(Point p) {
    this.point = p;
  }
  @override
  _PointOwnerOrderStatusState createState() => _PointOwnerOrderStatusState.withPoint(point);
}

class _PointOwnerOrderStatusState extends State<PointOwnerOrderStatus> {
  final storage = FlutterSecureStorage();
  Point point;

  factory _PointOwnerOrderStatusState.withPoint(Point p) {
    return _PointOwnerOrderStatusState().withPoint(p);
  }
  _PointOwnerOrderStatusState withPoint(Point p) {
    this.point = p;
    return this;
  }
  _PointOwnerOrderStatusState();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      getPointItems();
    });
  }

  String pointID = "2";

  List<Widget> listOrdersAccepted = new List(),
               listOrdersInProgress = new List(),
               listOrdersReady = new List(),
               listOrdersDone = new List();

  List<Widget> tempListOrdersAccepted = new List(),
               tempListOrdersInProgress = new List(),
               tempListOrdersReady = new List(),
               tempListOrdersDone = new List();

  getPointItems() async {

    var jsonResponse = null;
    var pointID = (await storage.read(key: "pointID")).toString();

    String request = "http://10.0.2.2:8080/point/" + pointID + "/orders";
    var response = await http.get(request);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Iterable iterable = json.decode(response.body);
        List<dynamic> posts = List<Map>.from(iterable)
            .map((Map model) => ListsOrder.fromJson(model))
            .toList();

        //gridChildren.removeAt(0);

        for (dynamic item in posts) {
          if (item.stateOrder.toString() == "ACCEPTED")
            {
              tempListOrdersAccepted.add(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Item(item.idOrder, item.nrOrder.toString(), item.stateOrder.toString()),
              ));
            }
          else if (item.stateOrder.toString() == "IN_PROGRESS")
            {
              tempListOrdersInProgress.add(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Item(item.idOrder, item.nrOrder.toString(), item.stateOrder.toString()),
              ));
            }
          else if (item.stateOrder.toString() == "READY")
          {
            tempListOrdersReady.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Item(item.idOrder, item.nrOrder.toString(), item.stateOrder.toString()),
            ));
          }
          else if (item.stateOrder.toString() == "DONE")
          {
            tempListOrdersDone.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Item(item.idOrder, item.nrOrder.toString(), item.stateOrder.toString()),
            ));
          }
        }

        setState(() {
          listOrdersAccepted = tempListOrdersAccepted;
          listOrdersInProgress = tempListOrdersInProgress;
          listOrdersReady = tempListOrdersReady;
          listOrdersDone = tempListOrdersDone;
        });
      }
    }
  }

  void lvlUpOrder(int idOrder, String newStateOrder) async {
    const SERVER_IP = 'http://10.0.2.2:8080';

    await http.patch("$SERVER_IP/consumer-order/" + idOrder.toString(),
        body: jsonEncode(<String, dynamic>{
          "stateName": newStateOrder,
        }),
        headers: <String, String>{"Content-Type": "application/json"});

    listOrdersInProgress.clear();
    listOrdersAccepted.clear();
    listOrdersReady.clear();
    listOrdersDone.clear();
    getPointItems();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var itemHeight = 243.0;

    return MaterialApp(
      home: DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.white54,
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(text: "Accepted"),
                  Tab(text: "In Progress"),
                  Tab(text: "Ready"),
                  Tab(text: "Done"),
                ],
              ),
            ),

            body: TabBarView(
              children: [
                Scaffold(
                  backgroundColor: Colors.white54,
                  drawer: Drawer(
                    // Add a ListView to the drawer. This ensures the user can scroll
                    // through the options in the drawer if there isn't enough vertical
                    // space to fit everything.
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: Text('Drawer Header'),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                          ),
                        ),
                        ListTile(
                          title: Text('Strona główna punktu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PointHomeScreen.fromBase64(
                                        storage.read(key: "jwt").toString(),
                                        this.point)));
                          },
                        ),
                        ListTile(
                          title: Text('Edytuj menu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Podgląd menu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Ustawienia Punktu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  body: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("food.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                      ),
                    ),
                    child: Column(children: [
                      Expanded(
                        child: new GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: (screenWidth / (itemHeight*0.4)),
                          children: List.generate(listOrdersAccepted.length,
                                  (index) => listOrdersAccepted[index]),
                        ),
                      ),
                    ]),
                  ),
                ),

                //***ACCEPTED***

                Scaffold(
                  backgroundColor: Colors.white54,
                  drawer: Drawer(
                    // Add a ListView to the drawer. This ensures the user can scroll
                    // through the options in the drawer if there isn't enough vertical
                    // space to fit everything.
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: Text('Drawer Header'),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                          ),
                        ),
                        ListTile(
                          title: Text('Strona główna punktu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PointHomeScreen.fromBase64(
                                        storage.read(key: "jwt").toString(),
                                        this.point)));
                          },
                        ),
                        ListTile(
                          title: Text('Edytuj menu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Podgląd menu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Ustawienia Punktu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  body: Container(//////////***********
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("food.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                      ),
                    ),
                    child: Column(children: [

                      Expanded(
                        child: new GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: (screenWidth / (itemHeight*0.4)),
                          children: List.generate(listOrdersInProgress.length,
                                  (index) => listOrdersInProgress[index]),
                        ),
                      ),
                    ]),
                  ),//////////////*********
                ),

                //***IN PROGRESS***

                Scaffold(
                  backgroundColor: Colors.white54,
                  drawer: Drawer(
                    // Add a ListView to the drawer. This ensures the user can scroll
                    // through the options in the drawer if there isn't enough vertical
                    // space to fit everything.
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: Text('Drawer Header'),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                          ),
                        ),
                        ListTile(
                          title: Text('Strona główna punktu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PointHomeScreen.fromBase64(
                                        storage.read(key: "jwt").toString(),
                                        this.point)));
                          },
                        ),
                        ListTile(
                          title: Text('Edytuj menu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Podgląd menu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Ustawienia Punktu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  /*floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.arrow_upward_rounded),
                    onPressed: () {
                      /*Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddProduct(point)));*/
                    },
                  ),*/
                  body: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("food.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                      ),
                    ),
                    child: Column(children: [

                      Expanded(
                        child: new GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: (screenWidth / (itemHeight*0.4)),
                          children: List.generate(listOrdersReady.length,
                                  (index) => listOrdersReady[index]),
                        ),
                      ),
                    ]),
                  ),
                ),

                //***READY***

                Scaffold(
                  backgroundColor: Colors.white54,
                  drawer: Drawer(
                    // Add a ListView to the drawer. This ensures the user can scroll
                    // through the options in the drawer if there isn't enough vertical
                    // space to fit everything.
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: Text('Drawer Header'),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                          ),
                        ),
                        ListTile(
                          title: Text('Strona główna punktu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PointHomeScreen.fromBase64(
                                        storage.read(key: "jwt").toString(),
                                        this.point)));
                          },
                        ),
                        ListTile(
                          title: Text('Edytuj menu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Podgląd menu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Ustawienia Punktu'),
                          onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  body: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("food.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                      ),
                    ),
                    child: Column(children: [

                      Expanded(
                        child: new GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: (screenWidth / (itemHeight*0.4)),
                          children: List.generate(listOrdersDone.length,
                                  (index) => listOrdersDone[index]),
                        ),
                      ),
                    ]),
                  ),
                ),

                //***DONE***

              ],
            ),
          )
      ),
    );
  }

  Container Item(int idOrder, String nrOrder, String stateOrder) {
    int stateColorId = 0;

    if (stateOrder == "ACCEPTED")
      stateColorId = 0xFFFF9800;
    else if (stateOrder == "IN_PROGRESS")
      stateColorId = 0xFF9C27B0;
    else if (stateOrder == "READY")
      stateColorId = 0xFF43A047;
    else if (stateOrder == "DONE")
      stateColorId = 0xFF00000;

    return Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(90.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          color: const Color(0xff2c2c2c),
                        ),
                        child: Center(
                          child: Text(
                            nrOrder,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 20,
                              color: Colors.white,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      Container(
                        width: 200.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          color: const Color(0xFFBBDEFB),
                        ),
                        child: Center(
                          child: Text(
                            stateOrder,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 30,
                              color: Color(stateColorId),
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      FloatingActionButton(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.arrow_upward_rounded),
                        onPressed: () {print('ooo');
                          String newStateOrder = '';
                          if (stateOrder == "ACCEPTED")
                            newStateOrder = 'IN_PROGRESS';
                          else if (stateOrder == "IN_PROGRESS")
                            newStateOrder = 'READY';
                          else if (stateOrder == "READY")
                            newStateOrder ='DONE';

                          lvlUpOrder(idOrder, newStateOrder);
                          
                          /*setState(() {
                            if (stateOrder == "ACCEPTED") {
                              listOrdersInProgress.add(
                                  Padding(padding: const EdgeInsets.all(8.0),
                                    child: Item(idOrder, nrOrder.toString(),
                                        newStateOrder.toString()),
                                  ));
                              //listOrdersAccepted.toList().removeWhere((element) => (element.key != nrOrder));
                              listOrdersAccepted.removeWhere((
                                  element) => (element.key == Key("nrOrder_$nrOrder")));
                            }
                            else if (stateOrder == "IN_PROGRESS") {
                              listOrdersReady.add(
                                  Padding(padding: const EdgeInsets.all(8.0),
                                    child: Item(idOrder, nrOrder.toString(),
                                        newStateOrder.toString()),
                                  ));
                              //listOrdersInProgress.toList().removeWhere((element) => (element.key != nrOrder));
                              listOrdersInProgress.removeWhere((
                                  element) => (element.key == Key("nrOrder_$nrOrder")));
                            }
                            else if (stateOrder == "READY") {
                              listOrdersDone.add(
                                  Padding(padding: const EdgeInsets.all(8.0),
                                    child: Item(idOrder, nrOrder.toString(),
                                        newStateOrder.toString()),
                                  ));
                              //listOrdersReady.toList().removeWhere((element) => (element.key != nrOrder));
                              listOrdersReady.removeWhere((element) =>
                              (element.key == Key("nrOrder_$nrOrder")));
                            }
                          });*/
                        
                        },
                      ),

                    ],
                  ),
                ),
              ),
        ]));
  }
}