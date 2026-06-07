import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteProductCartService {
  var client = http.Client();

  Future<dynamic> getCartItems({required String token}) async {
    var remoteUrl = '$apiUrl/myCart';
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

  Future<dynamic> addCartItem(
      {required String token, required Map<String, dynamic> data}) async {
    var remoteUrl = '$apiUrl/myCart';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> deleteCartProduct(
      {required String token, required int id}) async {
    var remoteUrl = '$apiUrl/myCart/$id';
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
