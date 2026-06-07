import 'package:get/get.dart';
import 'package:smart_kishan/controllers/daily_activity_controller.dart';
import 'package:smart_kishan/controllers/income_controller.dart';

class IncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IncomeController());
    Get.put(DailyActivityController());
  }
}
