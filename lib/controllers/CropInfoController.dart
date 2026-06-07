import 'dart:convert';

import 'package:get/get.dart';
import 'package:smart_kishan/models/cropInfo.dart';
import 'package:smart_kishan/screens/crop_info/services/remote_crop_info_service.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';

class CropInfocontroller extends GetxController {
  static CropInfocontroller instance = Get.find();

  RxList<CropInfo> cropInfo = List<CropInfo>.empty(growable: true).obs;

  RxBool isCropInfoLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getCropInfo();
  }

  void getCropInfo() async {
    try {
      isCropInfoLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteCropInfoService().getCropInfo(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        cropInfo.assignAll(cropInfoListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      // print(e);
      print('No Internet Connection');
    } finally {
      isCropInfoLoading(false);
    }
  }
}
