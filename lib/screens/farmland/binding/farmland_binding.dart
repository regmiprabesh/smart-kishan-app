import 'package:get/get.dart';
import 'package:smart_kishan/controllers/farmland_controller.dart';

class FarmlandBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FarmlandController>()) {
      Get.lazyPut<FarmlandController>(() => FarmlandController());
    }
  }
}
