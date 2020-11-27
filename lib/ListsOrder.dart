class ListsOrder {
  String stateOrder;
  int nrOrder;
  ListsOrder();
  ListsOrder.construct(this.nrOrder, this.stateOrder);

  static productFromJson(json) {
    ListsOrder p = ListsOrder();
    print(json);
    p.nrOrder = json['queueNumber'];
    p.stateOrder = json['state'];
    return p;
  }

  static fromJson(json) {
    ListsOrder p = new ListsOrder();
    print(json);
    p.nrOrder = json['queueNumber'];
    p.stateOrder = json['state'];
    return p;
  }

}