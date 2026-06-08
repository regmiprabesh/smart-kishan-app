import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'app_session.dart';

class AppHttpClient extends http.BaseClient {
  final http.Client _inner;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AppHttpClient([http.Client? inner]) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!request.headers.containsKey('Authorization')) {
      final token =
          await _storage.read(key: 'jwt'); // same key LocalAuthService writes
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      final response =
          await _inner.send(request).timeout(const Duration(seconds: 20));
      if (response.statusCode == 401 &&
          request.headers.containsKey('Authorization')) {
        handleSessionExpired(); // expired/invalid token
      }
      return response;
    } on SocketException {
      handleOffline();
      rethrow;
    } on TimeoutException {
      handleOffline();
      rethrow;
    } on http.ClientException {
      handleOffline();
      rethrow;
    } catch (e) {
      // For any other exceptions, we can choose to handle them or rethrow.
      // Here, we'll just rethrow after logging.
      handleOffline();
      rethrow;
    }
  }
}
