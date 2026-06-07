import 'dart:ffi';

import 'package:get/get.dart';
import 'dart:convert';
import 'package:smart_kishan/models/searchHistory.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/customer/product_search/services/remote_search_history_service.dart';

class SearchHistoryController extends GetxController {
  static SearchHistoryController instance = Get.find();

  RxList<SearchHistory> searchHistory =
      List<SearchHistory>.empty(growable: true).obs;
  var isLoading = false.obs;
  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getSearchHistory();
  }

  // Fetch search history from Laravel API
  Future<void> getSearchHistory() async {
    isLoading.value = true;
    String? token = await _localAuthService.getToken();
    try {
      var result =
          await RemoteSearchHistoryService().getSearchHistory(token: token!);
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        searchHistory
            .assignAll(searchHistoryListFromJson(jsonEncode(body['data'])));
      } else {
        // Get.snackbar('Error', 'Failed to load search history');
      }
    } catch (e) {
      // Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    searchHistory.clear();
    isLoading(false);
  }
}
