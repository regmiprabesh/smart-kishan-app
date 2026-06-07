import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/productCart.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/customer_dashboard/services/remote_product_cart_service.dart';

class ProductCartController extends GetxController {
  static ProductCartController instance = Get.find();

  RxList<ProductCart> myCart = List<ProductCart>.empty(growable: true).obs;

  RxBool isCartLoading = false.obs;
  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getMyCartItems();
  }

  void addCartItem(ProductCart productCart) async {
    try {
      isCartLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteProductCartService()
          .addCartItem(token: token!, data: productCart.toJson());

      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        var data = body['data'];

        // Extract the product cart details from the response
        ProductCart updatedCartItem = ProductCart.fromJson(data);

        // Check if the item already exists in the Dart cart list
        int existingIndex = myCart
            .indexWhere((item) => item.productId == updatedCartItem.productId);

        if (existingIndex != -1) {
          // Update the existing item's quantity
          myCart[existingIndex] = updatedCartItem;
        } else {
          // Add the new item to the cart
          myCart.add(updatedCartItem);
        }

        // Show success message using SnackBar
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'उत्पादन सफलतापूर्वक थपिएको छ।',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      } else {
        // Handle API errors (e.g., 400, 404, etc.)
        var body = jsonDecode(result.body);
        String errorMessage = body['message'] ?? 'An error occurred';

        // Show error message using SnackBar
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              errorMessage,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);

      // Handle unexpected errors
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
        const SnackBar(
          backgroundColor: kErrorColor,
          content: Text(
            'Something went wrong. Please try again later.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } finally {
      isCartLoading(false);
    }
  }

  void getMyCartItems() async {
    try {
      isCartLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteProductCartService().getCartItems(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        myCart.addAll(productCartListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      // print(e);
      print('No Internet Connection');
    } finally {
      isCartLoading(false);
    }
  }

  void deleteCartItem(int id) async {
    try {
      isCartLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteProductCartService()
          .deleteCartProduct(token: token!, id: id);
      if (result.statusCode == 200) {
        myCart.removeWhere((element) => element.id == id);
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'उत्पादन सफलतापूर्वक मेटाइएको छ।',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      print(e);
    } finally {
      isCartLoading(false);
    }
  }

  double get totalCartPrice {
    return myCart.fold(0.0, (sum, item) {
      double price = double.tryParse(item.product?.price ?? '0') ?? 0;
      return sum + (item.quantity * price);
    });
  }

  void reset() {
    myCart.clear();
    isCartLoading(false);
  }
}
