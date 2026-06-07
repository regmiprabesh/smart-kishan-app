import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/unit.dart';
import 'package:smart_kishan/models/product.dart';
import 'package:smart_kishan/screens/products/services/local_product_service.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/products/services/remote_product_service.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();

  RxList<Product> products = List<Product>.empty(growable: true).obs;
  RxList<Unit> units = List<Unit>.empty(growable: true).obs;

  RxList<Product> sellableProducts = List<Product>.empty(growable: true).obs;
  RxList<Product> nonSellableProducts = List<Product>.empty(growable: true).obs;
  // RxList<Unit> units = [
  //   Unit(id: 1, name: 'ग्राम'),
  //   Unit(id: 2, name: 'किलोग्राम'),
  //   Unit(id: 3, name: 'लिटर'),
  //   Unit(id: 4, name: 'क्यारेट'),
  //   Unit(id: 5, name: 'टुक्रा')
  // ].obs;

  final _localProductService = LocalProductService();

  RxBool isEdit = false.obs;

  // Rx<String> selectedUnitId = ''.obs;

  Rx<Product> selectedProduct = Product().obs;
  RxBool isProductsLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    // selectedUnitId('');
    await _localAuthService.init();
    await _localProductService.init();
    getProducts();
    getUnits();
    // getProductsOffline();
  }

  void getUnits() async {
    try {
      var result = await RemoteProductService().getUnits();
      if (result != null) {
        var body = jsonDecode(result.body);
        units.assignAll(unitListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      print('No Internet Connection');
    } finally {
      isProductsLoading(false);
    }
  }

  void getProducts() async {
    try {
      isProductsLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteProductService().getProducts(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        products.assignAll(productListFromJson(jsonEncode(body['data'])));
        products.refresh();
        sellableProducts(products
            .where(
                (element) => element.isSellable == 1 || element.isSellable == 3)
            .toList());
        nonSellableProducts(products
            .where(
                (element) => element.isSellable == 2 || element.isSellable == 3)
            .toList());
      }
    } catch (e) {
      // print(e);
      print('No Internet Connection');
    } finally {
      isProductsLoading(false);
    }
  }

  getProductsOffline() async {
    try {
      var data = await _localProductService.readProducts();
      products.assignAll(productListFromJson(jsonEncode(data)));
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<bool> addProduct(Product product) async {
    try {
      isProductsLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteProductService()
          .addProduct(token: token!, data: product.toJson());
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        var newProduct = Product.fromJson(body['data']);
        products.add(newProduct);
        sellableProducts(products
            .where(
                (element) => element.isSellable == 1 || element.isSellable == 3)
            .toList());
        nonSellableProducts(products
            .where(
                (element) => element.isSellable == 2 || element.isSellable == 3)
            .toList());
        Get.back();
      }
    } catch (e) {
      print(e);
    } finally {
      isProductsLoading(false);
    }
    return false;
  }

  addProductOffline(Product product) async {
    try {
      var result = await _localProductService.saveProduct(product);
      if (result > 0) {
        Get.back();
        await getProductsOffline();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'उत्पादन सफलतापूर्वक थपियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void updateProduct(Product product) async {
    try {
      isProductsLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteProductService().updateProduct(
          token: token!, data: product.toJson(), id: product.id!);
      print(result.body);
      if (result.statusCode == 200) {
        products[products.indexWhere((element) => element.id == product.id)] =
            product;
        sellableProducts(products
            .where(
                (element) => element.isSellable == 1 || element.isSellable == 3)
            .toList());
        nonSellableProducts(products
            .where(
                (element) => element.isSellable == 2 || element.isSellable == 3)
            .toList());
        // updateNoteOffline(note);
        Get.back();
      }
    } catch (e) {
      print(e);
    } finally {
      isProductsLoading(false);
    }
  }

  updateProductOffline(Product product) async {
    try {
      var result = await _localProductService.updateProduct(product);
      if (result > 0) {
        Get.back();
        await getProductsOffline();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'उत्पादन सफलतापूर्वक अपडेट गरियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void deleteProduct(int id) async {
    try {
      isProductsLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteProductService().deleteProduct(token: token!, id: id);
      if (result.statusCode == 200) {
        products.removeWhere((element) => element.id == id);
        Get.back();
      }
    } catch (e) {
      print(e);
    } finally {
      isProductsLoading(false);
    }
  }

  deleteProductOffline(int id) async {
    try {
      var result = await _localProductService.deleteProduct(id);
      if (result > 0) {
        Get.back();
        getProductsOffline();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'उत्पादन सफलतापूर्वक मेटाइयो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
    } finally {}
  }

  void reset() {
    units.clear();
    sellableProducts.clear();
    nonSellableProducts.clear();
    isEdit(false);
    selectedProduct(null);
    isProductsLoading(false);
    products.clear();
  }
}
