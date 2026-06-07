import 'package:get/get.dart';

class VendorDashboardController extends GetxController {
  static VendorDashboardController instance = Get.find();
  var tabIndex = 0;

  void updateIndex(int index) {
    tabIndex = index;
    update();
  }
}
