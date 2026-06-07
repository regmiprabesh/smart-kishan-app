import 'dart:convert';

import 'package:smart_kishan/models/multilingualField.dart';

List<Subsidy> subsidyListFromJson(String val) => List<Subsidy>.from(
    json.decode(val).map((subsidy) => Subsidy.fromJson(subsidy))).toList();

class ApplicationFormField {
  String? fieldKey;
  MultilingualField? label;
  String?
      fieldType; // text, number, email, phone, date, dropdown, textarea, checkbox, radio
  MultilingualField? placeholder;
  bool isRequired;
  bool isPrefilled;
  String?
      prefillSource; // full_name, email, phone, province, district, municipality, ward, address
  bool prefillEditable;
  List<FieldOption>? options; // For dropdown and radio
  double? minValue;
  double? maxValue;
  int? minLength;
  int? maxLength;
  MultilingualField? validationMessage;

  ApplicationFormField({
    this.fieldKey,
    this.label,
    this.fieldType,
    this.placeholder,
    this.isRequired = false,
    this.isPrefilled = false,
    this.prefillSource,
    this.prefillEditable = true,
    this.options,
    this.minValue,
    this.maxValue,
    this.minLength,
    this.maxLength,
    this.validationMessage,
  });

  factory ApplicationFormField.fromJson(Map<String, dynamic> json) {
    return ApplicationFormField(
      fieldKey: json['field_key'],
      label: MultilingualField.fromJson(json['label']),
      fieldType: json['field_type'],
      placeholder: MultilingualField.fromJson(json['placeholder']),
      isRequired: json['is_required'] ?? false,
      isPrefilled: json['is_prefilled'] ?? false,
      prefillSource: json['prefill_source'],
      prefillEditable: json['prefill_editable'] ?? true,
      options: json['options'] != null
          ? (json['options'] as List)
              .map((opt) => FieldOption.fromJson(opt))
              .toList()
          : null,
      minValue: json['min_value']?.toDouble(),
      maxValue: json['max_value']?.toDouble(),
      minLength: json['min_length'],
      maxLength: json['max_length'],
      validationMessage: MultilingualField.fromJson(json['validation_message']),
    );
  }
}

class FieldOption {
  String? value;
  String? label; // For backward compatibility
  String? labelEn;
  String? labelNe;

  FieldOption({
    this.value,
    this.label,
    this.labelEn,
    this.labelNe,
  });

  factory FieldOption.fromJson(Map<String, dynamic> json) {
    return FieldOption(
      value: json['value'],
      label: json['label'], // Single label (fallback)
      labelEn: json['label_en'],
      labelNe: json['label_ne'],
    );
  }

  // Helper method to get label by language
  String getLabel(String lang) {
    if (lang == 'ne') {
      return labelNe ?? labelEn ?? label ?? '';
    }
    return labelEn ?? label ?? '';
  }
}

// New class for required documents
class RequiredDocument {
  MultilingualField? name;
  MultilingualField? description;
  bool isRequired;
  int maxFileSize; // in MB
  List<String> acceptedFormats;

  RequiredDocument({
    this.name,
    this.description,
    this.isRequired = true,
    this.maxFileSize = 5,
    this.acceptedFormats = const ['pdf', 'jpg', 'png'],
  });

  factory RequiredDocument.fromJson(Map<String, dynamic> json) {
    return RequiredDocument(
      name: MultilingualField.fromJson(json['name']),
      description: MultilingualField.fromJson(json['description']),
      isRequired: json['is_required'] ?? true,
      maxFileSize: json['max_file_size'] ?? 5,
      acceptedFormats: json['accepted_formats'] != null
          ? List<String>.from(json['accepted_formats'])
          : ['pdf', 'jpg', 'png'],
    );
  }
}

// New class for subsidy documents (admin uploaded)
class SubsidyDocument {
  String? fileName;
  String? filePath;
  String? fileType; // pdf, jpg, png, etc.
  int? fileSize;

