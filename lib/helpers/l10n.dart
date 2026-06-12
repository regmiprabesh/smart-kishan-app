import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

AppLocalizations get l10n => AppLocalizations.of(Get.context!)!;

String get localeCode => Localizations.localeOf(Get.context!).languageCode;

String localizedNumber(Object value) {
  final str = value.toString();
  final code = Localizations.localeOf(Get.context!).languageCode;
  return code == 'ne' ? convertToNepaliNumber(str) : str;
}
