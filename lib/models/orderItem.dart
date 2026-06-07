import 'dart:convert';

import 'package:smart_kishan/models/sellproduct.dart';

List<OrderItem> orderItemListFromJson(String val) => List<OrderItem>.from(
        json.decode(val).map((orderItem) => OrderItem.fromJson(orderItem)))
    .toList();

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String? productName;
  final String unitPrice;
  final int quantity;
  final SellProduct? product;

  OrderItem(
      {required this.id,
      required this.orderId,
      required this.productId,
      this.productName,
      required this.unitPrice,
      required this.quantity,
      required this.product});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        id: json['id'],
        orderId: json['order_id'],
        productId: json['product_id'],
        productName: json['product_name'],
        unitPrice: json['unit_price'],
        quantity: json['quantity'],
        product: json['product'] != null
            ? SellProduct.fromJson(json['product'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'unit_price': unitPrice,
      'quantity': quantity,
    };
  }
}
