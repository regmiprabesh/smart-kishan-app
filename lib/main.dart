import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/auth_controller.dart';
import 'package:smart_kishan/controllers/otp_controller.dart';
import 'package:smart_kishan/firebase_options.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/routes/app_pages.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/helpers/text_theme_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  Get.put(AuthController());

  await initializeDateFormatting('ne_NP', null);
  await initializeDateFormatting('en', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Call this from anywhere in the app to switch locale.
  static void setLocale(Locale locale) {
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale>(
      future: getLocale(),
      initialData: const Locale('ne', 'NP'),
      builder: (context, snapshot) {
        final locale = snapshot.data ?? const Locale('ne', 'NP');
        return GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          useInheritedMediaQuery: true,
          getPages: AppPage.list,
          initialRoute: AppRoute.splashScreen,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
            textTheme: TextThemeHelper.getTextTheme(locale),
            scaffoldBackgroundColor: Colors.white,
            dialogTheme: const DialogThemeData(
              surfaceTintColor: Colors.transparent,
            ),
            canvasColor: kCanvasColor,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
            ),
            primaryColor: kPrimaryColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              titleTextStyle:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            primaryColorDark: kSecondaryColor,
          ),
          onInit: () async {
            Get.put<AuthController>(
              AuthController(),
              permanent: true,
            );
            Get.put<OTPController>(
              OTPController(),
              permanent: true,
            );
          },
        );
      },
    );
  }
}
