import 'dart:convert';

import 'package:get/get.dart';
import 'package:smart_kishan/models/kalimatiPrice.dart';
import 'package:smart_kishan/screens/kalimati_price/services/kalimati_price_service.dart';

class KalimatiPriceController extends GetxController {
  var isLoading = true.obs;
  var kalimatiData = Rx<KalimatiData?>(null); // Observable for KalimatiData
  static KalimatiPriceController instance = Get.find();

  final KalimatiPriceService _service = KalimatiPriceService();

  @override
  void onInit() {
    super.onInit();
    fetchPrices();
  }

  void fetchPrices() async {
    try {
      isLoading(true);
      final response = await _service.fetchKalimatiPrices();
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        KalimatiData data = KalimatiData.fromJson(body);
        kalimatiData(data);
      }
    } catch (e) {
      print('Error fetching prices: $e');
      kalimatiData.value = null; // Handle error case
    } finally {
      isLoading(false);
    }
  }

  void reset() {
    isLoading(false);
    kalimatiData(null);
  }
}
