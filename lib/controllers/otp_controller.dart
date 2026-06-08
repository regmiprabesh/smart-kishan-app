import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/auth/services/remote_auth_services.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/helpers/app_snackbar.dart';

class OTPController extends GetxController {
  static OTPController instance = Get.find();

  RxBool otpLoading = false.obs;
  RxBool otpResending = false.obs;
  RxBool otpVerifying = false.obs;
  RxBool otpSending = false.obs;

  Timer? resendTimer;
  RxInt start = 60.obs;
  RxString phoneNumber = ''.obs; // +977XXXXXXXXXX, for display
  RxString rawPhone = ''.obs; // 10-digit, sent to backend

  RxString verificationToken = ''.obs;

  String _otpPurpose = 'register';

  void startResendTimer() {
    resendTimer?.cancel();
    start(60);
    otpResending(true); // disables button + shows countdown
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start.value <= 1) {
        timer.cancel();
        start(0);
        otpResending(false); // re-enables the resend button
      } else {
        start(start.value - 1);
      }
    });
  }

  void requestOtp({required String phone, String? route}) async {
    if (otpLoading.value) return;
    final bool isForgotPassword = route == AppRoute.forgotPasswordScreen;
    _otpPurpose = isForgotPassword ? 'reset' : 'register'; // ← add
    try {
      otpLoading(true);
      otpSending(true);
      var otpRes = await RemoteAuthService().sendOtp(
        phone: phone,
        purpose: isForgotPassword ? 'reset' : 'register',
      );
      otpSending(false);

      if (otpRes.statusCode == 200) {
        phoneNumber('+977$phone');
        rawPhone(phone);
        startResendTimer();
        showSuccessSnackbar(l10n.otpSent);
        Get.toNamed(AppRoute.otpScreen, arguments: route);
      } else if (otpRes.statusCode == 409) {
        showErrorSnackbar(l10n.phoneAlreadyRegistered);
      } else if (otpRes.statusCode == 404) {
        showErrorSnackbar(l10n.phoneNotRegistered);
      } else if (otpRes.statusCode == 429) {
        var body = json.decode(otpRes.body);
        int seconds = body['retry_after'] ?? 60;
        showErrorSnackbar(l10n.otpThrottled(localizedNumber(seconds)));
      } else {
        var body = json.decode(otpRes.body);
        showErrorSnackbar(l10n.otpSendFailed);
      }
    } catch (e) {
      showErrorSnackbar(l10n.genericError);
    } finally {
      otpLoading(false);
      otpSending(false);
    }
  }

  void resendOtp() async {
    if (otpResending.value) return;
    startResendTimer();
    try {
      var otpRes = await RemoteAuthService().sendOtp(
        phone: rawPhone.value,
        purpose: _otpPurpose,
      );
      if (otpRes.statusCode == 200) {
        showSuccessSnackbar(l10n.otpResent);
      } else {
        resendTimer?.cancel();
        otpResending(false);
        var body = json.decode(otpRes.body);
        showErrorSnackbar(l10n.otpSendFailed);
      }
    } catch (e) {
      resendTimer?.cancel();
      otpResending(false);
      showErrorSnackbar(l10n.genericError);
    }
  }

  void verifyOtp({required String otpCode, String? route}) async {
    otpVerifying(true);
    final bool isForgotPassword = route == AppRoute.forgotPasswordScreen;
    try {
      var res = await RemoteAuthService().verifyOtp(
        phone: rawPhone.value,
        otp: otpCode,
        purpose: isForgotPassword ? 'reset' : 'register',
      );
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        verificationToken(body['verification_token'] ?? ''); // both flows
        if (isForgotPassword) {
          Get.offNamed(AppRoute.resetPasswordScreen);
        } else {
          Get.toNamed(AppRoute.signUpScreen);
        }
      } else {
        showErrorSnackbar(l10n.otpInvalid);
      }
    } catch (e) {
      showErrorSnackbar(l10n.genericError);
    } finally {
      otpVerifying(false);
    }
  }
}
