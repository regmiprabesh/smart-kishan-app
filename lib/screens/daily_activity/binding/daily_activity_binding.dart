import 'package:get/get.dart';
import 'package:smart_kishan/controllers/daily_activity_controller.dart';

class DailyActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DailyActivityController());
  }
}
