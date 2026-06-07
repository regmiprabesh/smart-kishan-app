import 'package:get/get.dart';
import 'package:smart_kishan/controllers/complaint_controller.dart';

class ComplaintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComplaintController>(() => ComplaintController());
  }
}
