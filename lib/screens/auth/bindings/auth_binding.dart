import 'package:get/get.dart';
import 'package:smart_kishan/controllers/auth_controller.dart';
import 'package:smart_kishan/controllers/otp_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OTPController());
    Get.put(AuthController());
  }
}
