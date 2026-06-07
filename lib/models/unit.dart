import 'dart:convert';

List<Unit> unitListFromJson(String val) =>
    List<Unit>.from(json.decode(val).map((unit) => Unit.fromJson(unit)))
        .toList();

class Unit {
  int? id;
  String? name;
  String? code;
  Unit({
    this.id,
    this.name,
    this.code,
  });

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
