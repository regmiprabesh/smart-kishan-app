import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteDeliveryAddressService {
  var client = http.Client();

  Future<dynamic> getDeliveryAddress({required String token}) async {
    var remoteUrl = '$apiUrl/deliveryAddress';
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

  Future<http.Response> addDeliveryAddress({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    var remoteUrl = '$apiUrl/deliveryAddress';
    return await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  Future<dynamic> deleteDeliveryAddress(
      {required String token, required int id}) async {
    var remoteUrl = '$apiUrl/deliveryAddress/$id';
    var response = await client.delete(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<dynamic> updateDeliveryAddress(
      {required String token,
      required Map<String, dynamic> data,
      required int id}) async {
    var remoteUrl = '$apiUrl/deliveryAddress/$id';
    var response = await client.put(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }
}
