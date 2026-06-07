import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/enums/orderStatus.dart';
import 'package:smart_kishan/models/order.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/vendor/dashboard/services/remote_order_service.dart';

class VendorOrdersController extends GetxController {
  static VendorOrdersController instance = Get.find();

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
        myOrders.clear();
        myOrders.addAll(orderListFromJson(jsonEncode(data)));
        myOrders.refresh();
      }
    } catch (e) {
      print(e);
      print('No Internet Connection');
    } finally {
      isOrdersLoading(false);
    }
  }

  Future<bool?>? updateOrder(String orderId, String newStatus) async {
    // try {
    isOrdersLoading(true);
    String? token = await _localAuthService.getToken();
    var result = await RemoteOrderService()
        .updateOrder(token: token!, orderId: orderId, status: newStatus);
    if (result != null && result.statusCode == 200) {
      var body = jsonDecode(result.body);
      bool success = body['success'];
      if (success) {
        // Update the order status locally
        var order = myOrders
            .firstWhere((order) => order.id.toString() == orderId.toString());
        order.status =
            OrderStatus.values.firstWhere((e) => e.rawValue == newStatus);
        myOrders.refresh();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'अर्डरको स्थिति सफलतापूर्वक अपडेट गरियो!',
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
              'अर्डरको स्थिति अपडेट गर्न असफल भयो। कृपया पुन: प्रयास गर्नुहोस्।',
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
            'केही त्रुटि भयो। कृपया पछि प्रयास गर्नुहोस्।',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
    return false;
    // } catch (e) {
    //   ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
    //     const SnackBar(
    //       backgroundColor: kErrorColor,
    //       content: Text(
    //         'An error occurred. Please try again.',
    //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    //       ),
    //     ),
    //   );
    //   return false;
    // } finally {
    //   isOrdersLoading(false);
    // }
  }

  void reset() {
    myOrders.clear();
    myOrders.refresh();
    isOrdersLoading(false);
  }
}
