import 'dart:convert';

import 'package:smart_kishan/models/sellproduct.dart';

List<ProductCart> productCartListFromJson(String val) => List<ProductCart>.from(
        json.decode(val).map((cartItem) => ProductCart.fromJson(cartItem)))
    .toList();

class ProductCart {
  final int? id;
  final int productId;
  final int quantity;
  final SellProduct? product;

  ProductCart(
      {this.id,
      required this.productId,
      required this.quantity,
      required this.product});

  // Factory method to create a ProductCart object from JSON
  factory ProductCart.fromJson(Map<String, dynamic> json) {
    return ProductCart(
        id: json['id'],
        productId: json['product_id'],
        quantity: json['quantity'],
        product: json['product'] != null
            ? SellProduct.fromJson(json['product'])
            : null);
  }

  // Method to convert a ProductCart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}
