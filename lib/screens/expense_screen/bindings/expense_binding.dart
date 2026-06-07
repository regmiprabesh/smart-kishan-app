import 'package:get/get.dart';
import 'package:smart_kishan/controllers/daily_activity_controller.dart';
import 'package:smart_kishan/controllers/expense_controller.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ExpenseController());
    Get.put(DailyActivityController());
  }
}
