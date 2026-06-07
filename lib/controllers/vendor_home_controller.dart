import 'dart:convert';

import 'package:get/get.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/vendor/dashboard/services/remote_vendor_stat_service.dart';

class VendorHomeController extends GetxController {
  static VendorHomeController instance = Get.find();

  final LocalAuthService _localAuthService = LocalAuthService();

  RxInt totalProducts = 0.obs;
  RxInt totalOrders = 0.obs;
  RxInt grossSales = 0.obs;
  RxDouble averageOrderValue = 0.0.obs;
  RxDouble averageOrderIncrease = 0.0.obs;
  RxDouble grossSalesIncrease = 0.0.obs;
  RxDouble ordersIncrease = 0.0.obs;
  RxDouble productsIncrease = 0.0.obs;
  RxList<String> months = <String>[].obs;
  RxList<int> amounts = <int>[].obs;

  RxBool isStatLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getVendorStats();
  }

  void getVendorStats() async {
    try {
      isStatLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteVendorStatService().getVendorStat(token: token!);
      print(result.body);
      if (result != null && result.body.isNotEmpty) {
        var body = jsonDecode(result.body);
        // return;
        if (body['message'] == 'success') {
          var stats = body['stats'];
          var monthlyOrders = body['monthly_orders'];

          // Update the reactive variables with type casting
          grossSales.value =
              (double.tryParse(stats['gross_sales']['value'].toString()) ?? 0)
                  .toInt();
          grossSalesIncrease.value =
              double.tryParse(stats['gross_sales']['increase'].toString()) ??
                  0.0;
          averageOrderValue.value = double.tryParse(
                  stats['average_order_value']['value'].toString()) ??
              0.0;
          averageOrderIncrease.value = double.tryParse(
                  stats['average_order_value']['increase'].toString()) ??
              0.0;

          totalOrders.value =
              int.tryParse(stats['total_orders']['value'].toString()) ?? 0;
          ordersIncrease.value =
              double.tryParse(stats['total_orders']['increase'].toString()) ??
                  0.0;
          totalProducts.value =
              int.tryParse(stats['total_products']['value'].toString()) ?? 0;
          productsIncrease.value =
              double.tryParse(stats['total_products']['increase'].toString()) ??
                  0.0;

          // Update monthly data
          months.value = List<String>.from(monthlyOrders['months']);
          amounts.value = monthlyOrders['amounts']
              .map<int>(
                  (amount) => double.tryParse(amount.toString())?.toInt() ?? 0)
              .toList();
          amounts.refresh();
          months.refresh();
        }
      }
    } catch (e) {
      print('Error fetching vendor stats: $e');
    } finally {
      isStatLoading(false);
    }
  }

  void reset() {
    totalProducts(0);
    totalOrders(0);
    grossSales(0);
    averageOrderValue(0);
    averageOrderIncrease(0);
    grossSalesIncrease(0);
    ordersIncrease(0);
    productsIncrease(0);
    months.clear();
    amounts.clear();
    isStatLoading(false);
  }
}
