import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'dart:convert';
import 'package:smart_kishan/models/deliveryAddress.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/customer/delivery_screen/services/remote_delivery_address_service.dart';

class DeliveryAddressController extends GetxController {
  static DeliveryAddressController instance = Get.find();

  RxList<DeliveryAddress> deliveryAddressList =
      List<DeliveryAddress>.empty(growable: true).obs;
  var isLoading = false.obs;
  final LocalAuthService _localAuthService = LocalAuthService();

  RxBool isEdit = false.obs;
  Rx<DeliveryAddress?> selectedDeliveryAddress = Rx<DeliveryAddress?>(null);

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getDeliveryAddress();
  }

  // Fetch search history from Laravel API
  Future<void> getDeliveryAddress() async {
    isLoading.value = true;
    String? token = await _localAuthService.getToken();
    try {
      var result = await RemoteDeliveryAddressService()
          .getDeliveryAddress(token: token!);
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        deliveryAddressList
            .assignAll(deliveryAddressListJson(jsonEncode(body['data'])));
        deliveryAddressList.refresh();
      } else {
        // Get.snackbar('Error', 'Failed to load search history');
      }
    } catch (e) {
      // Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDeliveryAddress(DeliveryAddress address) async {
    isLoading.value = true; // Optional: Show a loading indicator
    String? token = await _localAuthService.getToken();

    try {
      // Check if the user already has 3 addresses
      if (deliveryAddressList.length >= 3) {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'तपाईंले अधिकतम ३ वटा वितरण ठेगानाहरू मात्र थप्न सक्नुहुन्छ।',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
        return;
      }

      var data = address.toJson(); // Convert the address to JSON
      var result = await RemoteDeliveryAddressService().addDeliveryAddress(
        token: token!,
        data: data,
      );
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        // Parse and add the newly created address to the list
        DeliveryAddress newAddress = DeliveryAddress.fromJson(body['data']);

        // If the address is marked as default, ensure no other address is default
        if (newAddress.isDefault) {
          for (var addr in deliveryAddressList) {
            addr.isDefault = false;
          }
        }

        deliveryAddressList.add(newAddress);
        Get.back();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'वितरण ठेगाना सफलतापूर्वक थपियो।',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              '${json.decode(result.body)['message']}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
    } catch (e) {
      // General error message
      // Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteDeliveryAddress(int id) async {
    try {
      isLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteDeliveryAddressService()
          .deleteDeliveryAddress(token: token!, id: id);
      if (result.statusCode == 200) {
        deliveryAddressList.removeWhere((element) => element.id == id);
        Get.back();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'वितरण ठेगाना सफलतापूर्वक हटाइयो।',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void updateDeliveryAddress(DeliveryAddress address) async {
    try {
      isLoading(true);
      String? token = await _localAuthService.getToken();

      // Call the API to update the address
      var result = await RemoteDeliveryAddressService().updateDeliveryAddress(
        token: token!,
        data: address.toJson(),
        id: address.id!,
      );

      // Check the response status
      if (result.statusCode == 200) {
        // Successfully updated the delivery address
        DeliveryAddress updatedDeliveryAddress =
            DeliveryAddress.fromJson(jsonDecode(result.body)['data']);
        if (updatedDeliveryAddress.isDefault) {
          // If the address is marked as default, ensure no other address is default
          for (var addr in deliveryAddressList) {
            addr.isDefault = false;
          }
        }
        // Update the address in the list
        deliveryAddressList[deliveryAddressList.indexWhere(
            (element) => element.id == address.id)] = updatedDeliveryAddress;

        // Update the address in the list
        deliveryAddressList[deliveryAddressList.indexWhere(
            (element) => element.id == address.id)] = updatedDeliveryAddress;

        // Close the current screen
        Get.back();

        // Show success message
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
          backgroundColor: kSuccessColor,
          content: Text(
            'वितरण ठेगाना सफलतापूर्वक अद्यावधिक गरियो।',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ));
      } else {
        // Handle error from API response
        String errorMessage = jsonDecode(result.body)['message'] ??
            'वितरण ठेगाना अद्यावधिक गर्न असफल। कृपया पछि पुन: प्रयास गर्नुहोस्।';
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(SnackBar(
          backgroundColor: kErrorColor,
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ));
      }
    } catch (e) {
      // Handle any exception or error
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(SnackBar(
        backgroundColor: kErrorColor,
        content: Text(
          'वितरण ठेगाना अद्यावधिsक गर्न असफल। कृपया पछि पुन: प्रयास गर्नुहोस्।',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ));
      print(e); // Optional: for debugging
    } finally {
      // Stop loading animation
      isLoading(false);
    }
  }

  String getDefaultCityName() {
    try {
      DeliveryAddress defaultAddress =
          deliveryAddressList.firstWhere((address) => address.isDefault);
      return defaultAddress.city;
    } catch (e) {
      return ''; // Handle cases where no default address is set
    }
  }

  void reset() {
    deliveryAddressList.clear();
    isLoading(false);
    isEdit(false);
    selectedDeliveryAddress(null);
    deliveryAddressList.refresh();
  }
}
