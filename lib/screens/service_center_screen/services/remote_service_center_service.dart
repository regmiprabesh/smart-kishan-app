import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_kishan/constant.dart';

class RemoteServiceCenterService {
  var client = http.Client();

  // Get all service center types
  Future<dynamic> getTypes({required String token}) async {
    var remoteUrl = '$apiUrl/service-centers/types';
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

  // Get all service centers with optional filters
  Future<dynamic> getServiceCenters({
    required String token,
    int? typeId,
    List<int>? typeIds,
    int? provinceId,
    int? districtId,
    int? municipalityId,
    String? search,
    double? latitude,
    double? longitude,
    double? radius,
    bool? featured,
    String? sortBy,
  }) async {
    var remoteUrl = '$apiUrl/service-centers';

    // Build query parameters
    Map<String, String> queryParams = {};

    if (typeId != null) queryParams['type_id'] = typeId.toString();
    if (typeIds != null && typeIds.isNotEmpty) {
      queryParams['type_ids'] = jsonEncode(typeIds);
    }
    if (provinceId != null) queryParams['province_id'] = provinceId.toString();
    if (districtId != null) queryParams['district_id'] = districtId.toString();
    if (municipalityId != null)
      queryParams['municipality_id'] = municipalityId.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (latitude != null) queryParams['latitude'] = latitude.toString();
    if (longitude != null) queryParams['longitude'] = longitude.toString();
    if (radius != null) queryParams['radius'] = radius.toString();
    if (featured != null) queryParams['featured'] = featured ? '1' : '0';
    if (sortBy != null) queryParams['sort_by'] = sortBy;

    final uri = Uri.parse(remoteUrl).replace(queryParameters: queryParams);

    var response = await client.get(
      uri,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Get nearby service centers
  Future<dynamic> getNearbyServiceCenters({
    required String token,
    required double latitude,
    required double longitude,
    double radius = 20,
  }) async {
    var remoteUrl = '$apiUrl/service-centers/nearby';

    Map<String, String> queryParams = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'radius': radius.toString(),
    };

    final uri = Uri.parse(remoteUrl).replace(queryParameters: queryParams);

    var response = await client.get(
      uri,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Get single service center details
  Future<dynamic> getServiceCenter({
    required String token,
    required int id,
  }) async {
    var remoteUrl = '$apiUrl/service-centers/$id';
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

  // Rate a service center
  Future<dynamic> rateServiceCenter({
    required String token,
    required int serviceCenterId,
    required int rating,
    String? review,
  }) async {
    var remoteUrl = '$apiUrl/service-centers/$serviceCenterId/rate';

    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'rating': rating,
        'review': review,
      }),
    );

    print('=== Rating Submission Debug ===');
    print('URL: $remoteUrl');
    print('Rating: $rating');
    print('Review: $review');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('================================');

    return response;
  }

  // Get user's rating for a service center
  Future<dynamic> getUserRating({
    required String token,
    required int serviceCenterId,
  }) async {
    var remoteUrl = '$apiUrl/service-centers/$serviceCenterId/my-rating';
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

  // Delete user's rating
  Future<dynamic> deleteRating({
    required String token,
    required int serviceCenterId,
  }) async {
    var remoteUrl = '$apiUrl/service-centers/$serviceCenterId/my-rating';
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
