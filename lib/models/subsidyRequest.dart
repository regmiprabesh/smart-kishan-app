import 'dart:convert';

import 'package:smart_kishan/models/multilingualField.dart';
import 'package:smart_kishan/models/subsidy.dart';
import 'package:smart_kishan/models/user.dart';

class SubsidyRequest {
  int? id;
  int? userId;
  MultilingualField? title;
  MultilingualField? description;
  String? subsidyType;
  MultilingualField? targetCropOrSector;
  MultilingualField? justification;
  int? provinceId;
  int? districtId;
  int? municipalityId;
  int? wardId;
  String? requestedToLevel;
  int? requestedToProvinceId;
  int? requestedToDistrictId;
  int? requestedToMunicipalityId;
  int? requestedToWardId;
  String? status; // pending, under_review, approved, rejected, converted
  MultilingualField? adminNotes;
  int? reviewedBy;
  String? reviewedAt;
  int? subsidyId; // If converted
  String? createdAt;
  String? updatedAt;

  // Relationships
  User? user;
  Province? province;
  District? district;
  Municipality? municipality;
  Ward? ward;

  SubsidyRequest({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.subsidyType,
    this.targetCropOrSector,
    this.justification,
    this.provinceId,
    this.districtId,
    this.municipalityId,
    this.wardId,
    this.requestedToLevel,
    this.requestedToProvinceId,
    this.requestedToDistrictId,
    this.requestedToMunicipalityId,
    this.requestedToWardId,
    this.status,
    this.adminNotes,
    this.reviewedBy,
    this.reviewedAt,
    this.subsidyId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.province,
    this.district,
    this.municipality,
    this.ward,
  });

  factory SubsidyRequest.fromJson(Map<String, dynamic> json) {
    return SubsidyRequest(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] != null
          ? MultilingualField.fromJson(json['title'])
          : null,
      description: json['description'] != null
          ? MultilingualField.fromJson(json['description'])
          : null,
      subsidyType: json['subsidy_type'],
      targetCropOrSector: json['target_crop_or_sector'] != null
          ? MultilingualField.fromJson(json['target_crop_or_sector'])
          : null,
      justification: json['justification'] != null
          ? MultilingualField.fromJson(json['justification'])
          : null,
      provinceId: json['province_id'],
      districtId: json['district_id'],
      municipalityId: json['municipality_id'],
      wardId: json['ward_id'],
      requestedToLevel: json['requested_to_level'],
      requestedToProvinceId: json['requested_to_province_id'],
      requestedToDistrictId: json['requested_to_district_id'],
      requestedToMunicipalityId: json['requested_to_municipality_id'],
      requestedToWardId: json['requested_to_ward_id'],
      status: json['status'],
      adminNotes: json['admin_notes'] != null
          ? MultilingualField.fromJson(json['admin_notes'])
          : null,
      reviewedBy: json['reviewed_by'],
      reviewedAt: json['reviewed_at'],
      subsidyId: json['subsidy_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      province:
          json['province'] != null ? Province.fromJson(json['province']) : null,
      district:
          json['district'] != null ? District.fromJson(json['district']) : null,
      municipality: json['municipality'] != null
          ? Municipality.fromJson(json['municipality'])
          : null,
      ward: json['ward'] != null ? Ward.fromJson(json['ward']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'subsidy_type': subsidyType,
      'target_crop_or_sector': targetCropOrSector,
      'justification': justification,
      'province_id': provinceId,
      'district_id': districtId,
      'municipality_id': municipalityId,
      'ward_id': wardId,
      'requested_to_level': requestedToLevel,
      'requested_to_province_id': requestedToProvinceId,
      'requested_to_district_id': requestedToDistrictId,
      'requested_to_municipality_id': requestedToMunicipalityId,
      'requested_to_ward_id': requestedToWardId,
      'status': status,
      'admin_notes': adminNotes,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt,
      'subsidy_id': subsidyId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

List<SubsidyRequest> subsidyRequestListFromJson(String str) {
  final jsonData = json.decode(str);
  return List<SubsidyRequest>.from(
      jsonData.map((x) => SubsidyRequest.fromJson(x)));
}

String subsidyRequestListToJson(List<SubsidyRequest> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}
