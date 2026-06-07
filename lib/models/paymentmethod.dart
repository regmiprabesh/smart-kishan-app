import 'dart:convert';

List<PaymentMethod> paymentMethodListFromJson(String val) =>
    List<PaymentMethod>.from(json
            .decode(val)
            .map((paymentMethod) => PaymentMethod.fromJson(paymentMethod)))
        .toList();

class PaymentMethod {
  final int id;
  final String image;
  final String name;

  PaymentMethod({
    required this.id,
    required this.image,
    required this.name,
  });

  // Factory constructor to create a PaymentMethod from JSON
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      image: json['image'] ?? '',
      name: json['name'],
    );
  }

  // Convert PaymentMethod object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
    };
  }

  bool isEqual(PaymentMethod other) {
    return other.id == id;
  }
}