  SubsidyDocument({
    this.fileName,
    this.filePath,
    this.fileType,
    this.fileSize,
  });

  factory SubsidyDocument.fromJson(Map<String, dynamic> json) {
    return SubsidyDocument(
      fileName: json['file_name'],
      filePath: json['file_path'],
      fileType: json['file_type'],
      fileSize: json['file_size'],
    );
  }

  // Helper to check if it's a PDF
  bool get isPdf => fileType?.toLowerCase() == 'pdf';

  // Helper to check if it's an image
  bool get isImage =>
      ['jpg', 'jpeg', 'png', 'gif'].contains(fileType?.toLowerCase());
}

class Subsidy {
  int? id;
  MultilingualField? title;
  MultilingualField? description;
  String? subsidyType;
  MultilingualField? targetCropOrSector;
  String? fiscalYear;
  int? expectedBeneficiaries;
  MultilingualField? eligibilityCriteria;
  String? deadline;
  String? deadlineNepali;
  String? budgetPerBeneficiary;
  String? totalBudget;
  String? locationLevel;
  String? askedToLevel;
  String? status;
  String? documentPath;
  MultilingualField? notes;
  Province? province;
  District? district;
  Municipality? municipality;
  Ward? ward;
  bool? hasApplied;

  // New fields
  List<RequiredDocument>? requiredDocuments;
  List<SubsidyDocument>? documents; // Admin uploaded documents
  List<ApplicationFormField>? applicationFormFields;

  // Pivot data (for applications)
  String? applicationStatus;
  String? applicationNotes;
  String? appliedAt;
  String? reviewedAt;
  int? reviewedBy;
  List<dynamic>? applicationDocuments;
  Map<String, dynamic>? formData;
  double? averageRating;
  int? totalRatings;
  int? userRating;

  Subsidy({
    this.id,
    this.title,
    this.description,
    this.subsidyType,
    this.targetCropOrSector,
    this.fiscalYear,
    this.expectedBeneficiaries,
    this.eligibilityCriteria,
    this.deadline,
    this.deadlineNepali,
    this.budgetPerBeneficiary,
    this.totalBudget,
    this.locationLevel,
    this.askedToLevel,
    this.status,
    this.documentPath,
    this.notes,
    this.province,
    this.district,
    this.municipality,
    this.ward,
    this.hasApplied,
    this.requiredDocuments,
    this.documents,
    this.applicationFormFields,
    this.applicationStatus,
    this.applicationNotes,
    this.appliedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.applicationDocuments,
    this.formData,
    this.averageRating,
    this.totalRatings,
    this.userRating,
  });

  Subsidy.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    // Handle multilingual fields
    title = MultilingualField.fromJson(json['title']);
    description = MultilingualField.fromJson(json['description']);
    eligibilityCriteria =
        MultilingualField.fromJson(json['eligibility_criteria']);
    targetCropOrSector =
        MultilingualField.fromJson(json['target_crop_or_sector']);
    notes = MultilingualField.fromJson(json['notes']);

    subsidyType = json['subsidy_type'];
    fiscalYear = json['fiscal_year'];
    expectedBeneficiaries = json['expected_beneficiaries'];
    deadline = json['deadline'];
    deadlineNepali = json['deadline_nepali'];
    budgetPerBeneficiary = json['budget_per_beneficiary']?.toString();
    totalBudget = json['total_budget']?.toString();
    locationLevel = json['location_level'];
    askedToLevel = json['asked_to_level'];
    status = json['status'];
    documentPath = json['document_path'];

    province =
        json['province'] != null ? Province.fromJson(json['province']) : null;
    district =
        json['district'] != null ? District.fromJson(json['district']) : null;
    municipality = json['municipality'] != null
        ? Municipality.fromJson(json['municipality'])
        : null;
    ward = json['ward'] != null ? Ward.fromJson(json['ward']) : null;
    hasApplied = json['has_applied'] ?? false;

