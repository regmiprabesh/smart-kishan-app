import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'app_session.dart';

class AppHttpClient extends http.BaseClient {
  final http.Client _inner;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Short timeout for JSON calls, longer one for file uploads.
  final Duration _defaultTimeout;
  final Duration _uploadTimeout;

  AppHttpClient({
    http.Client? inner,
    Duration defaultTimeout = const Duration(seconds: 20),
    Duration uploadTimeout = const Duration(seconds: 90),
  })  : _inner = inner ?? http.Client(),
        _defaultTimeout = defaultTimeout,
        _uploadTimeout = uploadTimeout;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Attach the JWT automatically, unless the caller already set one.
    if (!request.headers.containsKey('Authorization')) {
      final token =
          await _storage.read(key: 'jwt'); // same key LocalAuthService writes
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }

    // Multipart uploads get the longer timeout; everything else stays snappy.
    final timeout =
        request is http.MultipartRequest ? _uploadTimeout : _defaultTimeout;

    try {
      final response = await _inner.send(request).timeout(timeout);
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
      handleOffline();
      rethrow;
    }
  }
}
