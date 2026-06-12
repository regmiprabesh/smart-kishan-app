import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/subsidy_request_controller.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/helpers/l10n.dart';

class SubsidyRequestDetailsScreen extends StatefulWidget {
  const SubsidyRequestDetailsScreen({super.key});

  @override
  State<SubsidyRequestDetailsScreen> createState() =>
      _SubsidyRequestDetailsScreenState();
}

class _SubsidyRequestDetailsScreenState
    extends State<SubsidyRequestDetailsScreen> {
  late final SubsidyRequestController requestController;

  @override
  void initState() {
    super.initState();
    requestController = Get.find<SubsidyRequestController>();
  }

  String _formatDate(String? rawDate, String localeName) {
    if (rawDate == null || rawDate.isEmpty) return '';
    final dt = DateTime.tryParse(rawDate);
    if (dt == null) return rawDate;
    return DateFormat('EEEE, dd MMMM, yyyy', localeName).format(dt);
  }

  String _getCategoryName(String? type, BuildContext context) {
    if (type == null) return translation(context).general;
    final t = translation(context);

    switch (type.toLowerCase()) {
      case 'fertilizer':
        return t.fertilizer;
      case 'equipment':
        return t.equipment;
      case 'training':
        return t.training;
      case 'irrigation':
        return t.irrigation;
      case 'livestock':
        return t.livestock;
      case 'seeds':
        return t.seeds;
      case 'insurance':
        return t.insurance;
      case 'loan':
        return t.loan;
      default:
        return t.general;
    }
  }

  String _getLevelName(String? level, BuildContext context) {
    if (level == null) return '';
    final t = translation(context);

    switch (level.toLowerCase()) {
      case 'ward':
        return t.wardLevel;
      case 'municipality':
        return t.municipalityLevel;
      case 'district':
        return t.districtLevel;
      case 'province':
        return t.provinceLevel;
      case 'central':
        return t.central;
      default:
        return level;
    }
  }

  String _getStatusName(String? status, BuildContext context) {
    if (status == null) return '';
    final t = translation(context);

    switch (status.toLowerCase()) {
      case 'pending':
        return t.pending;
      case 'under_review':
        return t.underReview;
      case 'approved':
        return t.approved;
      case 'rejected':
        return t.rejected;
      case 'converted':
        return t.converted;
      default:
        return status;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'under_review':
        return Colors.blue;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'converted':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final t = translation(context);

    return Obx(() {
      final request = requestController.selectedRequest.value;
      if (request == null) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text(t.requestDetails),
          ),
          body: Center(
            child: Text(t.noRequestSelected),
          ),
        );
      }

      final statusColor = _getStatusColor(request.status);
      final canCancel = request.status?.toLowerCase() == 'pending';

      return Scaffold(
        appBar: AppBar(
          backgroundColor: statusColor,
          title: Text(
            t.requestDetails,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            request.title?.get(lang) ?? t.untitled,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStatusName(request.status, context),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getCategoryName(request.subsidyType, context),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getLevelName(request.requestedToLevel, context),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Details Section
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    if (request.description != null) ...[
                      _buildSectionTitle(t.description),
                      SizedBox(height: 10),
                      Text(
                        request.description!.get(lang),
                        style: TextStyle(
                          fontSize: 14,
                          color: kCardDescColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Target Crop/Sector
                    if (request.targetCropOrSector != null &&
                        request.targetCropOrSector!.get(lang).isNotEmpty) ...[
                      _buildSectionTitle(
                          t.targetSector ?? 'Target Crop/Sector'),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          request.targetCropOrSector!.get(lang),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[900],
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Justification
                    if (request.justification != null) ...[
                      _buildSectionTitle(t.justification ?? 'Justification'),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: kPrimaryColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          request.justification!.get(lang),
                          style: TextStyle(
                            fontSize: 14,
                            color: kCardTitleColor,
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Request Info Grid
                    _buildSectionTitle(t.requestInformation),
                    SizedBox(height: 10),
                    _buildInfoGrid(request, lang, t),

                    SizedBox(height: 20),

                    // Admin Notes (if any)
                    if (request.adminNotes != null &&
                        request.adminNotes!.get(lang).isNotEmpty) ...[
                      _buildSectionTitle(t.adminNotes),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: request.status?.toLowerCase() == 'rejected'
                              ? Colors.red[50]
                              : Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: request.status?.toLowerCase() == 'rejected'
                                ? Colors.red[200]!
                                : Colors.blue[200]!,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.admin_panel_settings,
                              color: request.status?.toLowerCase() == 'rejected'
                                  ? Colors.red[700]
                                  : Colors.blue[700],
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                request.adminNotes!.get(lang),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: request.status?.toLowerCase() ==
                                          'rejected'
                                      ? Colors.red[900]
                                      : Colors.blue[900],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Location Details
                    if (request.province != null ||
                        request.district != null ||
                        request.municipality != null ||
                        request.ward != null) ...[
                      _buildSectionTitle(t.locationDetails),
                      SizedBox(height: 10),
                      _buildLocationCard(request, lang, t),
                      SizedBox(height: 20),
                    ],

                    // Converted to Subsidy Link
                    if (request.status?.toLowerCase() == 'converted' &&
                        request.subsidyId != null) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple[50]!, Colors.purple[100]!],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purple[300]!),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.purple[700],
                              size: 48,
                            ),
                            SizedBox(height: 12),
                            Text(
                              t.requestConverted,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[900],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${t.convertedToSubsidy ?? "Your request has been converted to"} ${t.subsidyRelated} #${localizedNumber(request.subsidyId != null ? request.subsidyId! : 0)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Navigate to subsidy details
                                Get.toNamed('/subsidyDetailsScreen',
                                    arguments: request.subsidyId);
                              },
                              icon: Icon(Icons.arrow_forward, size: 18),
                              label: Text(
                                t.viewSubsidy,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple[700],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Action Buttons
                    if (canCancel) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showCancelDialog(context, request),
                          icon: Icon(Icons.cancel),
                          label: Text(
                            t.cancelRequest,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: kCardTitleColor,
      ),
    );
  }

  Widget _buildInfoGrid(request, String lang, dynamic t) {
    return Column(
      children: [
        _buildInfoRow(
          t.requestId,
          '#${localizedNumber(request.id)}',
        ),
        _buildInfoRow(
          t.subsidyType,
          _getCategoryName(request.subsidyType, context),
        ),
        _buildInfoRow(
          t.requestedTo,
          _getLevelName(request.requestedToLevel, context),
        ),
        _buildInfoRow(
          t.status,
          _getStatusName(request.status, context),
        ),
        _buildInfoRow(
          t.submittedOn,
          _formatDate(request.createdAt, l10n.localeName),
        ),
        if (request.reviewedAt != null)
          _buildInfoRow(
            t.reviewedOn ?? 'Reviewed On',
            _formatDate(request.reviewedAt, l10n.localeName),
          ),
        if (request.subsidyId != null)
          _buildInfoRow(
            t.subsidyId ?? 'Subsidy ID',
            '#${localizedNumber(request.subsidyId)}',
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kCardTitleColor,
              ),
            ),
          ),
          Text(': ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: kCardDescColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(request, String lang, dynamic t) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (request.province != null)
            _buildLocationItem(
              Icons.map,
              t.province ?? 'Province',
              request.province!.name?.get(lang) ?? '',
            ),
          if (request.district != null)
            _buildLocationItem(
              Icons.location_city,
              t.district ?? 'District',
              request.district!.name?.get(lang) ?? '',
            ),
          if (request.municipality != null)
            _buildLocationItem(
              Icons.apartment,
              t.municipality ?? 'Municipality',
              '${request.municipality!.name?.get(lang) ?? ''} (${request.municipality!.type ?? ''})',
            ),
          if (request.ward != null)
            _buildLocationItem(
              Icons.home,
              t.ward ?? 'Ward',
              request.ward!.name?.get(lang) ?? '',
            ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: kPrimaryColor),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kCardTitleColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: kCardDescColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, request) {
    final t = translation(context);
    final lang = Localizations.localeOf(context).languageCode;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[50]!, Colors.red[100]!],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red[600],
                  size: 56,
                ),
              ),
              SizedBox(height: 24),
              Text(
                t.confirmCancel,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                t.cancelRequestConfirm,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        t.cancel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);

                        final success =
                            await requestController.cancelRequest(request.id!);

                        if (success && mounted) {
                          Get.back(); // Go back to list screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text(
                                    t.requestCancelled,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.green[600],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.all(16),
                            ),
                          );
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t.cannotCancel),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.red[600],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.yesCancel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
