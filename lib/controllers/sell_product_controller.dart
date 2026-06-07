import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/cropCategory.dart';
import 'package:smart_kishan/models/deliverylocation.dart';
import 'package:smart_kishan/models/paymentmethod.dart';
import 'package:smart_kishan/models/sellproduct.dart';
import 'package:smart_kishan/models/unit.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/products/services/remote_product_service.dart';
import 'package:smart_kishan/screens/sell_product/services/remote_sell_product_service.dart';
import 'package:http/http.dart' as http;

class SellProductController extends GetxController {
  static SellProductController instance = Get.find();
  final LocalAuthService _localAuthService = LocalAuthService();
  RxBool isDeliveryLocationsLoading = false.obs;
  RxBool isPaymentTypesLoading = false.obs;
  RxBool isCropCategoryLoading = false.obs;
  RxBool isUnitLoading = false.obs;
  RxBool isSellProductLoading = false.obs;

  RxBool isEdit = false.obs;

  RxList<DeliveryLocation> deliveryLocations =
      List<DeliveryLocation>.empty(growable: true).obs;
  RxList<PaymentMethod> paymentMethods =
      List<PaymentMethod>.empty(growable: true).obs;
  RxList<CropCategory> cropCategories =
      List<CropCategory>.empty(growable: true).obs;
  RxList<SellProduct> sellProducts =
      List<SellProduct>.empty(growable: true).obs;

  Rx<SellProduct> selectedSellProduct = SellProduct().obs;

  RxList<String> selectedSellProductImages =
      List<String>.empty(growable: true).obs;
  RxList<String> networkSellProductImages =
      List<String>.empty(growable: true).obs;
  RxList<Unit> units = List<Unit>.empty(growable: true).obs;

  RxBool isAddSellProductLoading = false.obs;
  RxBool isUpdateSellProductLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getCropCategories();
    getDeliveryLocations();
    getPaymentTypes();
    getSellProducts();
    getUnits();
  }

  void getPaymentTypes() async {
    try {
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteSellProductService().getPaymentTypes(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        paymentMethods.assignAll(paymentMethodListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      print('No Internet Connection');
    } finally {
      isPaymentTypesLoading(false);
    }
  }

  void getDeliveryLocations() async {
    // try {
    String? token = await _localAuthService.getToken();
    var result =
        await RemoteSellProductService().getDeliveryLocations(token: token!);
    if (result != null) {
      var body = jsonDecode(result.body);
      var data = body['data'];
      deliveryLocations
          .assignAll(deliveryLocationListFromJson(jsonEncode(data)));
    }
    // } catch (e) {
    //   print(e);
    //   print('No Internet Connection');
    // } finally {
    //   isDeliveryLocationsLoading(false);
    // }
  }

  void getCropCategories() async {
    try {
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteSellProductService().getCropCategories(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        cropCategories.assignAll(cropCategoryListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      print(e);
      print('No Internet Connection');
    } finally {
      isCropCategoryLoading(false);
    }
  }

  Future<void> getSellProducts() async {
    try {
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteSellProductService().getSellProducts(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        sellProducts.assignAll(sellProductListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      print(e);
      print('No Internet Connection');
    } finally {
      isCropCategoryLoading(false);
    }
  }

  void getUnits() async {
    try {
      var result = await RemoteProductService().getUnits();
      if (result != null) {
        var body = jsonDecode(result.body);
        units.assignAll(unitListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      // print(e);
      print('No Internet Connection');
    } finally {
      isUnitLoading(false);
    }
  }

  Future<bool> addSellProduct(
    SellProduct sellProduct,
    bool isSync,
  ) async {
    try {
      isAddSellProductLoading(true);
      String? token = await _localAuthService.getToken();
      List<http.MultipartFile> images = [];
      if (sellProduct.selectedImages != null) {
        for (var imagePath in sellProduct.selectedImages!) {
          var file = await http.MultipartFile.fromPath(
            'images[]', // Use the array notation
            imagePath,
          );
          images.add(file);
        }
      }
      var result = await RemoteSellProductService().addSellProduct(
          token: token!, data: sellProduct.toJson(), images: images);
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        var newSellProduct = SellProduct.fromJson(body['data']);
        sellProducts.add(newSellProduct);
        // Get.back();
        isAddSellProductLoading(false);
        return true;
      }
      return false;
    } catch (e) {
      isAddSellProductLoading(false);
    } finally {
      isAddSellProductLoading(false);
    }
    return false;
  }

  Future<bool> updateSellProduct(SellProduct sellProduct) async {
    try {
      isUpdateSellProductLoading(true);
      String? token = await _localAuthService.getToken();
      List<http.MultipartFile> images = [];
      if (sellProduct.selectedImages != null) {
        for (var imagePath in sellProduct.selectedImages!) {
          var file = await http.MultipartFile.fromPath(
            'images[]', // Use the array notation
            imagePath,
          );
          images.add(file);
        }
      }

      var result = await RemoteSellProductService().updateSellProduct(
          token: token!,
          data: sellProduct.toJson(),
          id: sellProduct.id!,
          images: images);
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        SellProduct updatedData = SellProduct.fromJson(body['data']);
        sellProducts[sellProducts.indexWhere(
            (element) => element.id == updatedData.id)] = updatedData;
        isUpdateSellProductLoading(false);

        // Get.back();
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      isUpdateSellProductLoading(false);
    }
  }

  void deleteSellProduct(int id) async {
    try {
      isSellProductLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteSellProductService()
          .deleteSellProduct(token: token!, id: id);
      if (result.statusCode == 200) {
        sellProducts.removeWhere((element) => element.id == id);
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
      isSellProductLoading(false);
    }
  }

  void reset() {
    sellProducts.clear();
    isEdit(false);
    selectedSellProduct(null);
    isUpdateSellProductLoading(false);
    isAddSellProductLoading(false);
    isDeliveryLocationsLoading(false);
    isPaymentTypesLoading(false);
    isCropCategoryLoading(false);
    isUnitLoading(false);
    isSellProductLoading(false);
    deliveryLocations.clear();
    paymentMethods.clear();
    cropCategories.clear();
    selectedSellProductImages.clear();
    networkSellProductImages.clear();
    units.clear();
  }
}
