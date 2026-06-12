import 'package:get/get.dart';
import 'package:smart_kishan/controllers/expense_controller.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ExpenseController>()) {
      Get.lazyPut<ExpenseController>(() => ExpenseController());
    }
  }
}
