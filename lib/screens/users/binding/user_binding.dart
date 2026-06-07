import 'package:get/get.dart';
import 'package:smart_kishan/controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
  }
}
