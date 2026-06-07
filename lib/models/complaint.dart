import 'dart:convert';
import 'package:smart_kishan/models/complaintComment.dart';
import 'package:smart_kishan/models/multilingualField.dart';
import 'package:smart_kishan/models/subsidy.dart';
import 'package:smart_kishan/models/user.dart';

class Complaint {
  int? id;
  int? userId;
  String? complaintNumber;
  String? title;
  String? description;
  String? category;
  String? priority;
  String? status;
  int? provinceId;
  int? districtId;
  int? municipalityId;
  int? wardId;
  String? specificLocation;
  double? latitude;
  double? longitude;
  String? submittedToLevel;
  int? submittedToProvinceId;
  int? submittedToDistrictId;
  int? submittedToMunicipalityId;
  int? submittedToWardId;
  int? assignedTo;
  String? currentLevel;
  int? currentHandlerId;
  List<Attachment>? attachments;
  MultilingualField? resolutionNotes;
  String? resolvedAt;
  int? resolvedBy;
  String? acknowledgedAt;
  String? forwardedAt;
  String? createdAt;
  String? updatedAt;

  // Relationships
  User? user;
  Province? province;
  District? district;
  Municipality? municipality;
  Ward? ward;
  User? assignedToUser;
  User? currentHandler;
  List<ComplaintComment>? comments;

  Complaint({
    this.id,
    this.userId,
    this.complaintNumber,
    this.title,
    this.description,
    this.category,
    this.priority,
    this.status,
    this.provinceId,
    this.districtId,
    this.municipalityId,
    this.wardId,
    this.specificLocation,
    this.latitude,
    this.longitude,
    this.submittedToLevel,
    this.submittedToProvinceId,
    this.submittedToDistrictId,
    this.submittedToMunicipalityId,
    this.submittedToWardId,
    this.assignedTo,
    this.currentLevel,
    this.currentHandlerId,
    this.attachments,
    this.resolutionNotes,
    this.resolvedAt,
    this.resolvedBy,
    this.acknowledgedAt,
    this.forwardedAt,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.province,
    this.district,
    this.municipality,
    this.ward,
    this.assignedToUser,
    this.currentHandler,
    this.comments,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      userId: json['user_id'],
      complaintNumber: json['complaint_number'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      priority: json['priority'],
      status: json['status'],
      provinceId: json['province_id'],
      districtId: json['district_id'],
      municipalityId: json['municipality_id'],
      wardId: json['ward_id'],
      specificLocation: json['specific_location'],
      latitude: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : null,
      submittedToLevel: json['submitted_to_level'],
      submittedToProvinceId: json['submitted_to_province_id'],
      submittedToDistrictId: json['submitted_to_district_id'],
      submittedToMunicipalityId: json['submitted_to_municipality_id'],
      submittedToWardId: json['submitted_to_ward_id'],
      assignedTo: json['assigned_to'],
      currentLevel: json['current_level'],
      currentHandlerId: json['current_handler_id'],
      attachments: json['attachments'] != null
          ? List<Attachment>.from(
              json['attachments'].map((x) => Attachment.fromJson(x)))
          : null,
      resolutionNotes: json['resolution_notes'] != null
          ? MultilingualField.fromJson(json['resolution_notes'])
          : null,
      resolvedAt: json['resolved_at'],
      resolvedBy: json['resolved_by'],
      acknowledgedAt: json['acknowledged_at'],
      forwardedAt: json['forwarded_at'],
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
      assignedToUser: json['assigned_to_user'] != null
          ? User.fromJson(json['assigned_to_user'])
          : null,
      currentHandler: json['current_handler'] != null
          ? User.fromJson(json['current_handler'])
          : null,
      comments: json['comments'] != null
          ? List<ComplaintComment>.from(
              json['comments'].map((x) => ComplaintComment.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'complaint_number': complaintNumber,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'province_id': provinceId,
      'district_id': districtId,
      'municipality_id': municipalityId,
      'ward_id': wardId,
      'specific_location': specificLocation,
      'latitude': latitude,
      'longitude': longitude,
      'submitted_to_level': submittedToLevel,
      'submitted_to_province_id': submittedToProvinceId,
      'submitted_to_district_id': submittedToDistrictId,
      'submitted_to_municipality_id': submittedToMunicipalityId,
      'submitted_to_ward_id': submittedToWardId,
      'assigned_to': assignedTo,
      'current_level': currentLevel,
      'current_handler_id': currentHandlerId,
      'attachments': attachments?.map((x) => x.toJson()).toList(),
      'resolution_notes': resolutionNotes,
      'resolved_at': resolvedAt,
      'resolved_by': resolvedBy,
      'acknowledged_at': acknowledgedAt,
      'forwarded_at': forwardedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String getCategoryName() {
    switch (category) {
      case 'crop_disease':
        return 'Crop Disease';
      case 'pest_infestation':
        return 'Pest Infestation';
      case 'irrigation_issue':
        return 'Irrigation';
      case 'road_infrastructure':
        return 'Road Infrastructure';
      case 'electricity':
        return 'Electricity';
      case 'fertilizer_quality':
        return 'Fertilizer Quality';
      case 'seed_quality':
        return 'Seed Quality';
      case 'equipment_issue':
        return 'Equipment Issue';
      case 'water_supply':
        return 'Water Supply';
      case 'market_access':
        return 'Market Access';
      case 'extension_service':
        return 'Extension Service';
      case 'subsidy_related':
        return 'Subsidy Related';
      default:
        return 'Other';
    }
  }

  String getStatusName() {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'acknowledged':
        return 'Acknowledged';
      case 'under_investigation':
        return 'Under Investigation';
      case 'forwarded':
        return 'Forwarded';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'rejected':
        return 'Rejected';
      case 'closed':
        return 'Closed';
      default:
        return 'Unknown';
    }
  }

  String getPriorityName() {
    switch (priority) {
      case 'urgent':
        return 'Urgent';
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      case 'low':
        return 'Low';
      default:
        return 'Normal';
    }
  }
}

List<Complaint> complaintListFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Complaint>.from(jsonData.map((x) => Complaint.fromJson(x)));
}

String complaintListToJson(List<Complaint> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Attachment {
  String? url;
  String? type;
  int? size;
  String? originalName;

  Attachment({
    this.url,
    this.type,
    this.size,
    this.originalName,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      url: json['url'],
      type: json['type'],
      size: json['size'],
      originalName: json['original_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'type': type,
      'size': size,
      'original_name': originalName,
    };
  }
}
