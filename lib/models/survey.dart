import 'dart:convert';
import 'package:smart_kishan/models/multilingualField.dart';

List<Survey> surveyListFromJson(String val) =>
    List<Survey>.from(json.decode(val).map((survey) => Survey.fromJson(survey)))
        .toList();

class Survey {
  int? id;
  String? surveyCode;
  MultilingualField? title;
  MultilingualField? description;
  MultilingualField? instructions;
  String? type;
  String? targetLevel;
  String? status;
  String? startDate;
  String? endDate;
  bool? isActive;
  bool? isMandatory;
  bool? allowMultipleSubmissions;
  int? estimatedDurationMinutes;
  Province? targetProvince;
  District? targetDistrict;
  Municipality? targetMunicipality;
  Ward? targetWard;
  List<SurveyQuestion>? questions;
  int? totalQuestions;
  bool? hasResponded;
  String? lastResponseAt;
  int? responseCount;

  Survey({
    this.id,
    this.surveyCode,
    this.title,
    this.description,
    this.instructions,
    this.type,
    this.targetLevel,
    this.status,
    this.startDate,
    this.endDate,
    this.isActive,
    this.isMandatory,
    this.allowMultipleSubmissions,
    this.estimatedDurationMinutes,
    this.targetProvince,
    this.targetDistrict,
    this.targetMunicipality,
    this.targetWard,
    this.questions,
    this.totalQuestions,
    this.hasResponded,
    this.lastResponseAt,
    this.responseCount,
  });

  Survey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    surveyCode = json['survey_code'];
    title = MultilingualField.fromJson(json['title']);
    description = MultilingualField.fromJson(json['description']);
    instructions = MultilingualField.fromJson(json['instructions']);
    type = json['type'];
    targetLevel = json['target_level'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    isActive = json['is_active'] ?? false;
    isMandatory = json['is_mandatory'] ?? false;
    allowMultipleSubmissions = json['allow_multiple_submissions'] ?? false;
    estimatedDurationMinutes = json['estimated_duration_minutes'];
    totalQuestions = json['total_questions'];
    hasResponded = json['has_responded'] ?? false;
    lastResponseAt = json['last_response_at'];
    responseCount = json['response_count'] ?? 0;

    // Parse location data
    targetProvince = json['target_province'] != null
        ? Province.fromJson(json['target_province'])
        : null;
    targetDistrict = json['target_district'] != null
        ? District.fromJson(json['target_district'])
        : null;
    targetMunicipality = json['target_municipality'] != null
        ? Municipality.fromJson(json['target_municipality'])
        : null;
    targetWard =
        json['target_ward'] != null ? Ward.fromJson(json['target_ward']) : null;

    // Parse questions
    if (json['questions'] != null && json['questions'] is List) {
      questions = (json['questions'] as List)
          .map((q) => SurveyQuestion.fromJson(q))
          .toList();
    }
  }

  bool get isAvailable {
    if (isActive != true) return false;

    final now = DateTime.now();
    if (startDate != null) {
      try {
        final start = DateTime.parse(startDate!);
        if (now.isBefore(start)) return false;
      } catch (e) {
        print('Error parsing start date: $e');
      }
    }

    if (endDate != null) {
      try {
        final end = DateTime.parse(endDate!);
        if (now.isAfter(end)) return false;
      } catch (e) {
        print('Error parsing end date: $e');
      }
    }

    return true;
  }

  bool get canRespond {
    if (!isAvailable) return false;

    // If multiple submissions allowed, always can respond
    if (allowMultipleSubmissions == true) return true;

    // If multiple submissions not allowed, check if already responded
    if (hasResponded == true && allowMultipleSubmissions != true) return false;

    return true;
  }
}

class SurveyQuestion {
  int? id;
  MultilingualField? questionText;
  MultilingualField? helpText;
  String? questionType;
  List<QuestionOption>? options;
  bool? isRequired;
  int? order;
  double? minValue;
  double? maxValue;
  int? minLength;
  int? maxLength;
  int? dependsOnQuestionId;
  List<dynamic>? dependsOnValue;

  SurveyQuestion({
    this.id,
    this.questionText,
    this.helpText,
    this.questionType,
    this.options,
    this.isRequired,
    this.order,
    this.minValue,
    this.maxValue,
    this.minLength,
    this.maxLength,
    this.dependsOnQuestionId,
    this.dependsOnValue,
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SurveyQuestion(
      id: json['id'],
      questionText: MultilingualField.fromJson(json['question_text']),
      helpText: json['help_text'] != null
          ? MultilingualField.fromJson(json['help_text'])
          : null,
      questionType: json['question_type'],
      options: json['options'] != null
          ? (json['options'] as List)
              .map((opt) => QuestionOption.fromJson(opt))
              .toList()
          : null,
      isRequired: json['is_required'] ?? false,
      order: json['order'],
      minValue: json['min_value']?.toDouble(),
      maxValue: json['max_value']?.toDouble(),
      minLength: json['min_length'],
      maxLength: json['max_length'],
      dependsOnQuestionId: json['depends_on_question_id'],
      dependsOnValue: json['depends_on_value'],
    );
  }

  bool shouldShow(Map<int, dynamic> answers) {
    if (dependsOnQuestionId == null) return true;

    final parentAnswer = answers[dependsOnQuestionId];
    if (parentAnswer == null) return false;

    if (dependsOnValue == null || dependsOnValue!.isEmpty) return true;

    return dependsOnValue!.contains(parentAnswer);
  }
}

class QuestionOption {
  String? en;
  String? ne;
  String? value;

  QuestionOption({this.en, this.ne, this.value});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      en: json['en'],
      ne: json['ne'],
      value: json['value'],
    );
  }

  String getLabel(String lang) {
    return lang == 'ne' ? (ne ?? en ?? '') : (en ?? '');
  }
}

// Location Models (simplified)
class Province {
  int? id;
  MultilingualField? name;

  Province({this.id, this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: MultilingualField.fromJson(json['name']),
    );
  }
}

class District {
  int? id;
  MultilingualField? name;

  District({this.id, this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: MultilingualField.fromJson(json['name']),
    );
  }
}

class Municipality {
  int? id;
  MultilingualField? name;

  Municipality({this.id, this.name});

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(
      id: json['id'],
      name: MultilingualField.fromJson(json['name']),
    );
  }
}

class Ward {
  int? id;
  MultilingualField? name;

  Ward({this.id, this.name});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['id'],
      name: MultilingualField.fromJson(json['name']),
    );
  }
}
