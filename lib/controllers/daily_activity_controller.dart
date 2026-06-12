import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/activity.dart';
import 'package:smart_kishan/screens/daily_activity/services/remote_activity_service.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';

class DailyActivityController extends GetxController {
  static DailyActivityController get instance => Get.find();

  final RxList<Activity> activities = <Activity>[].obs;

  final Rx<String> selectedProductId = ''.obs;
  final Rx<Activity> selectedActivity = Activity().obs;

  final RxBool isEdit = false.obs;
  final RxBool isActivityLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getActivities();
  }

  void refreshCharts() {
    incomeController.getActivities(incomeController.selectedFilter.value);
    expenseController.getActivities(expenseController.selectedFilter.value);
    chartController.getActivities(expenseController.selectedFilter.value);
  }

  void getActivities() async {
    try {
      isActivityLoading(true);
      final result = await RemoteActivityService().getActivity();
      if (result != null) {
        final body = jsonDecode(result.body);
        activities.assignAll(activityListFromJson(jsonEncode(body['data'])));
        refreshCharts();
      }
    } catch (e) {
      debugPrint('getActivities error: $e');
    } finally {
      isActivityLoading(false);
    }
  }

  Future<bool> addActivity(Activity activity) async {
    try {
      isActivityLoading(true);
      final result =
          await RemoteActivityService().addActivity(data: activity.toJson());
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        activities.add(Activity.fromJson(body['data']));
        refreshCharts();
        Get.back();
        return true;
      }
    } catch (e) {
      debugPrint('addActivity error: $e');
    } finally {
      isActivityLoading(false);
    }
    return false;
  }

  void updateActivity(Activity activity) async {
    try {
      isActivityLoading(true);
      final result = await RemoteActivityService()
          .updateActivity(data: activity.toJson(), id: activity.id!);
      if (result.statusCode == 200) {
        final updatedActivity =
            Activity.fromJson(jsonDecode(result.body)['data']);
        final i = activities.indexWhere((e) => e.id == activity.id);
        if (i != -1) activities[i] = updatedActivity;
        refreshCharts();
        Get.back();
      }
    } catch (e) {
      debugPrint('updateActivity error: $e');
    } finally {
      isActivityLoading(false);
    }
  }

  void deleteActivity(int id) async {
    try {
      isActivityLoading(true);
      final result = await RemoteActivityService().deleteActivity(id: id);
      if (result.statusCode == 200) {
        activities.removeWhere((e) => e.id == id);
        refreshCharts();
        Get.back();
      }
    } catch (e) {
      debugPrint('deleteActivity error: $e');
    } finally {
      isActivityLoading(false);
    }
  }
}
