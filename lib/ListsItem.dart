class ListsItem {
  String name, price, category, description;
  bool avaliability;
  int productID;

  ListsItem();

  ListsItem.construct(this.name, this.price, this.category, this.avaliability, this.productID);

  ListsItem.constructSimple(String name, String price, int id) {
    this.name = name;
    this.price = price;
    this.productID = id;
    this.category = "non";
    this.avaliability = true;
  }

  static productFromJson(json) {
    ListsItem p = ListsItem();
    p.name = json['name'];
    p.price = json['price'].toString();
    p.category = json['category'];
    p.avaliability = json['avaliability'];
    p.productID = json['id'];
    p.description = json['description'];
    return p;
  }

  static fromJson(json) {
    ListsItem p = new ListsItem();
    p.name = json['name'];
    p.price = json['price'].toString();
    p.category = json['category'];
    return p;
  }

  @override
  String toString() {
    return 'ListsItem{name: $name, price: $price, category: $category, avaliability: $avaliability, description: $description}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListsItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price &&
          productID == other.productID;

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ productID.hashCode;
}