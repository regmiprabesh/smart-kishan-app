import 'package:get/get.dart';
import 'package:smart_kishan/controllers/income_controller.dart';

class IncomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<IncomeController>()) {
      Get.lazyPut<IncomeController>(() => IncomeController());
    }
  }
}
