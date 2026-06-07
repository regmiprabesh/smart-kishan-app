import 'dart:convert';

import 'package:get/get.dart';
import 'package:smart_kishan/models/cropCategory.dart';
import 'package:smart_kishan/screens/crop_info/services/remote_crop_info_service.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/sell_product/services/remote_sell_product_service.dart';

class CropCategoryController extends GetxController {
  static CropCategoryController instance = Get.find();

  RxList<CropCategory> cropCategories =
      List<CropCategory>.empty(growable: true).obs;

  RxBool isCropCategoryLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getCropCategories();
  }

  void getCropCategories() async {
    try {
      isCropCategoryLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteSellProductService().getCropCategories(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        cropCategories.assignAll(cropCategoryListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      // print(e);
      print('No Internet Connection');
    } finally {
      isCropCategoryLoading(false);
    }
  }

  void reset() {
    cropCategories.clear();
    isCropCategoryLoading(false);
  }
}
