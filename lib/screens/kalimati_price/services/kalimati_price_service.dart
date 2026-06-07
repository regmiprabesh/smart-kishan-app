import 'dart:convert';
import 'package:http/http.dart' as http;

class KalimatiPriceService {
  var client = http.Client();

  final String baseUrl =
      "https://kalimatimarket.gov.np/api/daily-prices/np"; // Replace with actual API URL

  Future<dynamic> fetchKalimatiPrices() async {
    final response = await client.get(Uri.parse(baseUrl));
    print(response);
    return response;
  }
}
