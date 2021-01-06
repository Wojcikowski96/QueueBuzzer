class ListsOrder {
  String stateOrder;
  int idOrder;
  int nrOrder;
  List<dynamic> productList;
  ListsOrder();
  ListsOrder.construct(this.idOrder, this.nrOrder, this.stateOrder);

  static productFromJson(json) {
    ListsOrder p = ListsOrder();
    p.idOrder = json['id'];
    p.nrOrder = json['queueNumber'];
    p.stateOrder = json['stateName'];
    p.productList = json['productList'];
    return p;
  }

  static fromJson(json) {
    ListsOrder p = new ListsOrder();
    p.idOrder = json['id'];
    p.nrOrder = json['queueNumber'];
    p.stateOrder = json['stateName'];
    p.productList = json['productList'];
    return p;
  }

}
