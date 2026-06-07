import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_kishan/constant.dart';

class RemoteSubsidyRequestService {
  var client = http.Client();

  // Get user's subsidy requests
  Future<dynamic> getMyRequests({required String token}) async {
    var remoteUrl = '$apiUrl/subsidy-requests/my-requests';
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

  // Submit new subsidy request
  Future<dynamic> submitRequest({
    required String token,
    required String titleEn,
    String? titleNe,
    required String descriptionEn,
    String? descriptionNe,
    required String subsidyType,
    String? targetCropEn,
    String? targetCropNe,
    required String justificationEn,
    String? justificationNe,
    required String requestedToLevel,
  }) async {
    var remoteUrl = '$apiUrl/subsidy-requests';

    var requestBody = {
      'title_en': titleEn,
      'description_en': descriptionEn,
      'subsidy_type': subsidyType,
      'justification_en': justificationEn,
      'requested_to_level': requestedToLevel,
    };

    // Add optional fields
    if (titleNe != null && titleNe.isNotEmpty) {
      requestBody['title_ne'] = titleNe;
    }
    if (descriptionNe != null && descriptionNe.isNotEmpty) {
      requestBody['description_ne'] = descriptionNe;
    }
    if (targetCropEn != null && targetCropEn.isNotEmpty) {
      requestBody['target_crop_or_sector_en'] = targetCropEn;
    }
    if (targetCropNe != null && targetCropNe.isNotEmpty) {
      requestBody['target_crop_or_sector_ne'] = targetCropNe;
    }
    if (justificationNe != null && justificationNe.isNotEmpty) {
      requestBody['justification_ne'] = justificationNe;
    }

    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    print('=== Subsidy Request Submission Debug ===');
    print('URL: $remoteUrl');
    print('Request body: ${jsonEncode(requestBody)}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('=========================================');

    return response;
  }

  // Get single request details
  Future<dynamic> getRequestDetails({
    required String token,
    required int requestId,
  }) async {
    var remoteUrl = '$apiUrl/subsidy-requests/$requestId';
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

  // Cancel/Delete request
  Future<dynamic> cancelRequest({
    required String token,
    required int requestId,
  }) async {
    var remoteUrl = '$apiUrl/subsidy-requests/$requestId/cancel';
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
