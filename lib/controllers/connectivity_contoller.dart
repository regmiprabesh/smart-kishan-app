import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class ConnectivityController extends GetxController {
  var isConnected = false.obs;
  var isServerReachable = false.obs;

  final String serverUrl = '$apiUrl/health';

  Future<bool> checkConnectivity() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        isConnected.value = false;
        isServerReachable.value = false;
        return false;
      }

      isConnected.value = true;

      // Check if backend server is reachable
      try {
        final response = await http
            .get(
              Uri.parse(serverUrl),
            )
            .timeout(Duration(seconds: 5));

        isServerReachable.value = response.statusCode == 200;
        return isServerReachable.value;
      } catch (e) {
        isServerReachable.value = false;
        return false;
      }
    } catch (e) {
      isConnected.value = false;
      isServerReachable.value = false;
      return false;
    }
  }
}
