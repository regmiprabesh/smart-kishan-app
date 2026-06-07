import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/buyersgroup.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/buyers_group/services/local_buyers_group_service.dart';
import 'package:smart_kishan/screens/buyers_group/services/remote_buyers_group_service.dart';
import 'package:smart_kishan/sync_service.dart';
import 'package:http/http.dart' as http;

class BuyersGroupController extends GetxController {
  static BuyersGroupController instance = Get.find();

  RxList<BuyersGroup> buyersGroups =
      List<BuyersGroup>.empty(growable: true).obs;

  RxList<BuyersGroup> offlineBuyersGroups =
      List<BuyersGroup>.empty(growable: true).obs;

  final _localBuyersGroupService = LocalBuyersGroupService();

  RxBool isEdit = false.obs;

  Rx<BuyersGroup> selectedBuyersGroup = BuyersGroup().obs;

  RxBool isBuyersGroupsLoading = false.obs;

  RxBool isValidateBuyerLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();
  final SyncService _syncService = SyncService();
  RxString selectedBuyersGroupImage = ''.obs;
  RxString networkBuyersGroupImage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    await _localBuyersGroupService.init();
    await _syncService.init();
    getBuyersGroups();
    // getBuyersGroupsOffline();
  }

  Comparator<BuyersGroup> sortById = (a, b) => b.id!.compareTo(a.id!);

  void getBuyersGroups() async {
    // try {
    isBuyersGroupsLoading(true);
    String? token = await _localAuthService.getToken();
    var result =
        await RemoteBuyersGroupService().getBuyersGroups(token: token!);
    if (result != null) {
      var body = jsonDecode(result.body);
      print(body);
      buyersGroups.assignAll(buyersGroupListFromJson(jsonEncode(body['data'])));
      // var data = await _localBuyersGroupService.readBuyersGroups();
      // offlineBuyersGroups.assignAll(buyersGroupListFromJson(jsonEncode(data)));
    }
    // } catch (e) {
    // print(e);
    print('No Internet Connection');
    // getBuyersGroupsOffline();
    // } finally {
    //   isBuyersGroupsLoading(false);
    // }
  }

  getBuyersGroupsOffline() async {
    try {
      var data = await _localBuyersGroupService.readBuyersGroups();
      buyersGroups.assignAll(buyersGroupListFromJson(jsonEncode(data)));
      offlineBuyersGroups.assignAll(buyersGroupListFromJson(jsonEncode(data)));
      // You can sort the list by id like this
      buyersGroups.sort(sortById);
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<Buyers?> validateBuyer(String phone) async {
    isBuyersGroupsLoading(true);
    String? token = await _localAuthService.getToken();
    try {
      final result = await RemoteBuyersGroupService()
          .validateBuyer(token: token!, phone: '+977$phone');
      if (result.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(result.body);
        Buyers buyer = Buyers.fromJson(body['buyer']);
        return buyer;
      } else {
        // ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
        //     backgroundColor: kErrorColor,
        //     content: Text(
        //       'खरिदकर्ता प्रमाणीकरण असफल भयो ! फेरि प्रयास गर्नुहोस',
        //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        //     )));
        throw Exception('User validation failed: ${result.body}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> addBuyersGroup(BuyersGroup buyersGroup, bool isSync) async {
    // try {
    isBuyersGroupsLoading(true);
    String? token = await _localAuthService.getToken();
    var image;
    if (buyersGroup.image != null) {
      image = await http.MultipartFile.fromPath('image', buyersGroup.image!);
    }
    var result = await RemoteBuyersGroupService().addBuyersGroup(
        token: token!, data: buyersGroup.toJson(), image: image);
    print(result.body);
    if (result.statusCode == 200) {
      var body = jsonDecode(result.body);
      var newBuyersGroup = BuyersGroup.fromJson(body['data']);
      buyersGroups.add(newBuyersGroup);
      Get.back();
      return true;
    } else {
      return false;
    }
    // } catch (e) {
    // if (isSync) {
    //   return false;
    // }
    // int? buyersGroupId = await addBuyersGroupOffline(buyersGroup);
    // Sync data =
    //     Sync(objectID: buyersGroupId!, objectType: 'BuyersGroup', changeType: 'create');
    // _syncService.addSyncData(data);
    // return false;
    // } finally {
    //   isBuyersGroupsLoading(false);
    // }
  }

  Future<int?>? addBuyersGroupOffline(BuyersGroup buyersGroup) async {
    try {
      var result = await _localBuyersGroupService.saveBuyersGroup(buyersGroup);
      // print(result);
      if (result > 0) {
        Get.back();
        await getBuyersGroupsOffline();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'नोट सफलतापूर्वक थपियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
        return result;
      }
    } catch (e) {
      print(e);
    } finally {}
    return null;
  }

  Future<bool?> updateBuyersGroup(BuyersGroup buyersGroup) async {
    try {
      isBuyersGroupsLoading(true);
      String? token = await _localAuthService.getToken();
      var image;
      if (buyersGroup.image != null) {
        image = await http.MultipartFile.fromPath('image', buyersGroup.image!);
      }
      var result = await RemoteBuyersGroupService().updateBuyersGroup(
          token: token!,
          data: buyersGroup.toJson(),
          id: buyersGroup.id!,
          image: image);
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        BuyersGroup updatedData = BuyersGroup.fromJson(body['data']);
        buyersGroups[buyersGroups.indexWhere(
            (element) => element.id == updatedData.id)] = updatedData;
        // updateBuyersGroupOffline(buyersGroup);
        Get.back();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // updateBuyersGroupOffline(buyersGroup);
    } finally {
      isBuyersGroupsLoading(false);
    }
  }

  updateBuyersGroupOffline(BuyersGroup buyersGroup, [bool? isSync]) async {
    try {
      var result =
          await _localBuyersGroupService.updateBuyersGroup(buyersGroup);
      if (result > 0) {
        Get.back();
        await getBuyersGroupsOffline();
        if (isSync != null && isSync) {
          return;
        }
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'नोट सफलतापूर्वक अद्यावधिक गरियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void deleteBuyersGroup(int id) async {
    try {
      isBuyersGroupsLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteBuyersGroupService()
          .deleteBuyersGroup(token: token!, id: id);
      print(result.body);
      if (result.statusCode == 200) {
        buyersGroups.removeWhere((element) => element.id == id);
        // deleteBuyersGroupOffline(id);
        Get.back();
      }
    } catch (e) {
      // deleteBuyersGroupOffline(id);
    } finally {
      isBuyersGroupsLoading(false);
    }
  }

  deleteBuyersGroupOffline(int id) async {
    try {
      var result = await _localBuyersGroupService.deleteBuyersGroup(id);
      if (result > 0) {
        Get.back();
        getBuyersGroupsOffline();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'नोट सफलतापूर्वक मेटाइयो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
    } finally {}
  }

  Future<Map<String, double>?> getMyLatLng() async {
    double lat = 27.650085;
    double lng = 85.619474;
    return {'lat': lat, 'lng': lng};
  }

  void reset() {
    buyersGroups.clear();
    offlineBuyersGroups.clear();
    isEdit(false);
    selectedBuyersGroup(null);
    isBuyersGroupsLoading(false);
    selectedBuyersGroupImage('');
    networkBuyersGroupImage('');
    isValidateBuyerLoading(false);
  }
}
