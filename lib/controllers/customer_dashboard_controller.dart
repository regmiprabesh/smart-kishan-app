import 'package:get/get.dart';

class CustomerDashboardController extends GetxController {
  static CustomerDashboardController instance = Get.find();
  var tabIndex = 0;

  void updateIndex(int index) {
    tabIndex = index;
    update();
  }
}
