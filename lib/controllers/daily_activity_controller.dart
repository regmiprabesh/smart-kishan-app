import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/activity.dart';
import 'package:smart_kishan/models/product.dart';
import 'package:smart_kishan/screens/daily_activity/services/local_activity_service.dart';
import 'package:smart_kishan/screens/daily_activity/services/remote_activity_service.dart';
import 'package:smart_kishan/screens/products/services/local_product_service.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';

class DailyActivityController extends GetxController {
  static DailyActivityController instance = Get.find();

  RxList<Product> products = List<Product>.empty(growable: true).obs;
  // RxList<Product> sellableProducts = List<Product>.empty(growable: true).obs;
  // RxList<Product> nonSellableProducts = List<Product>.empty(growable: true).obs;
  RxList<Activity> activities = List<Activity>.empty(growable: true).obs;

  final _localProductService = LocalProductService();
  final _localActivityService = LocalActivityService();

  Rx<String> selectedProductId = ''.obs;

  Rx<Activity> selectedActivity = Activity().obs;

  RxBool isEdit = false.obs;

  RxBool isActivityLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  void reset() {
    products.clear();
    activities.clear();
    selectedProductId('');
    isEdit(false);
    selectedActivity(null);
    isActivityLoading(false);
  }

  void refreshCharts() {
    incomeController.getActivities(incomeController.selectedFilter.value);
    expenseController.getActivities(expenseController.selectedFilter.value);
    chartController.getActivities(expenseController.selectedFilter.value);
  }

  @override
  void onInit() async {
    super.onInit();
    await _localProductService.init();
    await _localActivityService.init();
    await _localAuthService.init();

    // getProducts();
    getActivities();
  }

  void getActivities() async {
    try {
      isActivityLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteActivityService().getActivity(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        activities.assignAll(activityListFromJson(jsonEncode(body['data'])));
        refreshCharts();
      }
    } catch (e) {
      print(e);
      print('No Internet Connection');
    } finally {
      isActivityLoading(false);
    }
  }
  // getProductsOffline() async {
  //   try {
  //     products.clear();
  //     var data = await _localProductService.readProducts();
  //     products.assignAll(productListFromJson(jsonEncode(data)));
  //     products.refresh();
  //     sellableProducts(products
  //         .where(
  //             (element) => element.isSellable == 1 || element.isSellable == 3)
  //         .toList());
  //     nonSellableProducts(products
  //         .where(
  //             (element) => element.isSellable == 2 || element.isSellable == 3)
  //         .toList());
  //     // selectedProductId(products.first.id.toString());
  //   } catch (e) {
  //     print(e);
  //   } finally {}
  // }

  getActivitiesOffline() async {
    try {
      var data = await _localActivityService.readActivities();
      activities.assignAll(activityListFromJson(jsonEncode(data)));
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<bool> addActivity(Activity activity) async {
    // try {
    isActivityLoading(true);
    String? token = await _localAuthService.getToken();
    var result = await RemoteActivityService()
        .addActivity(token: token!, data: activity.toJson());
    if (result.statusCode == 200) {
      var body = jsonDecode(result.body);
      var newActivity = Activity.fromJson(body['data']);
      activities.add(newActivity);
      refreshCharts();
      Get.back();
    }
    // } catch (e) {
    //   print(e);
    // } finally {
    //   isActivityLoading(false);
    // }
    return false;
  }

  addActivityOffline(Activity activity) async {
    try {
      var result = await _localActivityService.saveActivity(activity);
      expenseController.getActivities('Daily');
      incomeController.getActivities('Daily');
      chartController.getActivities('Daily');
      if (result > 0) {
        Get.back();
        // await getActivities();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'दैनिक गतिविधि सफलतापूर्वक थपियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void updateActivity(Activity activity) async {
    try {
      isActivityLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteActivityService().updateActivity(
          token: token!, data: activity.toJson(), id: activity.id!);
      if (result.statusCode == 200) {
        Activity? updatedActivity =
            Activity.fromJson(jsonDecode(result.body)['data']);
        activities[
                activities.indexWhere((element) => element.id == activity.id)] =
            updatedActivity;
        // updateNoteOffline(note);
        refreshCharts();
        Get.back();
      }
    } catch (e) {
      print(e);
    } finally {
      isActivityLoading(false);
    }
  }

  updateActivityOffline(Activity activity) async {
    try {
      var result = await _localActivityService.updateActivity(activity);
      if (result > 0) {
        expenseController.getActivities('Daily');
        incomeController.getActivities('Daily');
        chartController.getActivities('Daily');
        Get.back();
        // await getActivities();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'दैनिक गतिविधि सफलतापूर्वक अद्यावधिक गरियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void deleteActivity(int id) async {
    try {
      isActivityLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteActivityService().deleteActivity(token: token!, id: id);
      if (result.statusCode == 200) {
        activities.removeWhere((element) => element.id == id);
        refreshCharts();
        Get.back();
      }
    } catch (e) {
      print(e);
    } finally {
      isActivityLoading(false);
    }
  }

  deleteActivityOffline(int id) async {
    try {
      var result = await _localActivityService.deleteActivity(id);
      if (result > 0) {
        expenseController.getActivities('Daily');
        incomeController.getActivities('Daily');
        chartController.getActivities('Daily');
        Get.back();
        // getActivities();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'दैनिक गतिविधि सफलतापूर्वक मेटाइयो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
    } finally {}
  }
}
