import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SafeArea(
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
                          'नयाँ पासवर्ड सेट गर्नुहोस्',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(22),
                            fontWeight: FontWeight.w700,
                            color: kSecondaryColor,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenWidth(10)),
                        Text(
                          'कृपया तपाईंको खाताको लागि नयाँ पासवर्ड प्रविष्ट गर्नुहोस् ।',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            color: kCardDescColor,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenWidth(40)),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'नयाँ पासवर्ड',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(
                                  () => obscurePassword = !obscurePassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'पासवर्ड प्रविष्ट गर्नुहोस्';
                            }
                            if (value.length < 6) {
                              return 'पासवर्ड कम्तिमा ६ अक्षरको हुनुपर्छ';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: getProportionateScreenWidth(20)),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: obscureConfirm,
                          decoration: InputDecoration(
                            labelText: 'पासवर्ड पुष्टि गर्नुहोस्',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(obscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(
                                  () => obscureConfirm = !obscureConfirm),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'पासवर्ड पुष्टि गर्नुहोस्';
                            }
                            if (value != passwordController.text) {
                              return 'पासवर्ड मिलेन';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: getProportionateScreenWidth(40)),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              if (authController.isResetLoading.value) return;
                              if (_formKey.currentState!.validate()) {
                                authController.resetPassword(
                                  password: passwordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                );
                              }
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
                              if (authController.isResetLoading.value) {
                                return const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                              return const Text('पासवर्ड परिवर्तन गर्नुहोस्');
                            }),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenWidth(30)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
