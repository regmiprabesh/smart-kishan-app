// lib/screens/chatbot/services/remote_chatbot_service.dart
//
// Mirrors RemoteActivityService: same http.Client, same Bearer-token auth.
// Now also sends recent conversation history so follow-up questions
// ("what about cauliflower?") are understood in context.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteChatbotService {
  var client = http.Client();

  Future<dynamic> sendMessage({
    required String token,
    required String message,
    String? lang, // 'ne' | 'en' | null
    List<Map<String, String>> history = const [],
  }) async {
    var remoteUrl = '$apiUrl/chatbot';
    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'message': message,
        'lang': lang,
        'history': history,
      }),
    );
    return response;
  }
}
