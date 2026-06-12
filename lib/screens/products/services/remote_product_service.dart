import 'dart:convert';

import 'package:smart_kishan/helpers/app_http_client.dart';
import 'package:smart_kishan/constant.dart';

class RemoteProductService {
  var client = AppHttpClient();

  Future<dynamic> getProducts() async {
    var remoteUrl = '$apiUrl/products';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  Future<dynamic> getUnits() async {
    var remoteUrl = '$apiUrl/units';
    var response = await client.get(
      Uri.parse(remoteUrl),
    );
    return response;
  }

  Future<dynamic> addProduct({required Map<String, dynamic> data}) async {
    var remoteUrl = '$apiUrl/products';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> updateProduct(
      {required Map<String, dynamic> data, required int id}) async {
    var remoteUrl = '$apiUrl/products/$id';
    var response = await client.put(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> deleteProduct({required int id}) async {
    var remoteUrl = '$apiUrl/products/$id';
    var response = await client.delete(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }
}
