import 'package:get/get.dart';
import 'package:smart_kishan/controllers/banner_controller.dart';
import 'package:smart_kishan/controllers/buy_products_controller.dart';
import 'package:smart_kishan/controllers/crop_category_controller.dart';
import 'package:smart_kishan/controllers/customer_dashboard_controller.dart';
import 'package:smart_kishan/controllers/customer_order_controller.dart';
import 'package:smart_kishan/controllers/delivery_address_controller.dart';
import 'package:smart_kishan/controllers/product_cart_controller.dart';
import 'package:smart_kishan/controllers/search_history_controller.dart';

class CustomerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CustomerDashboardController());
    Get.put(CustomerOrdersController());
    Get.put(BannerController());
    Get.put(CropCategoryController());
    Get.put(BuyProductsController());
    Get.put(ProductCartController());
    Get.put(SearchHistoryController());
    Get.put(DeliveryAddressController());
  }
}