    // Parse rating data
    if (json['average_rating'] != null) {
      averageRating = double.tryParse(json['average_rating'].toString()) ?? 0.0;
    }
    if (json['total_ratings'] != null) {
      totalRatings = int.tryParse(json['total_ratings'].toString()) ?? 0;
    }
    if (json['user_rating'] != null) {
      userRating = int.tryParse(json['user_rating'].toString());
    }

    // Parse required documents
    if (json['required_documents'] != null &&
        json['required_documents'] is List) {
      requiredDocuments = (json['required_documents'] as List)
          .map((doc) => RequiredDocument.fromJson(doc))
          .toList();
    }

    // Parse subsidy documents (admin uploaded)
    if (json['documents'] != null && json['documents'] is List) {
      documents = (json['documents'] as List)
          .map((doc) => SubsidyDocument.fromJson(doc))
          .toList();
    }
    // : Parse application form fields
    if (json['application_form_fields'] != null &&
        json['application_form_fields'] is List) {
      applicationFormFields = (json['application_form_fields'] as List)
          .map((field) => ApplicationFormField.fromJson(field))
          .toList();
    }

    // Parse pivot data (for applications)
    if (json['pivot'] != null) {
      final pivot = json['pivot'];
      applicationStatus = pivot['application_status'];
      applicationNotes = pivot['application_notes'];
      appliedAt = pivot['applied_at'];
      reviewedAt = pivot['reviewed_at'];
      reviewedBy = pivot['reviewed_by'];

      // Parse application documents
      if (pivot['documents'] != null) {
        if (pivot['documents'] is String) {
          // It might be a JSON string
          try {
            final decoded = jsonDecode(pivot['documents']);
            applicationDocuments = decoded is List ? decoded : [decoded];
          } catch (e) {
            applicationDocuments = null;
          }
        } else if (pivot['documents'] is List) {
          applicationDocuments = pivot['documents'];
        }
      }
      if (pivot['form_data'] != null) {
        if (pivot['form_data'] is String) {
          try {
            final decoded = jsonDecode(pivot['form_data']);
            if (decoded is Map) {
              formData = Map<String, dynamic>.from(decoded);
              print('Successfully parsed form_data: $formData');
            } else {
              print('Decoded form_data is not a Map: ${decoded.runtimeType}');
              formData = null;
            }
          } catch (e) {
            print('Error parsing form_data JSON: $e');
            formData = null;
          }
        } else if (pivot['form_data'] is Map) {
          formData = Map<String, dynamic>.from(pivot['form_data']);
          print('form_data is already a Map: $formData');
        } else {
          print(
              'form_data is unexpected type: ${pivot['form_data'].runtimeType}');
          formData = null;
        }
      } else {
        print('form_data is null');
        formData = null;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['subsidy_type'] = subsidyType;
    data['fiscal_year'] = fiscalYear;
    data['expected_beneficiaries'] = expectedBeneficiaries;
    data['deadline'] = deadline;
    data['location_level'] = locationLevel;
    data['asked_to_level'] = askedToLevel;
    data['status'] = status;
    return data;
  }
}

class Province {
  int? id;
  MultilingualField? name;
  String? provinceName;

  Province({this.id, this.name, this.provinceName});

  Province.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = MultilingualField.fromJson(json['name']);
    provinceName = json['province_name'];
  }
}

class District {
  int? id;
  MultilingualField? name;

  District({this.id, this.name});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = MultilingualField.fromJson(json['name']);
  }
}

class Municipality {
  int? id;
  MultilingualField? name;
  String? type;

  Municipality({this.id, this.name, this.type});

  Municipality.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = MultilingualField.fromJson(json['name']);
    type = json['type'];
  }
}

class Ward {
  int? id;
  MultilingualField? name;
  int? wardNumber;

  Ward({this.id, this.name, this.wardNumber});

  Ward.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = MultilingualField.fromJson(json['name']);
    wardNumber = json['ward_number'];
  }
}
