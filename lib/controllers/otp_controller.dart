import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/auth/services/remote_auth_services.dart';

class OTPController extends GetxController {
  static OTPController instance = Get.find();

  RxBool otpLoading = false.obs;
  RxBool otpResending = false.obs;
  RxBool otpVerifying = false.obs;
  RxBool otpSending = false.obs;

  late Timer resendTimer;
  RxInt start = 60.obs;
  RxString phoneNumber = ''.obs;
  RxString otpVerificationId = ''.obs;

  void requestOtp({required String phone, String? route}) async {
    try {
      otpLoading(true);
      var result =
          await RemoteAuthService().checkRegistration(phone: '+977$phone');
          print(result.body);
      if (result.statusCode == 200) {
        otpSending(true);
        await firebaseAuth.FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+977$phone',
          verificationCompleted:
              (firebaseAuth.PhoneAuthCredential credential) {},
          verificationFailed: (firebaseAuth.FirebaseAuthException e) {
            otpSending(false);
            if (e.code == 'invalid-phone-number') {
              ScaffoldMessenger.of(Get.overlayContext!)
                  .showSnackBar(const SnackBar(
                      backgroundColor: kErrorColor,
                      content: Text(
                        'कृपया आफ्नो सही फोन नम्बर प्रविष्ट गर्नुहोस्!',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )));
            }
            if (e.code == 'invalid-verification-code') {
              ScaffoldMessenger.of(Get.overlayContext!)
                  .showSnackBar(const SnackBar(
                      backgroundColor: kErrorColor,
                      content: Text(
                        ' प्रमाणीकरण कोड गलत भएको छ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )));
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            otpSending(false);
            Future.delayed(const Duration(seconds: 1), () {
              phoneNumber('+977$phone');
              otpVerificationId(verificationId);
              Get.toNamed(AppRoute.otpScreen, arguments: route);
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else if (result.statusCode == 409) {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'यो फोन नम्बर पहिलेनै दर्ता भएको छ ।',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      } else if (result.statusCode == 420) {
        var body = json.decode(result.body);
        {
          ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(SnackBar(
              backgroundColor: kErrorColor,
              content: Text(
                body['message'],
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )));
        }
      }
    } catch (e) {
      otpLoading(false);
    } finally {
      otpLoading(false);
    }
  }

  void resendOtp() async {
    try {
      otpResending(true);
      await firebaseAuth.FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber.value,
        verificationCompleted: (firebaseAuth.PhoneAuthCredential credential) {},
        verificationFailed: (firebaseAuth.FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(Get.overlayContext!)
                .showSnackBar(const SnackBar(
                    backgroundColor: kErrorColor,
                    content: Text(
                      'कृपया आफ्नो सही फोन नम्बर प्रविष्ट गर्नुहोस्!',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    )));
          }
          if (e.code == 'invalid-verification-code') {
            ScaffoldMessenger.of(Get.overlayContext!)
                .showSnackBar(const SnackBar(
                    backgroundColor: kErrorColor,
                    content: Text(
                      'प्रमाणीकरण कोड गलत भएको छ',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    )));
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          otpVerificationId(verificationId);
          ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
              backgroundColor: kSuccessColor,
              content: Text(
                'OTP कोड पुन तपाईंको फोन नम्बरमा पठाइएको छ । !',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (start.value == 0) {
          start(60);
          timer.cancel();
          otpResending(false);
        } else {
          start(start.value - 1);
        }
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  void verifyOtp({required String otpCode, String? route}) async {
    otpVerifying(true);
    try {
      await firebaseAuth.FirebaseAuth.instance
          .signInWithCredential(firebaseAuth.PhoneAuthProvider.credential(
              verificationId: otpVerificationId.value, smsCode: otpCode))
          .then((value) async {
        Get.toNamed(AppRoute.signUpScreen);
      });
    } catch (e) {
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
          backgroundColor: kErrorColor,
          content: Text(
            ' प्रमाणीकरण कोड गलत भएको छ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          )));
    } finally {
      otpVerifying(false);
    }
  }
}
