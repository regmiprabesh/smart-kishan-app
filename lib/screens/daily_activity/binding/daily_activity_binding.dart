import 'package:get/get.dart';
import 'package:smart_kishan/controllers/daily_activity_controller.dart';

// daily_activity_binding.dart
class DailyActivityBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DailyActivityController>()) {
      Get.lazyPut<DailyActivityController>(() => DailyActivityController());
    }
  }
}
