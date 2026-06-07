import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteUserService {
  var client = http.Client();

  Future<dynamic> getUsers({required String token}) async {
    var remoteUrl = '$apiUrl/users';
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

  Future<dynamic> addUser(
      {required String token, required Map<String, dynamic> data}) async {
    var remoteUrl = '$apiUrl/users';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> updateUser(
      {required String token,
      required Map<String, dynamic> data,
      required int id}) async {
    var remoteUrl = '$apiUrl/users/$id';
    var response = await client.put(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> deleteUser({required String token, required int id}) async {
    var remoteUrl = '$apiUrl/users/$id';
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
