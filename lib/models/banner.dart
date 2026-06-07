import 'dart:convert';

List<Banner> bannerListFromJson(String val) =>
    List<Banner>.from(json.decode(val).map((banner) => Banner.fromJson(banner)))
        .toList();

class Banner {
  int? id;
  String? name;
  String? url;
  String? image;

  Banner({
    this.id,
    this.name,
    this.url,
    this.image,
  });

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['image'] = this.image;
    return data;
  }
}
