import 'package:get/get.dart';
import 'package:smart_kishan/controllers/product_controller.dart';

class NoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductController());
  }
}
