import 'dart:convert';
import 'package:intl/intl.dart';

List<SearchHistory> searchHistoryListFromJson(String val) =>
    List<SearchHistory>.from(json
            .decode(val)
            .map((searchHistory) => SearchHistory.fromJson(searchHistory)))
        .toList();

class SearchHistory {
  final int id;
  final String searchTerm;
  DateTime searchedAt;

  SearchHistory({
    required this.id,
    required this.searchTerm,
    required this.searchedAt,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    final parsedDate = DateTime.parse(json['searched_at']);
    return SearchHistory(
      id: json['id'],
      searchTerm: json['search_term'],
      searchedAt: parsedDate,
    );
  }
}

String formatDate(DateTime date, String locale) {
  // Set the locale if needed
  Intl.defaultLocale = locale;
  String formattedDate;

  // Format the date as "Jan 7, 2025" for English or "जनवरी 7, 2025" for Nepali
  if (locale == 'ne') {
    // In Nepali format
    formattedDate = DateFormat('MMM d, y', 'ne').format(date);
  } else {
    // In English format
    formattedDate = DateFormat('MMM d, y', 'en_US').format(date);
  }

  // Return the formatted date with the appropriate prefix
  return locale == 'ne' ? formattedDate : formattedDate;
}
