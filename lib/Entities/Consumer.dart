import 'ListsItem.dart';

class Consumer {
  String deviceID;
  String pointsName;
  bool loggedIn;
  String username;
  String consumerId;
  // List<ListsItem> pointsProducts;
  List<ListsItem> basket;

  Consumer() {
    //dodac deviceID
    deviceID = "aaa";
    basket = new List<ListsItem>();
  }

  addToBasket(ListsItem item) {
      basket.add(item);
  }

  removeFromBasket(ListsItem item) {
    basket.remove(item);
  }

  double totalPrice() {
    double totalPrice = 0.0;
    basket.forEach((element) {
      totalPrice += double.parse(element.price);
    });
    return totalPrice;
  }
}