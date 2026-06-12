import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/helpers/app_http_client.dart';

class RemoteSurveyService {
  var client = AppHttpClient();

  // Get all available surveys for farmer based on their location
  Future<dynamic> getSurveys() async {
    var remoteUrl = '$apiUrl/farmer/surveys';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  // Get survey details with questions
  Future<dynamic> getSurveyDetails({required int surveyId}) async {
    var remoteUrl = '$apiUrl/farmer/surveys/$surveyId';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  // Submit survey response with file upload support
  Future<dynamic> submitResponse({
    required int surveyId,
    required Map<int, dynamic> answers,
    required DateTime startedAt,
    required DateTime completedAt,
  }) async {
    var remoteUrl = '$apiUrl/farmer/surveys/$surveyId/respond';

    // Create multipart request for file uploads
    var request = http.MultipartRequest('POST', Uri.parse(remoteUrl));

    // Only Accept — Authorization is injected by AppHttpClient.send()
    request.headers.addAll({
      'Accept': 'application/json',
    });

    // Format answers for backend
    List<Map<String, dynamic>> formattedAnswers = [];
    Map<int, String> fileQuestionIds = {};

    answers.forEach((questionId, answer) {
      Map<String, dynamic> answerData = {
        'survey_question_id': questionId,
      };

      // Handle different answer types
      if (answer is String && !answer.startsWith('/')) {
        // Regular text answer
        answerData['text_answer'] = answer;
      } else if (answer is String && answer.startsWith('/')) {
        // This is a file path
        fileQuestionIds[questionId] = answer;
        // Don't add to formattedAnswers yet, will be handled by backend
      } else if (answer is int) {
        answerData['number_answer'] = answer;
      } else if (answer is double) {
        answerData['decimal_answer'] = answer;
      } else if (answer is bool) {
        answerData['boolean_answer'] = answer;
      } else if (answer is List) {
        answerData['choice_answer'] = answer;
      } else if (answer is Map && answer.containsKey('lat')) {
        answerData['latitude'] = answer['lat'];
        answerData['longitude'] = answer['lng'];
      } else if (answer is DateTime) {
        answerData['date_answer'] = answer.toIso8601String();
      }

      formattedAnswers.add(answerData);
    });

    // Add answers as JSON string field
    request.fields['answers'] = jsonEncode(formattedAnswers);
    request.fields['started_at'] = startedAt.toIso8601String();
    request.fields['completed_at'] = completedAt.toIso8601String();

    // Add file uploads
    for (var entry in fileQuestionIds.entries) {
      File file = File(entry.value);
      String fileName = file.path.split('/').last;

      var multipartFile = await http.MultipartFile.fromPath(
        'files[file_${entry.key}]', // Format: files[file_questionId]
        file.path,
        filename: fileName,
      );

      request.files.add(multipartFile);
    }

    print('=== Survey Submission Debug ===');
    print('URL: $remoteUrl');
    print('Started at: ${startedAt.toIso8601String()}');
    print('Completed at: ${completedAt.toIso8601String()}');
    print('Answers count: ${formattedAnswers.length}');
    print('Files count: ${request.files.length}');
    for (var file in request.files) {
      print('  - ${file.field}: ${file.filename}');
    }
    print('================================');

    try {
      // Route through AppHttpClient so the token is injected
      // and 401 / offline handling applies.
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response;
    } catch (e) {
      print('Error submitting survey: $e');
      return http.Response(
        jsonEncode({'error': 'Failed to submit survey: $e'}),
        500,
      );
    }
  }
}
