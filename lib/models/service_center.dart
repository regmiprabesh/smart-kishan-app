import 'dart:convert';

class ServiceCenterType {
  final int id;
  final String name;
  final String? nameNe;
  final String? icon;
  final String? color;
  final String? description;
  final bool isActive;
  final int? serviceCentersCount;

  ServiceCenterType({
    required this.id,
    required this.name,
    this.nameNe,
    this.icon,
    this.color,
    this.description,
    required this.isActive,
    this.serviceCentersCount,
  });

  factory ServiceCenterType.fromJson(Map<String, dynamic> json) {
    return ServiceCenterType(
      id: json['id'],
      name: json['name'],
      nameNe: json['name_ne'],
      icon: json['icon'],
      color: json['color'] ?? '#4CAF50',
      description: json['description'],
      isActive: json['is_active'] ?? true,
      serviceCentersCount: json['service_centers_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ne': nameNe,
      'icon': icon,
      'color': color,
      'description': description,
      'is_active': isActive,
      'service_centers_count': serviceCentersCount,
    };
  }
}

class ServiceCenter {
  final int id;
  final int serviceCenterTypeId;
  final ServiceCenterType? type;
  final String name;
  final String? nameNe;
  final String address;
  final String? addressNe;
  final double latitude;
  final double longitude;
  final Province? province;
  final District? district;
  final Municipality? municipality;
  final int? wardNo;
  final String? phone;
  final String? email;
  final String? website;
  final Map<String, dynamic>? operatingHours;
  final List<String>? services;
  final String? description;
  final String? descriptionNe;
  final String? contactPerson;
  final String? contactPersonDesignation;
  final List<String>? images;
  final bool isActive;
  final bool isFeatured;
  final double? distance;
  final double? averageRating;
  final int? totalRatings;
  final ServiceCenterRating? userRating;
  final List<ServiceCenterRating>? ratings;

  ServiceCenter({
    required this.id,
    required this.serviceCenterTypeId,
    this.type,
    required this.name,
    this.nameNe,
    required this.address,
    this.addressNe,
    required this.latitude,
    required this.longitude,
    this.province,
    this.district,
    this.municipality,
    this.wardNo,
    this.phone,
    this.email,
    this.website,
    this.operatingHours,
    this.services,
    this.description,
    this.descriptionNe,
    this.contactPerson,
    this.contactPersonDesignation,
    this.images,
    required this.isActive,
    required this.isFeatured,
    this.distance,
    this.averageRating,
    this.totalRatings,
    this.userRating,
    this.ratings,
  });

  factory ServiceCenter.fromJson(Map<String, dynamic> json) {
    try {
      return ServiceCenter(
        id: json['id'] ?? 0,
        serviceCenterTypeId: json['service_center_type_id'] ?? 0,
        // type: json['type'] != null && json['type'] is Map
        //     ? ServiceCenterType.fromJson(
        //         Map<String, dynamic>.from(json['type']))
        //     : null,
        name: json['name'] ?? '',
        nameNe: json['name_ne'],
        address: json['address'] ?? '',
        addressNe: json['address_ne'],
        latitude: json['latitude'] != null
            ? double.parse(json['latitude'].toString())
            : 0.0,
        longitude: json['longitude'] != null
            ? double.parse(json['longitude'].toString())
            : 0.0,
        province: json['province'] != null && json['province'] is Map
            ? Province.fromJson(json['province'])
            : null,
        district: json['district'] != null && json['district'] is Map
            ? District.fromJson(json['district'])
            : null,
        municipality:
            json['municipality'] != null && json['municipality'] is Map
                ? Municipality.fromJson(json['municipality'])
                : null,
        wardNo: json['ward_no'],
        phone: json['phone'],
        email: json['email'],
        website: json['website'],
        operatingHours:
            json['operating_hours'] != null && json['operating_hours'] is Map
                ? Map<String, dynamic>.from(json['operating_hours'])
                : null,
        services: json['services'] != null && json['services'] is List
            ? List<String>.from(json['services'])
            : null,
        description: json['description'],
        descriptionNe: json['description_ne'],
        contactPerson: json['contact_person'],
        contactPersonDesignation: json['contact_person_designation'],
        images: json['images'] != null && json['images'] is List
            ? List<String>.from(json['images'])
            : null,
        isActive: json['is_active'] ?? true,
        isFeatured: json['is_featured'] ?? false,
        distance: json['distance'] != null
            ? double.parse(json['distance'].toString())
            : null,
        averageRating: json['average_rating'] != null
            ? double.parse(json['average_rating'].toString())
            : null,
        totalRatings: json['total_ratings'],
        userRating: json['user_rating'] != null && json['user_rating'] is Map
            ? ServiceCenterRating.fromJson(json['user_rating'])
            : null,
        ratings: json['ratings'] != null && json['ratings'] is List
            ? (json['ratings'] as List)
                .map((r) => ServiceCenterRating.fromJson(r))
                .toList()
            : null,
      );
    } catch (e) {
      print('Error parsing ServiceCenter: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_center_type_id': serviceCenterTypeId,
      'type': type?.toJson(),
      'name': name,
      'name_ne': nameNe,
      'address': address,
      'address_ne': addressNe,
      'latitude': latitude,
      'longitude': longitude,
      'province': province?.toJson(),
      'district': district?.toJson(),
      'municipality': municipality?.toJson(),
      'ward_no': wardNo,
      'phone': phone,
      'email': email,
      'website': website,
      'operating_hours': operatingHours,
      'services': services,
      'description': description,
      'description_ne': descriptionNe,
      'contact_person': contactPerson,
      'contact_person_designation': contactPersonDesignation,
      'images': images,
      'is_active': isActive,
      'is_featured': isFeatured,
      'distance': distance,
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'user_rating': userRating?.toJson(),
      'ratings': ratings?.map((r) => r.toJson()).toList(),
    };
  }

  String getLocalizedName(String lang) {
    return lang == 'ne' && nameNe != null ? nameNe! : name;
  }

  String getLocalizedAddress(String lang) {
    return lang == 'ne' && addressNe != null ? addressNe! : address;
  }

  String getLocalizedDescription(String lang) {
    return lang == 'ne' && descriptionNe != null
        ? descriptionNe!
        : description ?? '';
  }
}

class ServiceCenterRating {
  final int id;
  final int serviceCenterId;
  final int userId;
  final int rating;
  final String? review;
  final String? createdAt;
  final User? user;

