import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteOrderService {
  var client = http.Client();

  Future<dynamic> getMyOrders({required String token}) async {
    var remoteUrl = '$apiUrl/customer/myOrders';
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

  Future<dynamic> orderFromCart(
      {required String token, required Map<String, dynamic> data}) async {
    var remoteUrl = '$apiUrl/customer/myOrders';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> cancelOrder(
      {required String token, required String orderId}) async {
    var remoteUrl = '$apiUrl/customer/myOrders/$orderId/cancel';
    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<dynamic> orderDirectly(
      {required String token, required Map<String, dynamic> data}) async {
    var remoteUrl = '$apiUrl/customer/directOrder';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }
}
