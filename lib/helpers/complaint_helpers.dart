import 'package:flutter/material.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';

class ComplaintHelpers {
  static String getCategoryTranslation(BuildContext context, String? category) {
    final t = translation(context);
    switch (category) {
      case 'crop_disease':
        return t.cropDisease;
      case 'pest_infestation':
        return t.pestInfestation;
      case 'irrigation_issue':
        return t.irrigationIssue;
      case 'road_infrastructure':
        return t.roadInfrastructure;
      case 'electricity':
        return t.electricity;
      case 'fertilizer_quality':
        return t.fertilizerQuality;
      case 'seed_quality':
        return t.seedQuality;
      case 'equipment_issue':
        return t.equipmentIssue;
      case 'water_supply':
        return t.waterSupply;
      case 'market_access':
        return t.marketAccess;
      case 'extension_service':
        return t.extensionService;
      case 'subsidy_related':
        return t.subsidyRelated;
      default:
        return t.other;
    }
  }

  static String getStatusTranslation(BuildContext context, String? status) {
    final t = translation(context);
    switch (status) {
      case 'pending':
        return t.pending;
      case 'acknowledged':
        return t.acknowledged;
      case 'under_investigation':
        return t.underInvestigation;
      case 'forwarded':
        return t.forwarded;
      case 'in_progress':
        return t.inProgress;
      case 'resolved':
        return t.resolved;
      case 'rejected':
        return t.rejected;
      case 'closed':
        return t.closed;
      default:
        return t.pending;
    }
  }

  static String getPriorityTranslation(BuildContext context, String? priority) {
    final t = translation(context);
    switch (priority) {
      case 'urgent':
        return t.urgent;
      case 'high':
        return t.high;
      case 'medium':
        return t.medium;
      case 'low':
        return t.low;
      default:
        return t.medium;
    }
  }

  static String getLevelTranslation(BuildContext context, String? level) {
    final t = translation(context);
    switch (level) {
      case 'ward':
        return t.wardLevel;
      case 'municipality':
        return t.municipalityLevel;
      case 'district':
        return t.districtLevel;
      case 'province':
        return t.provinceLevel;
      case 'central':
        return t.centralLevel;
      default:
        return t.wardLevel;
    }
  }
}
