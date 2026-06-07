import 'dart:convert';

import 'package:get/get.dart';
import 'package:smart_kishan/models/banner.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/customer_dashboard/services/customer_banner_service.dart';

class BannerController extends GetxController {
  static BannerController instance = Get.find();
  RxList<Banner> banners = List<Banner>.empty(growable: true).obs;
  RxBool isBannersLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getCustomerBanners();
  }

  void getCustomerBanners() async {
    try {
      isBannersLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteCustomerBannerService().getCustomerBanner(token: token!);
      print(result.body);
      if (result != null) {
        var body = jsonDecode(result.body);
        var data = body['data'];
        banners.assignAll(bannerListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      print(e);
    } finally {
      isBannersLoading(false);
    }
  }

  void reset() {
    banners.clear();
    isBannersLoading(false);
  }
}
