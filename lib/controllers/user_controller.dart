import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/user.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/users/services/remote_user_service.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();

  RxList<User> users = List<User>.empty(growable: true).obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  RxBool isUserLoading = false.obs;

  RxBool isEdit = false.obs;

  Rx<User> selectedUser = User().obs;

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getMyUsers();
    // getNotesOffline();
  }

  void getMyUsers() async {
    try {
      isUserLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteUserService().getUsers(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        users.assignAll(userListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      print('No Internet Connection');
      // getNotesOffline();
    } finally {
      isUserLoading(false);
    }
  }

  Future<bool> addUser(User user) async {
    try {
      isUserLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteUserService().addUser(token: token!, data: user.toJson());
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        var newUser = User.fromJson(body['data']);
        users.add(newUser);
        Get.back();
      }
      if (result.statusCode == 422) {
        var body = jsonDecode(result.body);
        Map<String, dynamic> errors = body['errors'];
        for (List error in errors.values) {
          ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(SnackBar(
              backgroundColor: kErrorColor,
              content: Text(
                error.first,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )));
        }
      }
    } catch (e) {
    } finally {
      isUserLoading(false);
    }
    return false;
  }

  void updateUser(User user) async {
    // try {
    isUserLoading(true);
    String? token = await _localAuthService.getToken();
    var result = await RemoteUserService()
        .updateUser(token: token!, data: user.toJson(), id: user.id!);
    print(result.body);
    if (result.statusCode == 200) {
      users[users.indexWhere((element) => element.id == user.id)] = user;
      Get.back();
    }
    // } catch (e) {
    // } finally {
    //   isUserLoading(false);
    // }
  }

  void deleteUser(int id) async {
    try {
      isUserLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteUserService().deleteUser(token: token!, id: id);
      if (result.statusCode == 200) {
        users.removeWhere((element) => element.id == id);
        Get.back();
      }
    } catch (e) {
    } finally {
      isUserLoading(false);
    }
  }

  void reset() {
    users.clear();
    isUserLoading(false);
    isEdit(false);
    selectedUser(null);
  }
}
