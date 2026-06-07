import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/size_config.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController pinPutController = TextEditingController();
  FocusNode pinPutFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String? arguments;
  @override
  void dispose() {
    pinPutController.dispose();
    pinPutFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      arguments = Get.arguments;
    }
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: kPrimaryColor),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(
                children: [
                  SafeArea(
                      bottom: false,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  height: getProportionateScreenWidth(80)),
                            ],
                          ))),
                  Positioned(
                    left: -40,
                    child: SizedBox(
                      height: 150,
                      width: 250,
                      child: Stack(children: [
                        Positioned(
                          left: 50,
                          top: -70,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: kSecondaryColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -20,
                          top: 0,
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(100)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      )),
                                ]),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Positioned(
                    right: -80,
                    top: -70,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 15,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateScreenWidth(50),
              ),
              SafeArea(
                top: false,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(15),
                      horizontal: getProportionateScreenWidth(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'प्रमाणिकरण कोड',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'कृपया ${otpController.phoneNumber} मा पठाइएको 6 अंकको प्रमाणीकरण कोड टाइप गर्नुहोस्',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: kCardDescColor,
                            fontWeight: FontWeight.w500,
                            fontSize: getProportionateScreenWidth(14)),
                      ),
                      SizedBox(
                        height: getProportionateScreenWidth(30),
                      ),
                      Pinput(
                        focusNode: pinPutFocusNode,
                        controller: pinPutController,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          textStyle: const TextStyle(
                              color: kSecondaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kPrimaryColor),
                          ),
                        ),
                        length: 6,
                        pinAnimationType: PinAnimationType.fade,
                      ),
                      SizedBox(
                        height: getProportionateScreenWidth(40),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              if (otpController.otpVerifying.value ||
                                  pinPutController.text.length < 6) return;
                              otpController.verifyOtp(
                                  otpCode: pinPutController.text,
                                  route: arguments);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              minimumSize: Size(
                                  getProportionateScreenWidth(200),
                                  getProportionateScreenWidth(50)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Obx(() {
                              if (otpController.otpVerifying.value) {
                                return const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                );
                              } else {
                                return const Text('प्रमाणित गर्नुहोस्');
                              }
                            }),
                          )),
                      SizedBox(
                        height: getProportionateScreenWidth(40),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "OTP प्राप्त भएन ?",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(13),
                                color: Colors.grey.shade500),
                          ),
                          TextButton(
                            onPressed: () {
                              if (otpController.otpResending.value) return;
                              otpController.resendOtp();
                            },
                            child: Obx(() {
                              if (otpController.otpResending.value) {
                                return Text(
                                  'पुन: ${convertToNepaliNumber(otpController.start.value.toString())} सेकेन्डमा प्रयास गर्नुहोस्',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize:
                                          getProportionateScreenWidth(14)),
                                );
                              } else {
                                return Text(
                                  'पुन: पठाउनुहोस्',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize:
                                          getProportionateScreenWidth(14)),
                                );
                              }
                            }),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ])));
  }
}
