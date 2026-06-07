import 'package:get/get.dart';
import 'package:smart_kishan/controllers/sell_product_controller.dart';

class SellProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SellProductController());
  }
}
