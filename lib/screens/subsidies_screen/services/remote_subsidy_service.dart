import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/helpers/app_http_client.dart';

class RemoteSubsidyService {
  var client = AppHttpClient();

  // Get all available subsidies for farmer based on their location
  Future<dynamic> getSubsidies() async {
    var remoteUrl = '$apiUrl/farmer/subsidies';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  // Get user's subsidy applications
  Future<dynamic> getMyApplications() async {
    var remoteUrl = '$apiUrl/farmer/subsidy-applications';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

// Apply for a subsidy
  Future<dynamic> applyForSubsidy({
    required int subsidyId,
    required String notes,
    Map<String, File?>? documents,
    Map<String, dynamic>? formData,
  }) async {
    var remoteUrl = '$apiUrl/farmer/subsidies/$subsidyId/apply';

    // Create multipart request
    var request = http.MultipartRequest('POST', Uri.parse(remoteUrl));

    // Add headers (Authorization is added automatically by AppHttpClient)
    request.headers.addAll({
      'Accept': 'application/json',
    });

    // Add application notes
    request.fields['application_notes'] = notes;

    // Add form data
    if (formData != null) {
      formData.forEach((key, value) {
        if (value != null) {
          request.fields['form_data[$key]'] = value.toString();
        }
      });
    }

    // Add documents in the format the backend expects
    if (documents != null && documents.isNotEmpty) {
      int index = 0;
      for (var entry in documents.entries) {
        if (entry.value != null) {
          File file = entry.value!;
          String fileName = file.path.split('/').last;

          // Add the file with indexed field name
          var multipartFile = await http.MultipartFile.fromPath(
            'documents[$index][file]',
            file.path,
            filename: fileName,
          );

          request.files.add(multipartFile);

          // Add the document_type field - this must match the name from backend
          request.fields['documents[$index][document_type]'] = entry.key;

          index++;
        }
      }
    }

    print('=== Subsidy Application Debug ===');
    print('URL: $remoteUrl');
    print('Total files: ${request.files.length}');
    print('Fields: ${request.fields}');
    print('Files:');
    for (var file in request.files) {
      print('  - ${file.field}: ${file.filename}');
    }
    print('================================');

    try {
      // Route through AppHttpClient so the JWT token, 401 handling,
      // and offline/timeout logic are applied
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response;
    } catch (e) {
      print('Error applying for subsidy: $e');
      return http.Response(
        jsonEncode({'error': 'Failed to apply for subsidy: $e'}),
        500,
      );
    }
  }

  // Withdraw application
  Future<dynamic> withdrawApplication({
    required int subsidyId,
  }) async {
    var remoteUrl = '$apiUrl/farmer/subsidies/$subsidyId/withdraw';
    var response = await client.delete(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  // Rate a subsidy
  Future<dynamic> rateSubsidy({
    required int subsidyId,
    required int rating,
    String? review,
  }) async {
    var remoteUrl = '$apiUrl/farmer/subsidies/$subsidyId/rate';

    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
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

  // Get ratings for a subsidy
  Future<dynamic> getSubsidyRatings({
    required int subsidyId,
  }) async {
    var remoteUrl = '$apiUrl/farmer/subsidies/$subsidyId/ratings';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  // Get user's rating for a subsidy
  Future<dynamic> getUserRating({
    required int subsidyId,
  }) async {
    var remoteUrl = '$apiUrl/farmer/subsidies/$subsidyId/my-rating';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  // Delete user's rating
  Future<dynamic> deleteRating({
    required int subsidyId,
  }) async {
    var remoteUrl = '$apiUrl/farmer/subsidies/$subsidyId/my-rating';
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
