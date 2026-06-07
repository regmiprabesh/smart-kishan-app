import 'dart:convert';

import 'package:smart_kishan/models/sellproduct.dart';

List<DeliveryLocation> deliveryLocationListFromJson(String val) =>
    List<DeliveryLocation>.from(json
        .decode(val)
        .map((location) => DeliveryLocation.fromJson(location))).toList();

class DeliveryLocation {
  final int locationId;
  final String locationType;
  final String name;

  DeliveryLocation({
    required this.locationId,
    required this.locationType,
    required this.name,
  });

  // Factory constructor to create a DeliveryLocation from a JSON map
  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      locationId: json['location_id'],
      locationType: json['location_type'],
      name: json['name'],
    );
  }

  // Method to convert a DeliveryLocation object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'location_type': locationType,
      'name': name,
    };
  }
}

List<DeliveryLocation> getSelectedDeliveryLocations(
    SellProduct selectedProduct, List<DeliveryLocation> allLocations) {
  List<DeliveryLocation> selectedDeliveryLocations = [];
  // Loop through each locationType (provinces, districts, municipalities)
  selectedProduct.deliveryLocations!.forEach((type, locationIds) {
    // Filter the locations based on type and locationId matching
    allLocations.forEach((location) {
      if (locationIds.contains(location.locationId.toString()) &&
          location.locationType == type) {
        selectedDeliveryLocations.add(location);
      }
    });
  });
  return selectedDeliveryLocations;
}

Map<String, List<String>> transformDeliveryLocations(
    List<DeliveryLocation> locations) {
  Map<String, List<String>> deliveryMap = {};

  for (var location in locations) {
    // Ensure the key is a string explicitly
    String locationTypeKey = location.locationType.toString();

    // Initialize the list if the key doesn't exist
    deliveryMap.putIfAbsent(locationTypeKey, () => []);

    // Add the locationId as a string to the appropriate list
    deliveryMap[locationTypeKey]!.add(location.locationId.toString());
  }

  return deliveryMap;
}
