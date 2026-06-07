import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/soildata.dart';

class RemoteBuyersGroupService {
  var client = http.Client();

  Future<dynamic> getBuyersGroups({required String token}) async {
    var remoteUrl = '$apiUrl/buyersgroup';
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

  Future<dynamic> validateBuyer({required String token, required phone}) async {
    var remoteUrl = '$apiUrl/buyersgroup/validate-buyer';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'phone': phone}));
    return response;
  }

  Future<dynamic> addBuyersGroup(
      {required String token,
      required Map<String, dynamic> data,
      http.MultipartFile? image}) async {
    var remoteUrl = '$apiUrl/buyersgroup';

    Map<String, String> headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };

    var request = http.MultipartRequest('POST', Uri.parse(remoteUrl))
      ..headers.addAll(headers);

    // Add fields except 'buyers' and 'image' directly
    data.forEach((key, value) {
      if (key != 'buyers' && key != 'image') {
        request.fields[key] = value?.toString() ?? '';
      }
    });

    // Handle 'buyers' separately as JSON
    if (data['buyers'] != null) {
      request.fields['buyers'] = jsonEncode(data['buyers']);
    }

    // Add image file if provided
    if (image != null) {
      request.files.add(image);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future<dynamic> updateBuyersGroup(
      {required String token,
      required Map<String, dynamic> data,
      required int id,
      http.MultipartFile? image}) async {
    var remoteUrl = '$apiUrl/buyersgroup/update/$id';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };
    var request = http.MultipartRequest('POST', Uri.parse(remoteUrl))
      ..headers.addAll(headers);

    // Add fields except 'buyers' and 'image' directly
    data.forEach((key, value) {
      if (key != 'buyers' && key != 'image') {
        request.fields[key] = value?.toString() ?? '';
      }
    });

    // Handle 'buyers' separately as JSON
    if (data['buyers'] != null) {
      request.fields['buyers'] = jsonEncode(data['buyers']);
    }

    // Add image file if provided
    if (image != null) {
      request.files.add(image);
    }
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future<dynamic> deleteBuyersGroup(
      {required String token, required int id}) async {
    var remoteUrl = '$apiUrl/buyersgroup/$id';
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
