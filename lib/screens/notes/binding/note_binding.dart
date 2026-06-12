import 'package:get/get.dart';
import 'package:smart_kishan/controllers/note_controller.dart';

class NoteBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NoteController>()) {
      Get.lazyPut<NoteController>(() => NoteController());
    }
  }
}
