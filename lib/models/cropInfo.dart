import 'dart:convert';

List<CropInfo> cropInfoListFromJson(String val) => List<CropInfo>.from(
    json.decode(val).map((cropInfo) => CropInfo.fromJson(cropInfo))).toList();

class CropInfo {
  int? id;
  String? image;
  String? name;
  String? name_en;
  String? description;
  List<CropActivity>? activity;
  int? order;
  Null? userId;
  int? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  CropInfo(
      {this.id,
      this.image,
      this.name,
      this.name_en,
      this.description,
      this.activity,
      this.order,
      this.userId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CropInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    name_en = json['name_en'];
    description = json['description'];
    if (json['activity'] != null) {
      activity = <CropActivity>[];
      json['activity'].forEach((v) {
        activity!.add(new CropActivity.fromJson(v));
      });
    }
    order = json['order'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['name_en'] = this.name_en;
    data['description'] = this.description;
    if (this.activity != null) {
      data['activity'] = this.activity!.map((v) => v.toJson()).toList();
    }
    data['order'] = this.order;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class CropActivity {
  String? title;
  String? description;

  CropActivity({this.title, this.description});

  CropActivity.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
