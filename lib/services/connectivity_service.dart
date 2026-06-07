import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:http/http.dart' as http;

class ConnectivityService extends GetxController {
  static ConnectivityService get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  final RxBool isCheckingConnection = false.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    checkInitialConnection();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    await _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none)) {
      isConnected.value = false;
    } else {
      // Check if we have actual working connection
      isConnected.value = await hasInternetConnection();
    }
  }

  /// Check if device has actual internet connection
  Future<bool> hasInternetConnection() async {
    try {
      isCheckingConnection.value = true;

      // Just check basic internet connectivity
      // Don't check backend here to avoid loops
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 3));

        if (result.isEmpty || result[0].rawAddress.isEmpty) {
          return false;
        }
        return true;
      } catch (e) {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isCheckingConnection.value = false;
    }
  }

  /// Check if backend server is actually responding (not just DNS resolvable)
  Future<bool> canReachBackend(String baseUrl) async {
    try {
      // Make an actual HTTP request to check if server is responding
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify'), // Use a lightweight endpoint
        headers: {"Content-Type": "application/json"},
      ).timeout(
        const Duration(seconds: 5),
      );

      // Any response (even 401) means server is up
      return true;
    } on SocketException {
      print('Backend server is down - SocketException');
      return false;
    } on TimeoutException {
      print('Backend server timeout');
      return false;
    } on http.ClientException {
      print('Backend server unreachable - ClientException');
      return false;
    } catch (e) {
      print('Backend check error: $e');
      return false;
    }
  }

  /// Retry connection check
  Future<bool> retryConnection() async {
    await Future.delayed(const Duration(seconds: 1));
    return await hasInternetConnection();
  }
}
