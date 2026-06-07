import 'dart:convert';

List<BuyersGroup> buyersGroupListFromJson(String val) =>
    List<BuyersGroup>.from(json
        .decode(val)
        .map((buyersGroup) => BuyersGroup.fromJson(buyersGroup))).toList();

class BuyersGroup {
  int? id;
  String? name;
  String? image;
  String? creator;
  List<Buyers>? buyers;

  BuyersGroup({this.id, this.name, this.creator, this.buyers});

  BuyersGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['buyers'] != null) {
      buyers = <Buyers>[];
      json['buyers'].forEach((v) {
        buyers!.add(new Buyers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.buyers != null) {
      data['buyers'] = this.buyers!.map((v) => v.toJson()).toList();
    } else {
      data['buyers'] = [];
    }
    return data;
  }
}

class Buyers {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? image;

  Buyers({this.name, this.phone, this.email});

  Buyers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    return data;
  }
}
