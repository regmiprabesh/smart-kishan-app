import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteSellProductService {
  var client = http.Client();

  Future<dynamic> getDeliveryLocations({required String token}) async {
    var remoteUrl = '$apiUrl/deliveryLocations';
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

  Future<dynamic> getPaymentTypes({required String token}) async {
    var remoteUrl = '$apiUrl/paymentMethods';
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

  Future<dynamic> getCropCategories({required String token}) async {
    var remoteUrl = '$apiUrl/cropCategories';
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

  Future<dynamic> getSellProducts({required String token}) async {
    var remoteUrl = '$apiUrl/sellProducts';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return response;
  }

  Future<dynamic> addSellProduct(
      {required String token,
      required Map<String, dynamic> data,
      List<http.MultipartFile>? images}) async {
    var remoteUrl = '$apiUrl/sellProducts';

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };

    Map<String, String> stringData =
        data.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    if (stringData.containsKey('selectedImages')) {
      stringData.removeWhere((key, value) => key == 'selectedImages');
    }
    var request = http.MultipartRequest('POST', Uri.parse(remoteUrl))
      ..headers.addAll(headers)
      ..fields.addAll(stringData);

    if (images != null) {
      request.files.addAll(images);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future<dynamic> updateSellProduct(
      {required String token,
      required Map<String, dynamic> data,
      required int id,
      List<http.MultipartFile>? images}) async {
    var remoteUrl = '$apiUrl/sellProducts/update/$id';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };
    Map<String, String> stringData =
        data.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    if (stringData.containsKey('selectedImages')) {
      stringData.removeWhere((key, value) => key == 'selectedImages');
    }
    var request = http.MultipartRequest('POST', Uri.parse(remoteUrl))
      ..headers.addAll(headers)
      ..fields.addAll(stringData);

    if (images != null) {
      request.files.addAll(images);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future<dynamic> deleteSellProduct(
      {required String token, required int id}) async {
    var remoteUrl = '$apiUrl/sellProducts/$id';
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
