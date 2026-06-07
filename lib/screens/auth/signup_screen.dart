import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';
import 'package:smart_kishan/widgets/or_divider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return kSecondaryColor;
    }
    return kPrimaryColor;
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
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(defaultPadding)),
                alignment: Alignment.centerLeft,
                child: Text(
                  'खाता सिर्जना गर्नुहोस',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(22),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenWidth(20),
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
                        'पुरा नाम',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InputTextField(
                        title: ' तपाईँको पुरा नाम',
                        textEditingController: nameController,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person_outline),
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'कृपया आफ्नो पूरा नाम प्रविष्ट गर्नुहोस्';
                          }
                          if (value.length < 3) {
                            return 'कृपया आफ्नो मान्य नाम प्रविष्ट गर्नुहोस्';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ई - मेल ठेगाना',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InputTextField(
                        title: 'तपाईँको ई - मेल ठेगाना',
                        textEditingController: emailController,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'पासवर्ड',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InputTextField(
                          title: 'पासवर्ड',
                          textEditingController: passwordController,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          obsecureText: true,
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 20,
                          ),
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "कृपया आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्";
                            } else if (value.length < 8) {
                              return "पासवर्ड कम्तिमा ८ वर्ण लामो हुनुपर्छ";
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'पुन पासवर्ड',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InputTextField(
                          title: 'पासवर्ड सुनिश्चित गर्नुहोस',
                          textEditingController: confirmPasswordController,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          obsecureText: true,
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 20,
                          ),
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "पासवर्ड फिल्ड खाली हुन सक्दैन";
                            } else if (value != passwordController.text) {
                              return "पासवर्ड मेल खाएन";
                            }
                            return null;
                          }),
                      SizedBox(
                        height: getProportionateScreenWidth(40),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            minimumSize: Size(getProportionateScreenWidth(200),
                                getProportionateScreenWidth(50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            _formKey.currentState!.validate();
                            if (authController.isRegisterLoading.value) return;
                            if (_formKey.currentState!.validate()) {
                              authController.signUp(
                                fullName: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                passwordConfirmation:
                                    confirmPasswordController.text,
                              );
                            }
                          },
                          child: Obx(() {
                            if (authController.isRegisterLoading.value) {
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
                              return const Text('खाता सिर्जना गर्नुहोस');
                            }
                          }),
                        ),
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
                            "पहिले नै एउटा खाता छ ? ",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(14)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoute.signInScreen);
                            },
                            child: Text(
                              "लगइन पृष्ठमा फर्कनुहोस्",
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(14),
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
            ],
          ),
        ),
      ),
    );
  }
}
