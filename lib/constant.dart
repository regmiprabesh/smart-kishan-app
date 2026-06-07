import 'package:flutter/material.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

String appVersion = '1.0';
// String imgUrl = 'https://test.prabeshregmi.com.np/storage/';
// String apiUrl = 'https://test.prabeshregmi.com.np/api';
String apiUrl = 'http://192.168.1.45:8000/api';
String imgUrl = 'http://192.168.1.45:8000/storage/';

const double defaultPadding = 16.0;

const narcRefreshToken =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcxODAyODA5NSwiaWF0IjoxNzE3OTQxNjk1LCJqdGkiOiJjNzliNTRiNjliMDI0OTFjYjdlMTBmNDBhZjk1MmYzNiIsInVzZXJfaWQiOjg0fQ.Vs8OIpdhwyCriwgoMjHRzd4WrOkqMTCN5iQqbSRrFTw";
const narcAccessToken =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE4MDAzNDg3LCJpYXQiOjE3MTgwMDMxODcsImp0aSI6IjA1NmIyYmZmYTBlMDQwODBiNTM5Nzk5ZDM2NDFlZTgzIiwidXNlcl9pZCI6ODR9.TqtVFSGWDZQiHZ3ZqVkMX1XQBKUgl0YJlL9bG31QvWo";
const kPrimaryColor = Color(0xFF34A853);
const kPrimaryLightColor = Color.fromARGB(255, 158, 225, 176);
const kSecondaryColor = Color(0xFFFE724C);
const kBackgroundColor = Color(0xFFF8F9FA);
const kTextColor = Color(0xFF333333);
const kErrorColor = Color(0xFFEB1D1D);
const kSuccessColor = Color(0xFF23b502);

const kCardTitleColor = Color(0xFF292D32);
const kCardDescColor = Color(0xFF898A8D);

const kCanvasColor = Color(0xFFFFFFFF);

const kBaseColor = Color(0xFFE0E0E0);
const kHightlightColor = Color(0xFFFFFFFF);
const kPrimaryGrey = Color(0xFFE0E0E0);

String convertToNepaliNumber(String input) {
  const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const nepaliNumbers = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];

  for (int i = 0; i < englishNumbers.length; i++) {
    input = input.replaceAll(englishNumbers[i], nepaliNumbers[i]);
  }
  return input;
}

String convertToLocalizedNumber(String input, BuildContext context) {
  // Get the current locale
  final locale = AppLocalizations.of(context)!.localeName;

  // Define number mapping for Nepali
  const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const nepaliNumbers = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];

  // If the locale is Nepali, convert numbers to Nepali
  if (locale == 'ne') {
    for (int i = 0; i < englishNumbers.length; i++) {
      input = input.replaceAll(englishNumbers[i], nepaliNumbers[i]);
    }
  }

  // You can add additional conditions here for other locales if needed.
  // For now, if the locale is not Nepali, we'll keep the number as it is (English or others).

  return input;
}

String getLocalizedMonth(String englishMonth, BuildContext context) {
  final localizations = AppLocalizations.of(context)!;

  switch (englishMonth.toLowerCase()) {
    case "jan":
      return localizations.jan;
    case "feb":
      return localizations.feb;
    case "mar":
      return localizations.mar;
    case "apr":
      return localizations.apr;
    case "may":
      return localizations.may;
    case "jun":
      return localizations.jun;
    case "jul":
      return localizations.jul;
    case "aug":
      return localizations.aug;
    case "sep":
      return localizations.sep;
    case "oct":
      return localizations.oct;
    case "nov":
      return localizations.nov;
    case "dec":
      return localizations.dec;
    default:
      return englishMonth; // Fallback for unmapped months
  }
}
