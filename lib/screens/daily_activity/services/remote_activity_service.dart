import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteActivityService {
  var client = http.Client();

  Future<dynamic> getActivity({required String token}) async {
    var remoteUrl = '$apiUrl/activities';
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

  Future<dynamic> addActivity(
      {required String token, required Map<String, dynamic> data}) async {
    var remoteUrl = '$apiUrl/activities';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> updateActivity(
      {required String token,
      required Map<String, dynamic> data,
      required int id}) async {
    var remoteUrl = '$apiUrl/activities/$id';
    var response = await client.put(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> deleteActivity(
      {required String token, required int id}) async {
    var remoteUrl = '$apiUrl/activities/$id';
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
