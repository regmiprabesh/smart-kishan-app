import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

AppLocalizations get l10n => AppLocalizations.of(Get.context!)!;

String localizedNumber(int value) {
  final code = Localizations.localeOf(Get.context!).languageCode;
  return code == 'ne'
      ? convertToNepaliNumber(value.toString())
      : value.toString();
}
