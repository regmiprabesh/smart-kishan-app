import 'dart:convert';
import 'package:smart_kishan/models/multilingualField.dart';
import 'package:smart_kishan/models/user.dart';

class ComplaintComment {
  int? id;
  int? complaintId;
  int? userId;
  MultilingualField? comment;
  bool? isInternal;
  String? createdAt;
  String? updatedAt;

  // Relationships
  User? user;

  ComplaintComment({
    this.id,
    this.complaintId,
    this.userId,
    this.comment,
    this.isInternal,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory ComplaintComment.fromJson(Map<String, dynamic> json) {
    return ComplaintComment(
      id: json['id'],
      complaintId: json['complaint_id'],
      userId: json['user_id'],
      comment: json['comment'] != null
          ? MultilingualField.fromJson(json['comment'])
          : null,
      isInternal: json['is_internal'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'complaint_id': complaintId,
      'user_id': userId,
      'comment': comment,
      'is_internal': isInternal,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

List<ComplaintComment> complaintCommentListFromJson(String str) {
  final jsonData = json.decode(str);
  return List<ComplaintComment>.from(
      jsonData.map((x) => ComplaintComment.fromJson(x)));
}

String complaintCommentListToJson(List<ComplaintComment> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}
