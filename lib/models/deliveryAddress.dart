import 'dart:convert';

List<DeliveryAddress> deliveryAddressListJson(String val) =>
    List<DeliveryAddress>.from(json.decode(val).map(
            (deliveryAddress) => DeliveryAddress.fromJson(deliveryAddress)))
        .toList();

class DeliveryAddress {
  final int? id;
  final String addressTitle;
  final String city;
  final String? description;
  final String? phone;
  final int? provinceId;
  final int? districtId;
  final int? municipalityId;
  final int? userId;
  bool isDefault;

  DeliveryAddress({
    this.id,
    required this.addressTitle,
    required this.city,
    required this.phone,
    this.description,
    this.provinceId,
    this.districtId,
    this.municipalityId,
    this.userId,
    this.isDefault = false,
  });

  /// Factory method to create a `DeliveryAddress` from a JSON object.
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'],
      addressTitle: json['address_title'],
      city: json['city'],
      phone: json['phone'],
      description: json['description'],
      provinceId: json['province_id'],
      districtId: json['district_id'],
      municipalityId: json['municipality_id'],
      userId: json['user_id'],
      isDefault: (json['is_default'] == 1 || json['is_default'] == true),
    );
  }

  /// Converts a `DeliveryAddress` instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address_title': addressTitle,
      'city': city,
      'phone': phone,
      'description': description,
      'province_id': provinceId,
      'district_id': districtId,
      'municipality_id': municipalityId,
      'user_id': userId,
      'is_default': isDefault,
    };
  }
}
