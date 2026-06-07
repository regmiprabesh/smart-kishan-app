import 'package:get/get.dart';
import 'package:smart_kishan/controllers/kalimati_price_controller.dart';

class KalimatiPriceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KalimatiPriceController());
  }
}
