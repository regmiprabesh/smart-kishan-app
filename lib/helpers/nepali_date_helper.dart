class NepaliDateHelper {
  // Nepali numerals mapping
  static const Map<String, String> nepaliNumerals = {
    '0': '०',
    '1': '१',
    '2': '२',
    '3': '३',
    '4': '४',
    '5': '५',
    '6': '६',
    '7': '७',
    '8': '८',
    '9': '९',
  };

  // Nepali month names
  static const Map<int, String> nepaliMonths = {
    1: 'बैशाख',
    2: 'जेठ',
    3: 'असार',
    4: 'साउन',
    5: 'भदौ',
    6: 'असोज',
    7: 'कार्तिक',
    8: 'मंसिर',
    9: 'पुष',
    10: 'माघ',
    11: 'फागुन',
    12: 'चैत',
  };

  /// Convert English numerals to Nepali numerals
  static String toNepaliNumber(String number) {
    String result = number;
    nepaliNumerals.forEach((english, nepali) {
      result = result.replaceAll(english, nepali);
    });
    return result;
  }

  /// Convert Nepali numerals to English numerals
  static String toEnglishNumber(String number) {
    String result = number;
    nepaliNumerals.forEach((english, nepali) {
      result = result.replaceAll(nepali, english);
    });
    return result;
  }

  /// Format Nepali date from "YYYY-MM-DD" to "२०८२ मंसिर १४"
  /// Example: "2082-08-14" -> "२०८२ मंसिर १४"
  static String formatNepaliDate(String? nepaliDate) {
    if (nepaliDate == null || nepaliDate.isEmpty) {
      return '';
    }

    try {
      // Split the date (format: YYYY-MM-DD)
      final parts = nepaliDate.split('-');
      if (parts.length != 3) return nepaliDate;

      final year = parts[0];
      final monthNumber = int.parse(parts[1]);
      final day = int.parse(parts[2]).toString(); // Remove leading zero

      // Get Nepali month name
      final monthName = nepaliMonths[monthNumber] ?? '';

      // Convert numbers to Nepali numerals
      final nepaliYear = toNepaliNumber(year);
      final nepaliDay = toNepaliNumber(day);

      return '$nepaliYear $monthName $nepaliDay';
    } catch (e) {
      return nepaliDate;
    }
  }

  /// Format date with gantey (१ गते, २ गते, etc.)
  static String formatNepaliDateWithGate(String? nepaliDate) {
    if (nepaliDate == null || nepaliDate.isEmpty) {
      return '';
    }

    try {
      final parts = nepaliDate.split('-');
      if (parts.length != 3) return nepaliDate;

      final year = parts[0];
      final monthNumber = int.parse(parts[1]);
      final day = int.parse(parts[2]).toString();

      final monthName = nepaliMonths[monthNumber] ?? '';
      final nepaliYear = toNepaliNumber(year);
      final nepaliDay = toNepaliNumber(day);

      return '$nepaliYear $monthName $nepaliDay गते';
    } catch (e) {
      return nepaliDate;
    }
  }
}
