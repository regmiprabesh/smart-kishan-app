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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.

  Get.put(AuthController());

  initializeDateFormatting('ne_NP', null).then((_) => runApp(MyApp()));
  // runApp(MyApp());
  // runApp(PhoneRegisterScreen());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      useInheritedMediaQuery: true,
      getPages: AppPage.list,
      initialRoute: AppRoute.splashScreen,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          dialogTheme: const DialogThemeData(
            surfaceTintColor: Colors.transparent,
          ),
          canvasColor: kCanvasColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor, // Set the background color
            foregroundColor: Colors.white, // Set the text color
          )),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: kPrimaryColor, // Set the FAB background color
            foregroundColor: Colors.white, // Set the icon/text color
          ),
          // fontFamily: 'Poppins',
          primaryColor: kPrimaryColor,
          appBarTheme: const AppBarTheme(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white, // Set text/icon color for AppBar
              surfaceTintColor: Colors.white,
              titleTextStyle:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          primaryColorDark: kSecondaryColor),
      onInit: () async {
        Get.put<AuthController>(
          AuthController(),
          permanent: true,
        );
        Get.put<OTPController>(
          OTPController(),
          permanent: true,
        );
        // Get.put<SyncController>(
        //   SyncController(),
        //   permanent: true,
        // );
      },
    );
  }
}
