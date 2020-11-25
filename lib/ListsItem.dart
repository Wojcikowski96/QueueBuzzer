class ListsItem {
  String name, price, category;
  bool avaliability;
  ListsItem();
  ListsItem.construct(this.name, this.price, this.category, this.avaliability);

  static productFromJson(json) {
    ListsItem p = ListsItem();
    print(json);
    p.name = json['name'];
    p.price = json['price'].toString();
    p.category = json['category'];
    p.avaliability = json['avaliability'];
    return p;
  }

  static fromJson(json) {
    ListsItem p = new ListsItem();
    print(json);
    p.name = json['name'];
    p.price = json['price'].toString();
    p.category = json['category'];
    return p;
  }
}