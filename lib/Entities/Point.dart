import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ListsItem.dart';

class Point {
  int pointID;
  String deviceID;
  String pointsName;
  int color = 0xFFF4511E;
  String imgUrl = null;
  List<ListsItem> pointsProducts;
  List<ListsItem> queue;
  String jwt;
  Map<String, dynamic> payload;

  Point();

  Point.withIdAndName(this.pointID, this.pointsName, color, this.imgUrl) {
    this.color = convertHtmlColorIntoInt(color);
  }

   static int convertHtmlColorIntoInt(String htmlColor) {
    final buffer = StringBuffer();
    if (htmlColor.length == 6 || htmlColor.length == 7) buffer.write('ff');
    buffer.write(htmlColor.replaceFirst('#', ''));
    return buffer.toString().isEmpty ?  0xFFFF5722 : int.parse(buffer.toString(), radix: 16);
  }

  Point.withId(this.pointID) {
    // getPointInfo();
  }

  Future<List<String>> getPointInfo() async {
    List<String> uniqueCategories;
    List<String> categories = new List();

    var jsonResponse = null;
    String pointID = this.pointID.toString();
    String request = "http://10.0.2.2:8080/point/" + pointID + "/products";
    var response = await http.get(request);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Iterable iterable = json.decode(response.body);
        List<dynamic> posts = List<Map>.from(iterable)
            .map((Map model) => ListsItem.productFromJson(model))
            .toList();

        pointsProducts = new List<ListsItem>();
        for (dynamic item in posts) {
          categories.add(item.category.toString());
          //cos nie dizala przy item.id
          pointsProducts.add(ListsItem.construct(item.name, item.price, item.category, item.avaliability, item.productID));
        }
        uniqueCategories = categories;
      }
    }
    return uniqueCategories;
  }
  void checkForUpdates() {
    //TODO:Dodac sprawdzanie czy są jakieś zmiany
  }
}