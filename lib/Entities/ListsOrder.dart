class ListsOrder {
  String stateOrder;
  int idOrder;
  int nrOrder;
  String stateName;
  ListsOrder();
  ListsOrder.construct(this.idOrder, this.nrOrder, this.stateOrder);

  static productFromJson(json) {
    ListsOrder p = ListsOrder();
    print(json);
    p.idOrder = json['id'];
    p.nrOrder = json['queueNumber'];
    p.stateOrder = json['stateName'];
    p.stateName = json['stateName'];
    return p;
  }

  static fromJson(json) {
    ListsOrder p = new ListsOrder();
    print(json);
    p.idOrder = json['id'];
    p.nrOrder = json['queueNumber'];
    p.stateOrder = json['stateName'];
    p.stateName = json['stateName'];
    return p;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListsOrder &&
          runtimeType == other.runtimeType &&
          stateOrder == other.stateOrder &&
          idOrder == other.idOrder &&
          nrOrder == other.nrOrder &&
          stateName == other.stateName;

  @override
  int get hashCode =>
      stateOrder.hashCode ^
      idOrder.hashCode ^
      nrOrder.hashCode ^
      stateName.hashCode;
}
