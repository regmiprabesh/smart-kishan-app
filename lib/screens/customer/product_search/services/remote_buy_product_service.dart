import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteBuyProductService {
  var client = http.Client();

  Future<dynamic> getBuyProducts({
    required String token,
    Map<String, String>? queryParams,
  }) async {
    // Construct the URL with query parameters
    var uri = Uri.parse('$apiUrl/getBuyProducts')
        .replace(queryParameters: queryParams);

    try {
      var response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<dynamic> getFeaturedProducts({required String token}) async {
    var remoteUrl = '$apiUrl/getFeaturedProducts';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
}
