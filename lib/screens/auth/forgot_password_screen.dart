import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';
import 'package:smart_kishan/widgets/or_divider.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SafeArea(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenWidth(15)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: double.infinity,
                                          height:
                                              getProportionateScreenWidth(80)),
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
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                              onTap: () {
                                Get.back();
                              },
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
                              vertical: getProportionateScreenWidth(0),
                              horizontal: getProportionateScreenWidth(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.forgotPwdTitle,
                                style: TextStyle(
                                  fontFamily: 'Sans',
                                  fontSize: getProportionateScreenWidth(22),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                AppLocalizations.of(context)!.forgotPwdDesc,
                                style: TextStyle(
                                    color: kCardDescColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: getProportionateScreenWidth(14)),
                              ),
                              SizedBox(
                                height: getProportionateScreenWidth(30),
                              ),
                              InputTextField(
                                title: AppLocalizations.of(context)!.inputPhone,
                                textEditingController: phoneNumberController,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.phone,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15,
                                      bottom: defaultPadding,
                                      left: defaultPadding,
                                      right: 10),
                                  child: RichText(
                                    text: const TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '(+977) |',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: kCardTitleColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .inputPhoneMsg;
                                  }
                                  if (value.length < 10 || value.length > 10) {
                                    return AppLocalizations.of(context)!
                                        .enterValidPhone;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: getProportionateScreenWidth(40),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (otpController.otpLoading.value ||
                                          otpController.otpSending.value)
                                        return;
                                      if (_formKey.currentState!.validate()) {
                                        otpController.requestOtp(
                                            phone: phoneNumberController.text,
                                            route:
                                                AppRoute.forgotPasswordScreen);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      minimumSize: Size(
                                          getProportionateScreenWidth(200),
                                          getProportionateScreenWidth(50)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    child: Obx(() {
                                      if (otpController.otpLoading.value ||
                                          otpController.otpSending.value) {
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
                                        return Text(
                                            AppLocalizations.of(context)!
                                                .requestOTP);
                                      }
                                    })),
                              ),
                              SizedBox(
                                height: getProportionateScreenWidth(30),
                              ),
                              const OrDivider(),
                              SizedBox(
                                height: getProportionateScreenWidth(30),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!.noForget,
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(14)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(AppRoute.signInScreen);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.signInNav,
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenWidth(14),
                                          fontWeight: FontWeight.w600,
                                          color: kSecondaryColor),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]))));
  }
}
