import 'dart:convert';

List<Unit> unitListFromJson(String val) =>
    List<Unit>.from(json.decode(val).map((unit) => Unit.fromJson(unit)))
        .toList();

class Unit {
  int? id;
  Map<String, dynamic>? name; // {"en": "Kilogram", "ne": "किलोग्राम"}
  Map<String, dynamic>? code; // {"en": "kg", "ne": "कि.ग्रा."}
  bool? status;

  Unit({this.id, this.name, this.code, this.status});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'] == true || json['status'] == 1;

    final rawName = json['name'];
    if (rawName is Map) {
      name = Map<String, dynamic>.from(rawName);
    } else if (rawName is String) {
      name = Map<String, dynamic>.from(jsonDecode(rawName));
    }

    final rawCode = json['code'];
    if (rawCode is Map) {
      code = Map<String, dynamic>.from(rawCode);
    } else if (rawCode is String) {
      code = Map<String, dynamic>.from(jsonDecode(rawCode));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'status': status,
    };
  }

  /// Returns the localised name, falling back to English, then any available value.
  String getName([String locale = 'en']) {
    if (name == null || name!.isEmpty) return '';
    return (name![locale] ?? name!['en'] ?? name!.values.first ?? '') as String;
  }

  /// Returns the localised code, with the same fallback chain.
  String getCode([String locale = 'en']) {
    if (code == null || code!.isEmpty) return '';
    return (code![locale] ?? code!['en'] ?? code!.values.first ?? '') as String;
  }
}
