import 'package:get/get.dart';
import 'package:smart_kishan/controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProductController>()) {
      Get.lazyPut<ProductController>(() => ProductController());
    }
  }
}
