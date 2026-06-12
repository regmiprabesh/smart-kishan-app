import 'dart:convert';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/helpers/app_http_client.dart';

class RemoteServiceCenterService {
  final client = AppHttpClient();

  static const _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> getTypes() async {
    return await client.get(
      Uri.parse('$apiUrl/service-centers/types'),
      headers: _headers,
    );
  }

  Future<dynamic> getServiceCenters({
    int? typeId,
    String? search,
    double? latitude,
    double? longitude,
    double? radius,
    bool? featured,
    String? sortBy,
  }) async {
    final params = <String, String>{};

    if (typeId != null) params['type_id'] = typeId.toString();
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (latitude != null) params['latitude'] = latitude.toString();
    if (longitude != null) params['longitude'] = longitude.toString();
    if (radius != null) params['radius'] = radius.toString();
    if (featured != null) params['featured'] = featured ? '1' : '0';
    if (sortBy != null) params['sort_by'] = sortBy;

    final uri =
        Uri.parse('$apiUrl/service-centers').replace(queryParameters: params);

    return await client.get(uri, headers: _headers);
  }

  Future<dynamic> getNearbyServiceCenters({
    required double latitude,
    required double longitude,
    double radius = 20,
  }) async {
    final uri = Uri.parse('$apiUrl/service-centers/nearby').replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radius': radius.toString(),
      },
    );

    return await client.get(uri, headers: _headers);
  }

  Future<dynamic> getServiceCenter({required int id}) async {
    return await client.get(
      Uri.parse('$apiUrl/service-centers/$id'),
      headers: _headers,
    );
  }

  Future<dynamic> rateServiceCenter({
    required int serviceCenterId,
    required int rating,
    String? review,
  }) async {
    return await client.post(
      Uri.parse('$apiUrl/service-centers/$serviceCenterId/rate'),
      headers: _headers,
      body: jsonEncode({'rating': rating, 'review': review}),
    );
  }

  Future<dynamic> getUserRating({required int serviceCenterId}) async {
    return await client.get(
      Uri.parse('$apiUrl/service-centers/$serviceCenterId/my-rating'),
      headers: _headers,
    );
  }

  Future<dynamic> deleteRating({required int serviceCenterId}) async {
    return await client.delete(
      Uri.parse('$apiUrl/service-centers/$serviceCenterId/my-rating'),
      headers: _headers,
    );
  }
}
