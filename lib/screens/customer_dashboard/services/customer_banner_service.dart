import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteCustomerBannerService {
  var client = http.Client();

  Future<dynamic> getCustomerBanner({required String token}) async {
    var remoteUrl = '$apiUrl/customerBanners';
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
