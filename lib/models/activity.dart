import 'dart:convert';

import 'package:smart_kishan/models/user.dart';

List<Activity> activityListFromJson(String val) => List<Activity>.from(
    json.decode(val).map((activity) => Activity.fromJson(activity))).toList();

class Activity {
  int? id;
  String? title;
  String? description;
  String? type;
  double? expense;
  double? income;
  int? productId;
  int? quantity;
  int? userId;
  String? date;
  User? user;
  Activity(
      {this.id,
      this.title,
      this.description,
      this.type,
      this.expense,
      this.income,
      this.productId,
      this.quantity,
      this.userId,
      this.date,
      this.user});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'] != null ? json['description'] : '';
    type = json['type'];
    expense = json['expense_amount'] != null
        ? double.tryParse(json['expense_amount'].toString())
        : null;
    income = json['income_amount'] != null
        ? double.tryParse(json['income_amount'].toString())
        : null;
    productId = json['product_id'];
    quantity = json['quantity'];
    userId = json['user_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    date = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['type'] = type;
    data['expense_amount'] = expense;
    data['income_amount'] = income;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['user_id'] = userId;
    data['date'] = date;
    data['user'] = user;
    return data;
  }
}
