class ListsOrder {
  String stateOrder;
  int idOrder;
  int nrOrder;
  ListsOrder();
  ListsOrder.construct(this.idOrder, this.nrOrder, this.stateOrder);

  static productFromJson(json) {
    ListsOrder p = ListsOrder();
    print(json);
    p.idOrder = json['id'];
    p.nrOrder = json['queueNumber'];
    p.stateOrder = json['state'];
    return p;
  }

  static fromJson(json) {
    ListsOrder p = new ListsOrder();
    print(json);
    p.idOrder = json['id'];
    p.nrOrder = json['queueNumber'];
    p.stateOrder = json['state'];
    return p;
  }

}