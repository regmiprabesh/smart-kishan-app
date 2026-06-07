import 'dart:convert';

import 'package:smart_kishan/models/buyersgroup.dart';
import 'package:smart_kishan/models/paymentmethod.dart';
import 'package:smart_kishan/models/unit.dart';
import 'package:smart_kishan/models/user.dart';

List<SellProduct> sellProductListFromJson(String val) =>
    List<SellProduct>.from(json
        .decode(val)
        .map((sellProduct) => SellProduct.fromJson(sellProduct))).toList();

class SellProduct {
  int? id;
  String? name;
  int? stock;
  int? categoryId;
  int? unitId;
  Unit? unit;
  String? description;
  int? userId;
  String? price;
  String? additionalNotes;
  int? minOrder;
  int? status;
  List<String>? imageUrls; // List of image URLs
  Map<String, dynamic>? deliveryLocations; // List of image URLs
  List<PaymentMethod>? paymentTypes; // List of image URLs
  List<BuyersGroup>? buyersGroups; // List of image URLs
  List<String>? selectedImages;
  List<String>? networkImages;
  User? creator;

  SellProduct(
      {this.id,
      this.name,
      this.stock,
      this.price,
      this.categoryId,
      this.unitId,
      this.unit,
      this.description,
      this.userId,
      this.minOrder,
      this.imageUrls, // List of image URLs
      this.paymentTypes,
      this.buyersGroups,
      this.additionalNotes,
      this.status,
      this.deliveryLocations,
      this.selectedImages,
      this.networkImages,
      this.creator});

  // Method to convert a SellProduct object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stock': stock,
      'price': price,
      'crop_category_id': categoryId,
      'unit_id': unitId,
      'description': description,
      'user_id': userId,
      'imageUrls': imageUrls, // List of image URLs
      'minimum_order': minOrder,
      'status': status,
      'paymentTypes':
          paymentTypes?.map((type) => type is int ? type : type.id).toList(),
      'buyersGroups': buyersGroups
          ?.map((group) => group is int ? group : group.id)
          .toList(),
      'additional_notes': additionalNotes,
      'deliveryLocations': jsonEncode(deliveryLocations),
      'selectedImages': selectedImages,
      'networkImages': jsonEncode(networkImages)
    };
  }

  // Method to create a SellProduct object from JSON
  factory SellProduct.fromJson(Map<String, dynamic> json) {
    return SellProduct(
        id: json['id'],
        name: json['name'],
        stock: json['stock'] is int
            ? json['stock']
            : int.tryParse(json['stock'].toString()) ?? 0,
        price: json['price'],
        categoryId: json['crop_category_id'] is int
            ? json['crop_category_id']
            : int.tryParse(json['crop_category_id'].toString()) ?? 0,
        unitId: json['unit_id'] is int
            ? json['unit_id']
            : int.tryParse(json['unit_id'].toString()) ?? 0,
        unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
        minOrder: json['minimum_order'] is int
            ? json['minimum_order']
            : int.tryParse(json['minimum_order'].toString()) ?? 0,
        imageUrls: json['product_images'] != null
            ? List<String>.from(json['product_images'])
            : [],
        description: json['description'],
        userId: json['userId'],
        status: json['status'] is int
            ? json['status']
            : int.tryParse(json['status'].toString()) ?? 0,
        paymentTypes: json['payment_types'] != null
            ? paymentMethodListFromJson(jsonEncode(json['payment_types']))
            : null,
        buyersGroups: json['buyers_groups'] != null
            ? buyersGroupListFromJson(jsonEncode(json['buyers_groups']))
            : null,
        deliveryLocations: json['delivery_locations'],
        creator: json['user'] != null ? User.fromJson(json['user']) : null,
        additionalNotes: json['additional_notes']);
  }
}
