import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:smart_kishan/enums/orderStatus.dart';
import 'package:smart_kishan/models/deliveryAddress.dart';
import 'package:smart_kishan/models/orderItem.dart';
import 'package:smart_kishan/models/user.dart';

List<Order> orderListFromJson(String val) =>
    List<Order>.from(json.decode(val).map((order) => Order.fromJson(order)))
        .toList();

class Order {
  final int id;
  final String number;
  final String? addressTitle;
  final String? city;
  final String? phone;
  final String? description;
  final int? provinceId;
  final int? districtId;
  final int? municipalityId;
  final int? deliveryAddressId;
  final String? totalPrice;
  final String? notes;
  OrderStatus? status;
  final List<OrderItem>? items;
  final DeliveryAddress? deliveryAddress;
  final User? vendor;
  final User? customer;
  final String? createdAt;

  Order({
    required this.id,
    required this.number,
    required this.addressTitle,
    required this.city,
    required this.phone,
    required this.description,
    this.provinceId,
    this.districtId,
    this.municipalityId,
    this.deliveryAddressId,
    required this.totalPrice,
    this.notes,
    required this.status,
    required this.items,
    this.deliveryAddress,
    this.vendor,
    this.customer,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        number: json['number'],
        addressTitle: json['address_title'],
        city: json['city'],
        phone: json['phone'],
        description: json['description'],
        provinceId: json['province_id'],
        districtId: json['district_id'],
        municipalityId: json['municipality_id'],
        deliveryAddressId: json['delivery_address_id'],
        totalPrice: json['total_price'].toString(),
        notes: json['notes'],
        status: (json['status'] as String).toOrderStatus(),
        items: (json['items'] as List<dynamic>)
            .map((item) => OrderItem.fromJson(item))
            .toList(),
        deliveryAddress: json['delivery_address'] != null
            ? DeliveryAddress.fromJson(json['delivery_address'])
            : null,
        customer:
            json['customer'] != null ? User.fromJson(json['customer']) : null,
        vendor: json['vendor'] != null ? User.fromJson(json['vendor']) : null,
        createdAt: json['created_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'address_title': addressTitle,
      'city': city,
      'phone': phone,
      'description': description,
      'province_id': provinceId,
      'district_id': districtId,
      'municipality_id': municipalityId,
      'delivery_address_id': deliveryAddressId,
      'total_price': totalPrice,
      'notes': notes,
      'status': status,
      'items': items!.map((item) => item.toJson()).toList(),
      'delivery_address': deliveryAddress?.toJson(),
    };
  }

  // Getter for formatted date
  String get formattedDate {
    final DateFormat formatter = DateFormat('dd MMM yy');
    return createdAt != null
        ? formatter.format(DateTime.tryParse(createdAt!)!)
        : '';
  }

  String formatDate(DateTime date, String locale) {
    // Set the locale if needed
    Intl.defaultLocale = locale;
    String formattedDate;

    // Format the date as "Jan 7, 2025" for English or "जनवरी 7, 2025" for Nepali
    if (locale == 'ne') {
      // In Nepali format
      formattedDate = DateFormat('MMM d, y', 'ne').format(date);
    } else {
      // In English format
      formattedDate = DateFormat('MMM d, y', 'en_US').format(date);
    }

    // Return the formatted date with the appropriate prefix
    return locale == 'ne' ? formattedDate : formattedDate;
  }
}
