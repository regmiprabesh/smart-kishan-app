import 'dart:convert';

List<Product> productListFromJson(String val) => List<Product>.from(
    json.decode(val).map((product) => Product.fromJson(product))).toList();

class Product {
  int? id;
  String? name;
  int? stock;
  int? unitId;
  String? description;
  int? isSellable;
  int? userId;
  String? date;
  Product(
      {this.id,
      this.name,
      this.stock,
      this.unitId,
      this.description,
      this.isSellable,
      this.userId,
      this.date});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stock = json['stock'];
    unitId = json['unit_id'];
    description = json['description'];
    isSellable = json['is_sellable'];
    userId = json['user_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['stock'] = stock;
    data['unit_id'] = unitId;
    data['description'] = description;
    data['is_sellable'] = isSellable;
    data['user_id'] = userId;
    data['date'] = date;
    return data;
  }
}
