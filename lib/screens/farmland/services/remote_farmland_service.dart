import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/helpers/app_http_client.dart';
import 'package:smart_kishan/models/soildata.dart';

class RemoteFarmlandService {
  final _client = AppHttpClient();

  static const _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<http.Response> getFarmlands() async {
    return await _client.get(
      Uri.parse('$apiUrl/farmlands'),
      headers: _headers,
    );
  }

  Future<http.Response> addFarmland({
    required Map<String, dynamic> data,
    http.MultipartFile? image,
  }) async {
    final stringData = _toStringMap(data);
    final request =
        http.MultipartRequest('POST', Uri.parse('$apiUrl/farmlands'))
          ..headers['Accept'] = 'application/json'
          ..fields.addAll(stringData);
    if (image != null) request.files.add(image);
    return await _sendMultipart(request);
  }

  Future<http.Response> updateFarmland({
    required Map<String, dynamic> data,
    required int id,
    http.MultipartFile? image,
  }) async {
    final stringData = _toStringMap(data);
    final request =
        http.MultipartRequest('POST', Uri.parse('$apiUrl/farmlands/update/$id'))
          ..headers['Accept'] = 'application/json'
          ..fields.addAll(stringData);
    if (image != null) request.files.add(image);
    return await _sendMultipart(request);
  }

  Future<http.Response> deleteFarmland({required int id}) async {
    return await _client.delete(
      Uri.parse('$apiUrl/farmlands/$id'),
      headers: _headers,
    );
  }

  Future<http.Response> getSoilApiKey(
      {required Map<String, dynamic> data}) async {
    return await _client.post(
      Uri.parse('https://soil.narc.gov.np/api/token'),
      headers: _headers,
      body: data,
    );
  }

  Future<http.Response> getSoilData(
      {required Coordinates data, String? token}) async {
    return await _client.get(
      Uri.parse(
          'https://soil.narc.gov.np/soil/soildata/?format=json&lat=${data.lat}&lon=${data.lng}'),
      headers: {
        ..._headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> getRecommendedCrop(
      {required Coordinates coordinate}) async {
    return await _client.get(
      Uri.parse(
          'https://recommendation.safalstha.com.np/api/recommendation/data?lat=${coordinate.lat}&long=${coordinate.lng}'),
      headers: _headers,
    );
  }

  // Strips the 'image' key out and converts all values to String,
  // since MultipartRequest.fields only accepts Map<String, String>.
  Map<String, String> _toStringMap(Map<String, dynamic> data) {
    return Map.fromEntries(
      data.entries
          .where((e) => e.key != 'image')
          .map((e) => MapEntry(e.key, e.value?.toString() ?? '')),
    );
  }

  Future<http.Response> _sendMultipart(http.MultipartRequest request) async {
    final streamed = await _client.send(request);
    return await http.Response.fromStream(streamed);
  }
}
