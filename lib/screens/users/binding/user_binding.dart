import 'package:get/get.dart';
import 'package:smart_kishan/controllers/user_controller.dart';

// user_binding.dart
class UserBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UserController>()) {
      Get.lazyPut<UserController>(() => UserController());
    }
  }
}
