import 'package:get/get.dart';
import 'package:smart_kishan/controllers/chart_controller.dart';
import 'package:smart_kishan/controllers/daily_activity_controller.dart';
import 'package:smart_kishan/controllers/dashboard_controller.dart';
import 'package:smart_kishan/controllers/expense_controller.dart';
import 'package:smart_kishan/controllers/farmland_controller.dart';
import 'package:smart_kishan/controllers/income_controller.dart';
import 'package:smart_kishan/controllers/note_controller.dart';
import 'package:smart_kishan/controllers/product_controller.dart';
import 'package:smart_kishan/controllers/sync_controller.dart';
import 'package:smart_kishan/controllers/user_controller.dart';
import 'package:smart_kishan/controllers/weather_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(WeatherController());
    Get.put(DailyActivityController());
    Get.put(ProductController());
    Get.put(IncomeController());
    Get.put(ExpenseController());
    Get.put(ChartController());
    Get.put(NoteController());
    Get.put(FarmlandController());
    Get.put(UserController());
    Get.put(SyncController());
  }
}
