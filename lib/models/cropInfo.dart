import 'dart:convert';

List<CropInfo> cropInfoListFromJson(String val) => List<CropInfo>.from(
    json.decode(val).map((cropInfo) => CropInfo.fromJson(cropInfo))).toList();

class CropInfo {
  int? id;
  String? image;
  Map<String, dynamic>? name; // {"en": "Rice", "ne": "धान"}
  Map<String, dynamic>? description; // {"en": "...", "ne": "..."}
  List<CropActivity>? activity;
  int? cropCategoryId;
  int? order;
  int? userId;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  CropInfo({
    this.id,
    this.image,
    this.name,
    this.description,
    this.activity,
    this.cropCategoryId,
    this.order,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  CropInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    order = json['order'];
    userId = json['user_id'];
    status = json['status'] == true || json['status'] == 1;
    cropCategoryId = json['crop_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];

    final rawName = json['name'];
    if (rawName is Map) {
      name = Map<String, dynamic>.from(rawName);
    } else if (rawName is String) {
      name = Map<String, dynamic>.from(jsonDecode(rawName));
    }

    final rawDesc = json['description'];
    if (rawDesc is Map) {
      description = Map<String, dynamic>.from(rawDesc);
    } else if (rawDesc is String) {
      description = Map<String, dynamic>.from(jsonDecode(rawDesc));
    }

    // activity is a List — each item's title/description are locale maps
    final rawActivity = json['activity'];
    if (rawActivity is List) {
      activity = rawActivity
          .map((item) => CropActivity.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (rawActivity is String) {
      final decoded = jsonDecode(rawActivity) as List;
      activity = decoded
          .map((item) => CropActivity.fromJson(item as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'description': description,
      'activity': activity?.map((v) => v.toJson()).toList(),
      'crop_category_id': cropCategoryId,
      'order': order,
      'user_id': userId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  /// Localised name with English fallback.
  String getName([String locale = 'en']) {
    if (name == null || name!.isEmpty) return '';
    return (name![locale] ?? name!['en'] ?? name!.values.first ?? '') as String;
  }

  /// Localised description with English fallback.
  String getDescription([String locale = 'en']) {
    if (description == null || description!.isEmpty) return '';
    return (description![locale] ??
        description!['en'] ??
        description!.values.first ??
        '') as String;
  }
}

class CropActivity {
  Map<String, dynamic>? title; // {"en": "Sowing", "ne": "बीउ रोप्ने"}
  Map<String, dynamic>? description; // {"en": "...", "ne": "..."}

  CropActivity({this.title, this.description});

  CropActivity.fromJson(Map<String, dynamic> json) {
    final rawTitle = json['title'];
    if (rawTitle is Map) {
      title = Map<String, dynamic>.from(rawTitle);
    } else if (rawTitle is String) {
      // Could be a plain string on older data — wrap it so getTitle() still works
      try {
        title = Map<String, dynamic>.from(jsonDecode(rawTitle));
      } catch (_) {
        title = {'en': rawTitle};
      }
    }

    final rawDesc = json['description'];
    if (rawDesc is Map) {
      description = Map<String, dynamic>.from(rawDesc);
    } else if (rawDesc is String) {
      try {
        description = Map<String, dynamic>.from(jsonDecode(rawDesc));
      } catch (_) {
        description = {'en': rawDesc};
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }

  String getTitle([String locale = 'en']) {
    if (title == null || title!.isEmpty) return '';
    return (title![locale] ?? title!['en'] ?? title!.values.first ?? '')
        as String;
  }

  String getDescription([String locale = 'en']) {
    if (description == null || description!.isEmpty) return '';
    return (description![locale] ??
        description!['en'] ??
        description!.values.first ??
        '') as String;
  }
}
