import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/soildata.dart';

class RemoteFarmlandService {
  var client = http.Client();

  Future<dynamic> getSoilApiKey({required data}) async {
    var remoteUrl = 'https://soil.narc.gov.np/api/token';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> getSoilData(
      {required Coordinates data, String? token}) async {
    var remoteUrl =
        'https://soil.narc.gov.np/soil/soildata/?format=json&lat=${data.lat}&lon=${data.lng}';
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

  Future<dynamic> getFarmlands({required String token}) async {
    var remoteUrl = '$apiUrl/farmlands';
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

  Future<dynamic> addFarmland(
      {required String token,
      required Map<String, dynamic> data,
      http.MultipartFile? image}) async {
    var remoteUrl = '$apiUrl/farmlands';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };
    Map<String, String> stringData =
        data.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    if (stringData.containsKey('image')) {
      stringData.removeWhere((key, value) => key == 'image');
    }
    if (image != null) {
      var request = http.MultipartRequest('POST', Uri.parse(remoteUrl))
        ..headers.addAll(headers)
        ..fields.addAll(stringData)
        ..files.add(image);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return response;
    } else {
      var request = http.MultipartRequest('POST', Uri.parse(remoteUrl))
        ..headers.addAll(headers)
        ..fields.addAll(stringData);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return response;
    }
  }

  Future<dynamic> updateFarmland(
      {required String token,
      required Map<String, dynamic> data,
      required int id,
      http.MultipartFile? image}) async {
    var remoteUrl = '$apiUrl/farmlands/update/$id';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };
    Map<String, String> stringData =
        data.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    if (stringData.containsKey('image')) {
      stringData.removeWhere((key, value) => key == 'image');
    }
    var request = http.MultipartRequest('POST', Uri.parse(remoteUrl))
      ..headers.addAll(headers)
      ..fields.addAll(stringData);
    if (image != null) {
      request.files.add(image);
    }
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future<dynamic> deleteFarmland(
      {required String token, required int id}) async {
    var remoteUrl = '$apiUrl/farmlands/$id';
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

  Future<dynamic> getRecommendedCrop({required Coordinates coordinate}) async {
    var remoteUrl =
        'https://recommendation.safalstha.com.np/api/recommendation/data?lat=${coordinate.lat}&long=${coordinate.lng}';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }
}
