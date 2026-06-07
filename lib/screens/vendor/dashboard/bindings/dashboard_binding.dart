import 'package:get/get.dart';
import 'package:smart_kishan/controllers/buyers_group_controller.dart';
import 'package:smart_kishan/controllers/sell_product_controller.dart';
import 'package:smart_kishan/controllers/vendor_dashboard_controller.dart';
import 'package:smart_kishan/controllers/vendor_home_controller.dart';
import 'package:smart_kishan/controllers/vendor_order_controller.dart';

class VendorDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VendorDashboardController());
    Get.put(VendorHomeController());
    Get.put(SellProductController());
    Get.put(VendorOrdersController());
    Get.put(BuyersGroupController());
  }
}