  ServiceCenterRating({
    required this.id,
    required this.serviceCenterId,
    required this.userId,
    required this.rating,
    this.review,
    this.createdAt,
    this.user,
  });

  factory ServiceCenterRating.fromJson(Map<String, dynamic> json) {
    return ServiceCenterRating(
      id: json['id'],
      serviceCenterId: json['service_center_id'],
      userId: json['user_id'],
      rating: json['rating'],
      review: json['review'],
      createdAt: json['created_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_center_id': serviceCenterId,
      'user_id': userId,
      'rating': rating,
      'review': review,
      'created_at': createdAt,
      'user': user?.toJson(),
    };
  }
}

class Province {
  final int id;
  final String name;
  final String? nameNe;

  Province({required this.id, required this.name, this.nameNe});

  factory Province.fromJson(Map<String, dynamic> json) {
    final nameField = json['name'];
    String name = '';
    String? nameNe;

    if (nameField is Map) {
      name = nameField['en']?.toString() ?? '';
      nameNe = nameField['ne']?.toString();
    } else {
      name = nameField?.toString() ?? '';
    }

    return Province(id: json['id'], name: name, nameNe: nameNe);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'name_ne': nameNe};

  String getLocalizedName(String lang) =>
      lang == 'ne' && nameNe != null ? nameNe! : name;
}

class District {
  final int id;
  final String name;
  final String? nameNe;

  District({required this.id, required this.name, this.nameNe});

  factory District.fromJson(Map<String, dynamic> json) {
    final nameField = json['name'];
    String name = '';
    String? nameNe;

    if (nameField is Map) {
      name = nameField['en']?.toString() ?? '';
      nameNe = nameField['ne']?.toString();
    } else {
      name = nameField?.toString() ?? '';
    }

    return District(id: json['id'], name: name, nameNe: nameNe);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'name_ne': nameNe};

  String getLocalizedName(String lang) =>
      lang == 'ne' && nameNe != null ? nameNe! : name;
}

class Municipality {
  final int id;
  final String name;
  final String? nameNe;

  Municipality({required this.id, required this.name, this.nameNe});

  factory Municipality.fromJson(Map<String, dynamic> json) {
    final nameField = json['name'];
    String name = '';
    String? nameNe;

    if (nameField is Map) {
      name = nameField['en']?.toString() ?? '';
      nameNe = nameField['ne']?.toString();
    } else {
      name = nameField?.toString() ?? '';
    }

    return Municipality(id: json['id'], name: name, nameNe: nameNe);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'name_ne': nameNe};

  String getLocalizedName(String lang) =>
      lang == 'ne' && nameNe != null ? nameNe! : name;
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

// Helper functions for list parsing
List<ServiceCenter> serviceCenterListFromJson(String str) =>
    List<ServiceCenter>.from(
        json.decode(str).map((x) => ServiceCenter.fromJson(x)));

String serviceCenterListToJson(List<ServiceCenter> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<ServiceCenterType> serviceCenterTypeListFromJson(String str) =>
    List<ServiceCenterType>.from(
        json.decode(str).map((x) => ServiceCenterType.fromJson(x)));

String serviceCenterTypeListToJson(List<ServiceCenterType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
