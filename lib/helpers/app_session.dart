import 'package:smart_kishan/controllers/app_controller.dart';
import 'l10n.dart';
import 'app_snackbar.dart';

bool _handlingExpiry = false;
Future<void> handleSessionExpired() async {
  if (_handlingExpiry) return;
  _handlingExpiry = true;
  try {
    await authController.forceExpiredLogout();
  } finally {
    await Future.delayed(const Duration(seconds: 2));
    _handlingExpiry = false;
  }
}

DateTime? _lastOffline;
void handleOffline() {
  final now = DateTime.now();
  if (_lastOffline != null && now.difference(_lastOffline!).inSeconds < 3)
    return;
  _lastOffline = now;
  showErrorSnackbar(l10n.noInternet);
}
