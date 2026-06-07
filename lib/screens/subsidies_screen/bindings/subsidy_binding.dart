import 'package:get/get.dart';
import 'package:smart_kishan/controllers/subsidy_controller..dart';

class SubsidyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubsidyController>(() => SubsidyController());
  }
}
