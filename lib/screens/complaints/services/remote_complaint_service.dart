import 'dart:io';
import 'dart:convert';
import 'package:smart_kishan/constant.dart';
import 'package:path/path.dart' as path;
import 'package:smart_kishan/helpers/app_http_client.dart';
import 'package:http/http.dart' as http;

class RemoteComplaintService {
  var client = AppHttpClient();

  // Get user's complaints
  Future<dynamic> getMyComplaints() async {
    var remoteUrl = '$apiUrl/complaints/my-complaints';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  // Submit new complaint with file upload
  Future<dynamic> submitComplaint({
    required String title,
    required String description,
    required String category,
    required String priority,
    required String submittedToLevel,
    String? specificLocation,
    double? latitude,
    double? longitude,
    File? attachmentFile,
  }) async {
    var remoteUrl = '$apiUrl/complaints';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(remoteUrl));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      // Add text fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['category'] = category;
      request.fields['priority'] = priority;
      request.fields['submitted_to_level'] = submittedToLevel;

      // Add optional fields
      if (specificLocation != null && specificLocation.isNotEmpty) {
        request.fields['specific_location'] = specificLocation;
      }
      if (latitude != null) {
        request.fields['latitude'] = latitude.toString();
      }
      if (longitude != null) {
        request.fields['longitude'] = longitude.toString();
      }

      // Add file if provided
      if (attachmentFile != null) {
        String fileName = path.basename(attachmentFile.path);
        var stream = http.ByteStream(attachmentFile.openRead());
        var length = await attachmentFile.length();

        var multipartFile = http.MultipartFile(
          'attachment',
          stream,
          length,
          filename: fileName,
        );

        request.files.add(multipartFile);
      }

      print('=== Complaint Submission Debug ===');
      print('URL: $remoteUrl');
      print('Fields: ${request.fields}');
      print('Files: ${request.files.map((f) => f.filename)}');

      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('====================================');

      return response;
    } catch (e) {
      print('Error in submitComplaint: $e');
      rethrow;
    }
  }

  // Get single complaint details
  Future<dynamic> getComplaintDetails({
    required int complaintId,
  }) async {
    var remoteUrl = '$apiUrl/complaints/$complaintId';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  // Add comment to complaint
  Future<dynamic> addComment({
    required int complaintId,
    required String comment,
  }) async {
    var remoteUrl = '$apiUrl/complaints/$complaintId/comments';
    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'comment': comment,
      }),
    );
    return response;
  }

  // Cancel/Delete complaint
  Future<dynamic> cancelComplaint({
    required int complaintId,
  }) async {
    var remoteUrl = '$apiUrl/complaints/$complaintId';
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
