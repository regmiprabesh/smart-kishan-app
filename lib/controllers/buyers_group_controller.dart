import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/models/buyersgroup.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/buyers_group/services/remote_buyers_group_service.dart';
import 'package:http/http.dart' as http;

class BuyersGroupController extends GetxController {
  static BuyersGroupController instance = Get.find();

  RxList<BuyersGroup> buyersGroups =
      List<BuyersGroup>.empty(growable: true).obs;

  RxBool isEdit = false.obs;

  Rx<BuyersGroup> selectedBuyersGroup = BuyersGroup().obs;

  RxBool isBuyersGroupsLoading = false.obs;

  RxBool isValidateBuyerLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  RxString selectedBuyersGroupImage = ''.obs;
  RxString networkBuyersGroupImage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getBuyersGroups();
  }

  void getBuyersGroups() async {
    try {
      isBuyersGroupsLoading(true);
      final token = await _localAuthService.getToken();
      final result =
          await RemoteBuyersGroupService().getBuyersGroups(token: token!);
      if (result != null && result.statusCode == 200) {
        final body = jsonDecode(result.body);
        buyersGroups
            .assignAll(buyersGroupListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      debugPrint('getBuyersGroups error: $e');
    } finally {
      isBuyersGroupsLoading(false);
    }
  }

  Future<Buyers?> validateBuyer(String phone) async {
    try {
      isBuyersGroupsLoading(true);
      final token = await _localAuthService.getToken();
      final result = await RemoteBuyersGroupService()
          .validateBuyer(token: token!, phone: '+977$phone');
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        return Buyers.fromJson(body['buyer']);
      } else {
        throw Exception('User validation failed: ${result.body}');
      }
    } catch (e) {
      debugPrint('validateBuyer error: $e');
    } finally {
      isBuyersGroupsLoading(false);
    }
    return null;
  }

  Future<bool> addBuyersGroup(BuyersGroup buyersGroup) async {
    try {
      isBuyersGroupsLoading(true);
      final token = await _localAuthService.getToken();
      http.MultipartFile? image;
      if (buyersGroup.image != null) {
        image = await http.MultipartFile.fromPath('image', buyersGroup.image!);
      }
      final result = await RemoteBuyersGroupService().addBuyersGroup(
          token: token!, data: buyersGroup.toJson(), image: image);
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        buyersGroups.add(BuyersGroup.fromJson(body['data']));
        Get.back();
        return true;
      }
    } catch (e) {
      debugPrint('addBuyersGroup error: $e');
    } finally {
      isBuyersGroupsLoading(false);
    }
    return false;
  }

  Future<bool> updateBuyersGroup(BuyersGroup buyersGroup) async {
    try {
      isBuyersGroupsLoading(true);
      final token = await _localAuthService.getToken();
      http.MultipartFile? image;
      if (buyersGroup.image != null) {
        image = await http.MultipartFile.fromPath('image', buyersGroup.image!);
      }
      final result = await RemoteBuyersGroupService().updateBuyersGroup(
          token: token!,
          data: buyersGroup.toJson(),
          id: buyersGroup.id!,
          image: image);
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        final updatedData = BuyersGroup.fromJson(body['data']);
        final i = buyersGroups.indexWhere((e) => e.id == updatedData.id);
        if (i != -1) buyersGroups[i] = updatedData;
        Get.back();
        return true;
      }
    } catch (e) {
      debugPrint('updateBuyersGroup error: $e');
    } finally {
      isBuyersGroupsLoading(false);
    }
    return false;
  }

  void deleteBuyersGroup(int id) async {
    try {
      isBuyersGroupsLoading(true);
      final token = await _localAuthService.getToken();
      final result = await RemoteBuyersGroupService()
          .deleteBuyersGroup(token: token!, id: id);
      if (result.statusCode == 200) {
        buyersGroups.removeWhere((e) => e.id == id);
        Get.back();
      }
    } catch (e) {
      debugPrint('deleteBuyersGroup error: $e');
    } finally {
      isBuyersGroupsLoading(false);
    }
  }

  Future<Map<String, double>?> getMyLatLng() async {
    return {'lat': 27.650085, 'lng': 85.619474};
  }
}
