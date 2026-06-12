import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextThemeHelper {
  // Private constructor — no instantiation needed
  TextThemeHelper._();

  /// Returns the correct TextTheme based on current locale
  static TextTheme getTextTheme(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return _englishTextTheme();
      case 'ne':
        return _nepaliTextTheme();
      default:
        return _nepaliTextTheme(); // safe fallback
    }
  }

  // ── English (Nunito) ──────────────────────────────
  static TextTheme _englishTextTheme() {
    return GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge:
          GoogleFonts.nunito(fontSize: 52, fontWeight: FontWeight.w700),
      displayMedium:
          GoogleFonts.nunito(fontSize: 42, fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium:
          GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600),
      labelSmall: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w400),
    );
  }

  // ── Nepali (Noto Sans Devanagari) ─────────────────
  static TextTheme _nepaliTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: 57,
          fontWeight: FontWeight.w700),
      displayMedium: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: 45,
          fontWeight: FontWeight.w700),
      titleLarge: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: 22,
          fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: 20,
          fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: 15,
          fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: 16,
          fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: 15,
          fontWeight: FontWeight.w600),
      labelSmall: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: 12,
          fontWeight: FontWeight.w400),
    );
  }
}
