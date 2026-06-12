import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/models/unit.dart';
import 'package:smart_kishan/models/product.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/products/services/remote_product_service.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final RxList<Product> products = <Product>[].obs;
  final RxList<Unit> units = <Unit>[].obs;

  final RxList<Product> sellableProducts = <Product>[].obs;
  final RxList<Product> nonSellableProducts = <Product>[].obs;

  final RxBool isEdit = false.obs;
  final Rx<Product> selectedProduct = Product().obs;
  final RxBool isProductsLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getProducts();
    getUnits();
  }

  void _updateSellableLists() {
    sellableProducts.assignAll(
      products.where((e) => e.isSellable == 1 || e.isSellable == 3).toList(),
    );
    nonSellableProducts.assignAll(
      products.where((e) => e.isSellable == 2 || e.isSellable == 3).toList(),
    );
  }

  void getUnits() async {
    try {
      final result = await RemoteProductService().getUnits();
      if (result != null) {
        final body = jsonDecode(result.body);
        units.assignAll(unitListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      print('test');
      debugPrint('getUnits error: $e');
    }
  }

  void getProducts() async {
    try {
      isProductsLoading(true);
      final result = await RemoteProductService().getProducts();
      print(result.body);
      if (result != null) {
        final body = jsonDecode(result.body);
        products.assignAll(productListFromJson(jsonEncode(body['data'])));
        _updateSellableLists();
      }
    } catch (e) {
      debugPrint('getProducts error: $e');
    } finally {
      isProductsLoading(false);
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      isProductsLoading(true);
      final result =
          await RemoteProductService().addProduct(data: product.toJson());
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        products.add(Product.fromJson(body['data']));
        _updateSellableLists();
        Get.back();
        return true;
      }
    } catch (e) {
      debugPrint('addProduct error: $e');
    } finally {
      isProductsLoading(false);
    }
    return false;
  }

  void updateProduct(Product product) async {
    try {
      isProductsLoading(true);
      final result = await RemoteProductService()
          .updateProduct(data: product.toJson(), id: product.id!);
      if (result.statusCode == 200) {
        final i = products.indexWhere((e) => e.id == product.id);
        if (i != -1)
          products[i] = Product.fromJson(jsonDecode(result.body)['data']);
        _updateSellableLists();
        Get.back();
      }
    } catch (e) {
      debugPrint('updateProduct error: $e');
    } finally {
      isProductsLoading(false);
    }
  }

  void deleteProduct(int id) async {
    try {
      isProductsLoading(true);
      final result = await RemoteProductService().deleteProduct(id: id);
      if (result.statusCode == 200) {
        products.removeWhere((e) => e.id == id);
        _updateSellableLists();
        Get.back();
      }
    } catch (e) {
      debugPrint('deleteProduct error: $e');
    } finally {
      isProductsLoading(false);
    }
  }
}
