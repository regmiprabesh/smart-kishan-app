import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/languages/language.dart';
import 'package:smart_kishan/main.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  Locale? selectedLanguageCode;

  @override
  void initState() {
    getDefaultLanguage();
    // TODO: implement initState
    super.initState();
  }

  void getDefaultLanguage() async {
    Locale? locale = await getLocale();
    setState(() {
      selectedLanguageCode = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Form(
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
                        AppLocalizations.of(context)!.language,
                        style: TextStyle(
                          fontFamily: 'Sans',
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.selectLanguageMsg,
                        style: TextStyle(
                            color: kCardDescColor,
                            fontSize: getProportionateScreenWidth(14)),
                      ),
                      SizedBox(
                        height: getProportionateScreenWidth(30),
                      ),
                      ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: Language.languageList().length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onTap: () async {
                                setState(() {
                                  selectedLanguageCode = Locale(
                                      Language.languageList()[index]
                                          .languageCode);
                                });
                                MyApp.setLocale(Locale(
                                    Language.languageList()[index]
                                        .languageCode));
                              },
                              child: Container(
                                height: getProportionateScreenWidth(50),
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedLanguageCode.toString() ==
                                              Language.languageList()[index]
                                                  .languageCode
                                          ? Colors.grey
                                          : kPrimaryGrey,
                                    ),
                                    color: selectedLanguageCode.toString() ==
                                            Language.languageList()[index]
                                                .languageCode
                                        ? kPrimaryLightColor.withOpacity(0.5)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        Language.languageList()[index]
                                            .languageCode
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      Language.languageList()[index].name,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    selectedLanguageCode.toString() ==
                                            Language.languageList()[index]
                                                .languageCode
                                        ? const Icon(
                                            color: kPrimaryColor,
                                            Icons.check_circle_rounded,
                                            size: 30,
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            );
                          }),
                      SizedBox(
                        height: getProportionateScreenWidth(20),
                      ),
                      Align(
                        child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(AppRoute.introductionScreen);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              minimumSize: Size(double.infinity,
                                  getProportionateScreenWidth(50)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.nextPage,
                              style: const TextStyle(color: Colors.white),
                            )),
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
