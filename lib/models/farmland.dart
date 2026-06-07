import 'dart:convert';

import 'package:smart_kishan/models/user.dart';

List<Farmland> farmlandListFromJson(String val) => List<Farmland>.from(
    json.decode(val).map((farmland) => Farmland.fromJson(farmland))).toList();

class Farmland {
  int? id;
  String? image;
  String? title;
  String? description;
  double? nitrogen;
  double? phosphate;
  double? potassium;
  double? pH;
  double? organicMatter;
  double? temperature;
  double? humidity;
  double? rainfall;
  double? lat;
  double? lng;
  int? userId;
  String? date;
  User? user;

  Farmland(
      {this.id,
      this.image,
      this.title,
      this.description,
      this.nitrogen,
      this.phosphate,
      this.potassium,
      this.pH,
      this.organicMatter,
      this.temperature,
      this.humidity,
      this.rainfall,
      this.lat,
      this.lng,
      this.userId,
      this.date,
      this.user});

  Farmland.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    nitrogen =
        json['nitrogen'] != null ? double.tryParse(json['nitrogen']) : null;
    phosphate =
        json['phosphate'] != null ? double.tryParse(json['phosphate']) : null;
    potassium =
        json['potassium'] != null ? double.tryParse(json['potassium']) : null;
    organicMatter = json['organic_matter'] != null
        ? double.tryParse(json['organic_matter'])
        : null;
    pH = json['pH'] != null ? double.tryParse(json['pH']) : null;
    temperature = json['temperature'];
    humidity = json['humidity'];
    rainfall = json['rainfall'];
    lat = json['lat'] != null ? double.tryParse(json['lat']) : null;
    lng = json['lng'] != null ? double.tryParse(json['lng']) : null;
    userId = json['user_id'];
    date = json['created_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    data['description'] = description;
    data['lat'] = lat;
    data['lng'] = lng;
    data['nitrogen'] = nitrogen;
    data['phosphate'] = phosphate;
    data['potassium'] = potassium;
    data['pH'] = pH;
    data['organic_matter'] = organicMatter;
    data['temperature'] = temperature;
    data['humidity'] = humidity;
    data['rainfall'] = rainfall;
    data['user_id'] = userId;
    data['user'] = user;
    return data;
  }
}
