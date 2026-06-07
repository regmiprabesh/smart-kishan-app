import 'package:get/get.dart';
import 'package:smart_kishan/controllers/CropInfoController.dart';

class CropInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CropInfocontroller());
  }
}
