import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteProductService {
  var client = http.Client();

  Future<dynamic> getProducts({required String token}) async {
    var remoteUrl = '$apiUrl/products';
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

  Future<dynamic> getUnits() async {
    var remoteUrl = '$apiUrl/units';
    var response = await client.get(
      Uri.parse(remoteUrl),
    );
    return response;
  }

  Future<dynamic> addProduct(
      {required String token, required Map<String, dynamic> data}) async {
    var remoteUrl = '$apiUrl/products';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> updateProduct(
      {required String token,
      required Map<String, dynamic> data,
      required int id}) async {
    var remoteUrl = '$apiUrl/products/$id';
    var response = await client.put(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> deleteProduct(
      {required String token, required int id}) async {
    var remoteUrl = '$apiUrl/products/$id';
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
}
