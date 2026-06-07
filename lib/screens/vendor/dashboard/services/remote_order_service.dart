import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteOrderService {
  var client = http.Client();

  Future<dynamic> getMyOrders({required String token}) async {
    var remoteUrl = '$apiUrl/vendor/myOrders';
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

  Future<dynamic> updateOrder({
    required String token,
    required String orderId,
    required String status,
  }) async {
    var remoteUrl = '$apiUrl/vendor/myOrders/$orderId/update';
    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );
    return response;
  }
}
