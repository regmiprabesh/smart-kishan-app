import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';
import 'package:smart_kishan/widgets/or_divider.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
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
                      bottom: false,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(15)),
                          child: Column(
                            children: [
                              SizedBox(height: getProportionateScreenWidth(30)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenWidth(80),
                                  ),
                                  Text(
                                    'Smart ',
                                    style: TextStyle(
                                        fontFamily: 'Sans',
                                        fontSize:
                                            getProportionateScreenWidth(28),
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor),
                                  ),
                                  Text(
                                    'Kishan',
                                    style: TextStyle(
                                        fontFamily: 'Sans',
                                        fontSize:
                                            getProportionateScreenWidth(28),
                                        fontWeight: FontWeight.bold,
                                        color: kSecondaryColor),
                                  ),
                                ],
                              ),
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
                        AppLocalizations.of(context)!.welcomeBack,
                        style: TextStyle(
                          fontFamily: 'Sans',
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.loginMsg,
                        style: TextStyle(
                            color: kCardDescColor,
                            fontSize: getProportionateScreenWidth(14)),
                      ),
                      SizedBox(
                        height: getProportionateScreenWidth(30),
                      ),
                      Text(
                        AppLocalizations.of(context)!.phoneNumber,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InputTextField(
                        title: AppLocalizations.of(context)!.inputPhone,
                        textEditingController: phoneController,
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
                                      fontSize: 14, color: kCardTitleColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.inputPhoneMsg;
                          }
                          if (value.length < 10 || value.length > 10) {
                            return AppLocalizations.of(context)!
                                .enterValidPhone;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.password,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InputTextField(
                        title: AppLocalizations.of(context)!.inputPassword,
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
                            return AppLocalizations.of(context)!
                                .inputPasswordMsg;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: getProportionateScreenWidth(40),
                      ),
                      Align(
                        child: ElevatedButton(
                          onPressed: () {
                            if (authController.authStatusLoading.value) return;
                            if (_formKey.currentState!.validate()) {
                              authController.signIn(
                                  phone: phoneController.text,
                                  password: passwordController.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            minimumSize: Size(getProportionateScreenWidth(200),
                                getProportionateScreenWidth(50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Obx(
                            () {
                              if (authController.authStatusLoading.value) {
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
                                  AppLocalizations.of(context)!.login,
                                  style: const TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenWidth(30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${AppLocalizations.of(context)!.noAccount} ? ',
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(14)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoute.phoneRegisterScreen);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.registerNow,
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(14),
                                  fontWeight: FontWeight.w600,
                                  color: kSecondaryColor),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenWidth(20),
                      ),
                      const OrDivider(),
                      SizedBox(
                        height: getProportionateScreenWidth(20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!
                                .navigateForgotPwdMsgBefore,
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(14)),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Get.toNamed(AppRoute.forgotPasswordScreen),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .navigateForgotPwdMsgAfter,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kSecondaryColor,
                                  fontSize: getProportionateScreenWidth(15)),
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
