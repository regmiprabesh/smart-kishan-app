import 'dart:convert';

import 'package:smart_kishan/models/user.dart';

List<Note> noteListFromJson(String val) =>
    List<Note>.from(json.decode(val).map((note) => Note.fromJson(note)))
        .toList();

class Note {
  int? id;
  String? title;
  String? description;
  int? priority;
  int? userId;
  String? date;
  User? user;

  Note(
      {this.id,
      this.title,
      this.description,
      this.priority,
      this.userId,
      this.date,
      this.user});

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    priority = json['priority'];
    userId = json['user_id'];
    date = json['created_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['priority'] = priority;
    data['user_id'] = userId;
    data['user'] = user;
    return data;
  }
}
