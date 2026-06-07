import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteCropInfoService {
  var client = http.Client();

  Future<dynamic> getCropInfo({required String token}) async {
    var remoteUrl = '$apiUrl/cropInfo';
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
