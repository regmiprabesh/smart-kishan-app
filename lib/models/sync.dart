import 'dart:convert';

List<Sync> syncListFromJson(String val) =>
    List<Sync>.from(json.decode(val).map((note) => Sync.fromJson(note)))
        .toList();

class Sync {
  int? id;
  int? objectID;
  String? objectType;
  String? changeType;
  String? date;

  Sync({this.id, this.objectID, this.objectType, this.changeType, this.date});

  Sync.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    objectID = json['object_id'];
    objectType = json['object_type'];
    changeType = json['change_type'];
    date = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['object_id'] = objectID;
    data['object_type'] = objectType;
    data['change_type'] = changeType;
    data['timestamp'] = date;
    return data;
  }
}
