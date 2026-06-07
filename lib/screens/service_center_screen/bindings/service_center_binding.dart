import 'package:get/get.dart';
import 'package:smart_kishan/controllers/service_center_controller.dart';

class ServiceCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceCenterController>(() => ServiceCenterController());
  }
}
