import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/enums/orderStatus.dart';
import 'package:smart_kishan/models/deliverylocation.dart';
import 'package:smart_kishan/models/order.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/customer/orders/services/remote_order_service.dart';

class CustomerOrdersController extends GetxController {
  static CustomerOrdersController instance = Get.find();

  RxList<Order> myOrders = List<Order>.empty(growable: true).obs;

  RxBool isOrdersLoading = false.obs;
  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getMyOrders();
  }

  void getMyOrders() async {
    try {
      isOrdersLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteOrderService().getMyOrders(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        myOrders.addAll(orderListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      print(e);
      print('No Internet Connection');
    } finally {
      isOrdersLoading(false);
    }
  }

  void orderFromCart(Map<String, dynamic> orderData) async {
    isOrdersLoading(true);

    // Get the token for the authenticated user
    String? token = await _localAuthService.getToken();

    // Send the request to the backend
    var result = await RemoteOrderService()
        .orderFromCart(token: token!, data: orderData);

    if (result != null && result.statusCode == 200) {
      // Successful response
      var body = jsonDecode(result.body);
      bool success = body['success'];

      if (success) {
        var data = body['data'];
        List<Order> newOrders = orderListFromJson(jsonEncode(data));
        myOrders.insertAll(0, newOrders);

        // Show success message
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            backgroundColor:
                kSuccessColor, // Assuming you have a success color defined
            content: Text(
              'सफलतापूर्वक अर्डर गरिएको छ!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
        productCartController.myCart.clear();
        // Navigate to order confirmation screen
        Get.toNamed(AppRoute.orderConfirmationScreen);
      } else {
        // Show failure message if the 'success' flag is false
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'अर्डर गर्न असफल। कृपया पुन: प्रयास गर्नुहोस्।',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
    } else {
      // Handle failure case (e.g., no response, server error)
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
        const SnackBar(
          backgroundColor: kErrorColor,
          content: Text(
            'कुनै त्रुटि भयो। कृपया पछि पुन: प्रयास गर्नुहोस्।',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    // Hide loading state
    isOrdersLoading(false);
  }

  Future<bool?>? cancelOrder(String orderId) async {
    try {
      isOrdersLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteOrderService()
          .cancelOrder(token: token!, orderId: orderId);
      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        bool success = body['success'];

        if (success) {
          // Remove the cancelled order from the list or update its status
          var order = myOrders
              .firstWhere((order) => order.id.toString() == orderId.toString());
          order.status = OrderStatus.cancelled;
          myOrders.refresh();
          ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
            const SnackBar(
              backgroundColor: kSuccessColor,
              content: Text(
                'अर्डर सफलतापूर्वक रद्द भयो!',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          );
          return true;
        } else {
          ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
            const SnackBar(
              backgroundColor: kErrorColor,
              content: Text(
                'अर्डर रद्द गर्न असफल। कृपया पुन: प्रयास गर्नुहोस्।',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'कुनै त्रुटि भयो। कृपया पुन: प्रयास गर्नुहोस्।',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
      return false;
    } catch (e) {
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
        const SnackBar(
          backgroundColor: kErrorColor,
          content: Text(
            'An error occurred. Please try again.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
      return false;
    } finally {
      isOrdersLoading(false);
    }
  }

  void orderDirectly(Map<String, dynamic> orderData) async {
    isOrdersLoading(true);

    String? token = await _localAuthService.getToken();

    var result = await RemoteOrderService()
        .orderDirectly(token: token!, data: orderData);
    if (result != null && result.statusCode == 200) {
      var body = jsonDecode(result.body);
      bool success = body['success'];

      if (success) {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'Order placed successfully!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
        Get.toNamed(AppRoute.orderConfirmationScreen);
      } else {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'Failed to place order. Please try again.',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
        const SnackBar(
          backgroundColor: kErrorColor,
          content: Text(
            'An error occurred. Please try again later.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    isOrdersLoading(false);
  }

  void reset() {
    myOrders.clear();
    isOrdersLoading(false);
  }
}
