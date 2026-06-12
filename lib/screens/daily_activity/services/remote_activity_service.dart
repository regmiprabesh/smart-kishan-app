import 'dart:convert';

import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/helpers/app_http_client.dart';

class RemoteActivityService {
  var client = AppHttpClient();

  Future<dynamic> getActivity() async {
    var remoteUrl = '$apiUrl/activities';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  Future<dynamic> addActivity({required Map<String, dynamic> data}) async {
    var remoteUrl = '$apiUrl/activities';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> updateActivity(
      {required Map<String, dynamic> data, required int id}) async {
    var remoteUrl = '$apiUrl/activities/$id';
    var response = await client.put(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> deleteActivity({required int id}) async {
    var remoteUrl = '$apiUrl/activities/$id';
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
