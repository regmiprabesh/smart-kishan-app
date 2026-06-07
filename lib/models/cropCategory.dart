import 'dart:convert';

List<CropCategory> cropCategoryListFromJson(String val) =>
    List<CropCategory>.from(json
        .decode(val)
        .map((cropCategory) => CropCategory.fromJson(cropCategory))).toList();

class CropCategory {
  int? id;
  String? name;
  String? image;

  CropCategory({this.id, this.name, this.image});

  CropCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
