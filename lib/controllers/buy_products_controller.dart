import 'dart:convert';

import 'package:get/get.dart';
import 'package:smart_kishan/models/cropCategory.dart';
import 'package:smart_kishan/models/deliverylocation.dart';
import 'package:smart_kishan/models/paymentmethod.dart';
import 'package:smart_kishan/models/sellproduct.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/customer/product_search/services/remote_buy_product_service.dart';
import 'package:smart_kishan/screens/sell_product/services/remote_sell_product_service.dart';

class BuyProductsController extends GetxController {
  static BuyProductsController instance = Get.find();

  RxList<SellProduct> allProducts = List<SellProduct>.empty(growable: true).obs;
  RxList<SellProduct> featuredProducts =
      List<SellProduct>.empty(growable: true).obs;

  RxBool isProductsLoading = false.obs;
  RxBool isFeaturedProductsLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();
  RxList<DeliveryLocation> deliveryLocations =
      List<DeliveryLocation>.empty(growable: true).obs;
  RxBool isDeliveryLocationsLoading = false.obs;
  RxList<PaymentMethod> paymentMethods =
      List<PaymentMethod>.empty(growable: true).obs;
  RxBool isPaymentTypesLoading = false.obs;

  var searchName = ''.obs;
  RxList<PaymentMethod> selectedPaymentMethods = RxList<PaymentMethod>();
  RxList<CropCategory> selectedCategories = RxList<CropCategory>();

  var sortBy = 'Default'.obs;

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getAllProducts();
    getFeaturedProducts();
    getDeliveryLocations();
    getPaymentTypes();
  }

  void clearFilters() {
    selectedPaymentMethods.clear();
    selectedCategories.clear();
    searchProducts(); // Re-run search with cleared filters
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
      print(e);
      print('No Internet Connection');
    } finally {
      isPaymentTypesLoading(false);
    }
  }

  void getAllProducts() async {
    try {
      isProductsLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteBuyProductService().getBuyProducts(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        allProducts.assignAll(sellProductListFromJson(jsonEncode(data)));
        allProducts.refresh();
      }
    } catch (e) {
      // print(e);
      print('No Internet Connection');
    } finally {
      isProductsLoading(false);
    }
  }

  void getFeaturedProducts() async {
    try {
      isFeaturedProductsLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteBuyProductService().getFeaturedProducts(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        featuredProducts.assignAll(sellProductListFromJson(jsonEncode(data)));
        featuredProducts.refresh();
      }
    } catch (e) {
      // print(e);
      print('No Internet Connection');
    } finally {
      isFeaturedProductsLoading(false);
    }
  }

  void getDeliveryLocations() async {
    try {
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteSellProductService().getDeliveryLocations(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        deliveryLocations
            .assignAll(deliveryLocationListFromJson(jsonEncode(data)));
        deliveryLocations.refresh();
      }
    } catch (e) {
      print(e);
      print('No Internet Connection');
    } finally {
      isDeliveryLocationsLoading(false);
    }
  }

  void searchProducts({
    String? name,
    String? categoryIds,
    String? paymentTypeIds,
    String? sortsBy,
    String? sortOrder,
  }) async {
    try {
      isProductsLoading(true);
      String? token = await _localAuthService.getToken();
      final selectedPaymentIds =
          selectedPaymentMethods.map((e) => e.id).toList();
      final selectedCategoryIds = selectedCategories.map((e) => e.id).toList();

      // Construct query parameters
      Map<String, String> queryParams = {};
      if (searchName.value != '' && searchName.value.isNotEmpty) {
        queryParams['name'] = searchName.value;
      }
      if (selectedCategoryIds.isNotEmpty) {
        queryParams['category_ids'] = jsonEncode(selectedCategoryIds);
      }

      if (selectedPaymentIds.isNotEmpty) {
        queryParams['payment_type_ids'] = jsonEncode(selectedPaymentIds);
      }

      if (sortBy.value != '' && sortBy.isNotEmpty) {
        queryParams['sort_by'] = sortBy.value;
      }
      if (sortOrder != null && sortOrder.isNotEmpty) {
        queryParams['sort_order'] = sortOrder;
      }
      var result = await RemoteBuyProductService()
          .getBuyProducts(token: token!, queryParams: queryParams);

      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        allProducts.assignAll(sellProductListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      print('No Internet Connection');
    } finally {
      isProductsLoading(false);
    }
  }

  void reset() {
    allProducts.clear();
    featuredProducts.clear();
    deliveryLocations.clear();
    paymentMethods.clear();
    isDeliveryLocationsLoading(false);
    isPaymentTypesLoading(false);
    isFeaturedProductsLoading(false);
    isProductsLoading(false);
    searchName('');
    selectedCategories.clear();
    selectedPaymentMethods.clear();
    sortBy('Default');
  }
}
