import 'package:get/get.dart';
import 'package:smart_kishan/controllers/subsidy_request_controller.dart';

class SubsidyRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubsidyRequestController>(() => SubsidyRequestController());
  }
}
