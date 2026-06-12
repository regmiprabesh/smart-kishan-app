import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/subsidy_controller..dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/models/multilingualField.dart';
import 'package:smart_kishan/models/subsidy.dart';
import 'package:smart_kishan/screens/subsidies_screen/pdf_viewer_screen.dart';
import 'package:smart_kishan/screens/subsidies_screen/image_viewer_screen.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/utils/custom_snackbar.dart';

class ApplicationDetailsScreen extends StatefulWidget {
  final int applicationId;
  final Subsidy subsidy;
  final String? applicationStatus;
  final String? appliedAt;
  final String? reviewedAt;
  final String? notes;
  final Map<String, dynamic>? formData;
  final List<dynamic>? applicationDocuments;

  const ApplicationDetailsScreen({
    super.key,
    required this.applicationId,
    required this.subsidy,
    this.applicationStatus,
    this.appliedAt,
    this.reviewedAt,
    this.notes,
    this.formData,
    this.applicationDocuments,
  });

  @override
  State<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends State<ApplicationDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final SubsidyController subsidyController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    subsidyController = Get.isRegistered<SubsidyController>()
        ? Get.find<SubsidyController>()
        : Get.put(SubsidyController());

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();

    // Debug print
    print('=== Application Details Debug ===');
    print('Form Data: ${widget.formData}');
    print('Application Documents: ${widget.applicationDocuments}');
    print('Notes: ${widget.notes}');
    print('Status: ${widget.applicationStatus}');
    print('================================');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return kCardDescColor;
    }
  }

  IconData getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'pending':
        return Icons.hourglass_empty_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String getStatusText(String? status) {
    final t = translation(context);
    switch (status?.toLowerCase()) {
      case 'approved':
        return t.approved;
      case 'rejected':
        return t.rejected;
      case 'pending':
        return t.pending;
      default:
        return status ?? '';
    }
  }

  String _formatDate(String? rawDate, String localeName) {
    if (rawDate == null || rawDate.isEmpty) return '';
    final dt = DateTime.tryParse(rawDate);
    if (dt == null) return rawDate;
    return DateFormat('EEEE, dd MMMM, yyyy', localeName).format(dt);
  }

  String formatShortDate(String? date) {
    final t = translation(context);
    if (date == null) return t.noInfo;
    try {
      final dateTime = DateTime.parse(date);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  void _showWithdrawDialog() {
    final t = translation(context);
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 56,
                ),
              ),
              SizedBox(height: 24),
              Text(
                t.withdrawApplication,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kCardTitleColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                t.withdrawConfirm ??
                    'Are you sure you want to withdraw this application?',
                style: TextStyle(
                  fontSize: 14,
                  color: kCardDescColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      kPrimaryColor.withOpacity(0.1),
                      kPrimaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: kPrimaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.card_giftcard,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.subsidy.title?.get(lang) ?? t.untitled,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kCardTitleColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange[700], size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.withdrawWarningMessage ??
                            'This action cannot be undone. You will need to reapply if you change your mind.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[800],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: kCardDescColor),
                      ),
                      child: Text(
                        t.cancel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kCardTitleColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        final success = await subsidyController
                            .withdrawApplication(widget.applicationId);
                        if (success) {
                          Get.back();
                          CustomSnackbar.success(
                            title: t.success ?? 'Success',
                            message: t.applicationWithdrawn ??
                                'Application withdrawn successfully',
                          );
                        } else {
                          CustomSnackbar.error(
                            title: t.error ?? 'Error',
                            message: t.applicationWithdrawFailed ??
                                'Failed to withdraw application',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.withdraw,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final t = translation(context);
    final status = widget.applicationStatus ?? 'pending';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Original SliverAppBar Design
// Replace your SliverAppBar widget with this updated version:

          SliverAppBar(
            expandedHeight: 200, // Reduced from 240
            pinned: true,
            backgroundColor: getStatusColor(status),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate if AppBar is collapsed
                final isCollapsed = constraints.maxHeight <=
                    kToolbarHeight + MediaQuery.of(context).padding.top;

                return FlexibleSpaceBar(
                  // Show title only when collapsed
                  title: isCollapsed
                      ? Text(
                          '${t.applicationId ?? 'Application ID'}: #${localizedNumber(widget.applicationId)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      : null,
                  centerTitle: true,
                  titlePadding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  // centerTitle: true,
                  // titlePadding:
                  //     EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          getStatusColor(status),
                          getStatusColor(status).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40), // Reduced padding
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: 'status_${widget.applicationId}',
                                child: Container(
                                  padding:
                                      EdgeInsets.all(16), // Reduced from 18
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    getStatusIcon(status),
                                    color: Colors.white,
                                    size: 36, // Reduced from 40
                                  ),
                                ),
                              ),
                              SizedBox(height: 10), // Reduced from 12
                              Text(
                                getStatusText(status).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 18, // Reduced from 20
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${t.applicationId ?? 'Application ID'}: #${localizedNumber(widget.applicationId)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.95),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // actions: [
            //   if (status.toLowerCase() == 'pending')
            //     IconButton(
            //       icon: Icon(Icons.delete_outline_rounded),
            //       onPressed: _showWithdrawDialog,
            //       tooltip: t.withdrawApplication,
            //     ),
            // ],
          ),
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Application Timeline
                      _buildTimeline(t),
                      SizedBox(height: 20),

                      // Subsidy Information
                      _buildSubsidyInfo(lang, t),
                      SizedBox(height: 20),

                      // Submitted Form Data
                      if (widget.formData != null &&
                          widget.formData!.isNotEmpty)
                        _buildFormDataSection(lang, t),

                      if (widget.formData != null &&
                          widget.formData!.isNotEmpty)
                        SizedBox(height: 20),

                      // Uploaded Documents
                      if (widget.applicationDocuments != null &&
                          widget.applicationDocuments!.isNotEmpty)
                        _buildDocumentsSection(t),

                      if (widget.applicationDocuments != null &&
                          widget.applicationDocuments!.isNotEmpty)
                        SizedBox(height: 20),

                      // Application Notes
                      if (widget.notes != null && widget.notes!.isNotEmpty)
                        _buildNotesSection(t),

                      if (widget.notes != null && widget.notes!.isNotEmpty)
                        SizedBox(height: 20),

                      // Status Message
                      _buildStatusMessage(status, t),

                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Withdraw Button (only for pending applications)
      floatingActionButton: status.toLowerCase() == 'pending'
          ? FloatingActionButton.extended(
              onPressed: _showWithdrawDialog,
              backgroundColor: Colors.red,
              icon: Icon(Icons.delete_outline_rounded, color: Colors.white),
              label: Text(
                t.withdraw,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildTimeline(dynamic t) {
    return _buildSection(
      title: t.applicationTimeline ?? 'Application Timeline',
      icon: Icons.timeline_rounded,
      iconColor: Colors.blue,
      child: Column(
        children: [
          _buildTimelineItem(
            icon: Icons.send_rounded,
            title: t.submitted ?? 'Submitted',
            date: _formatDate(widget.appliedAt, l10n.localeName),
            isCompleted: true,
          ),
          _buildTimelineDivider(isCompleted: widget.reviewedAt != null),
          _buildTimelineItem(
            icon: Icons.rate_review_rounded,
            title: t.reviewed ?? 'Reviewed',
            date: widget.reviewedAt != null
                ? _formatDate(widget.reviewedAt, l10n.localeName)
                : t.pending,
            isCompleted: widget.reviewedAt != null,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String date,
    required bool isCompleted,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isCompleted ? kPrimaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? kCardTitleColor : kCardDescColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: kCardDescColor,
                ),
              ),
            ],
          ),
        ),
        if (isCompleted)
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 24,
          ),
      ],
    );
  }

  Widget _buildTimelineDivider({required bool isCompleted}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Spacer for icon width
        SizedBox(width: 20), // match icon container width
        Container(
          height: 20,
          width: 2,
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isCompleted
                  ? [kPrimaryColor, kPrimaryColor]
                  : [kPrimaryColor, Colors.grey[300]!],
            ),
          ),
        ),
        SizedBox(width: 16), // spacing to the rest of the row
      ],
    );
  }

  Widget _buildSubsidyInfo(String lang, dynamic t) {
    return _buildSection(
      title: t.subsidyInformation ?? 'Subsidy Information',
      icon: Icons.card_giftcard,
      iconColor: kPrimaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoTile(
            label: t.title ?? 'Title',
            value: widget.subsidy.title?.get(lang) ?? t.noInfo,
            icon: Icons.title,
          ),
          SizedBox(height: 16),
          _buildInfoTile(
            label: t.subsidyType ?? 'Type',
            value: widget.subsidy.subsidyType ?? t.noInfo,
            icon: Icons.category,
          ),
          SizedBox(height: 16),
          _buildInfoTile(
            label: t.fiscalYear ?? 'Fiscal Year',
            value: widget.subsidy.fiscalYear != null
                ? localizedNumber(widget.subsidy.fiscalYear!)
                : t.noInfo,
            icon: Icons.calendar_today,
          ),
          SizedBox(height: 16),
          _buildInfoTile(
            label: t.deadline ?? 'Deadline',
            value: _formatDate(widget.subsidy.deadline, l10n.localeName),
            icon: Icons.event,
          ),
          if (widget.subsidy.budgetPerBeneficiary != null) ...[
            SizedBox(height: 16),
            _buildInfoTile(
              label: t.budgetPerBeneficiary ?? 'Budget Per Beneficiary',
              value:
                  '${l10n.currencySymbol} ${localizedNumber(widget.subsidy.budgetPerBeneficiary.toString())}',
              icon: Icons.account_balance_wallet,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormDataSection(String lang, dynamic t) {
    return _buildSection(
      title: t.submittedInformation ?? 'Submitted Information',
      icon: Icons.assignment_rounded,
      iconColor: Colors.purple,
      child: Column(
        children: widget.formData!.entries.map((entry) {
          // Try to find the corresponding field definition
          final fieldDef = widget.subsidy.applicationFormFields?.firstWhere(
            (field) => field.fieldKey == entry.key,
            orElse: () => ApplicationFormField(
              fieldKey: entry.key,
              label: MultilingualField(
                en: _formatFieldName(entry.key),
                ne: _formatFieldName(entry.key),
              ),
            ),
          );

          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: _buildInfoTile(
              label: fieldDef?.label?.get(lang) ?? _formatFieldName(entry.key),
              value: _formatFieldValue(entry.value, fieldDef),
              icon: _getFieldIcon(fieldDef?.fieldType),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatFieldValue(dynamic value, ApplicationFormField? fieldDef) {
    if (value == null) return translation(context).noInfo;

    // Handle different field types
    if (fieldDef != null) {
      switch (fieldDef.fieldType) {
        case 'date':
          try {
            final date = DateTime.parse(value.toString());
            return DateFormat('MMM dd, yyyy').format(date);
          } catch (e) {
            return value.toString();
          }
        case 'checkbox':
          return value.toString().toLowerCase() == 'true'
              ? translation(context).yes ?? 'Yes'
              : translation(context).no ?? 'No';
        case 'dropdown':
        case 'radio':
          // Try to find the option label
          final option = fieldDef.options?.firstWhere(
            (opt) => opt.value == value.toString(),
            orElse: () => FieldOption(value: value.toString()),
          );
          final locale = Localizations.localeOf(context);
          return option?.getLabel(locale.languageCode) ?? value.toString();
      }
    }

    return value.toString();
  }

  IconData _getFieldIcon(String? fieldType) {
    switch (fieldType) {
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'date':
        return Icons.calendar_today;
      case 'number':
        return Icons.numbers;
      case 'dropdown':
      case 'radio':
        return Icons.list;
      case 'checkbox':
        return Icons.check_box;
      case 'textarea':
        return Icons.subject;
      default:
        return Icons.text_fields;
    }
  }

  Widget _buildDocumentsSection(dynamic t) {
    return _buildSection(
      title: t.uploadedDocuments ?? 'Uploaded Documents',
      icon: Icons.attach_file_rounded,
      iconColor: Colors.orange,
      child: Column(
        children: widget.applicationDocuments!.map((doc) {
          final documentType = doc['document_type']?.toString() ?? '';
          final filePath = doc['file_path']?.toString() ?? '';
          final fileName = doc['file_name']?.toString() ?? '';
          final fileType = doc['file_type']?.toString() ?? '';

          return _buildDocumentTile(
            name: documentType,
            fileName: fileName,
            filePath: filePath,
            fileType: fileType,
          );
        }).toList(),
      ),
    );
  }

// In application_details_screen.dart, update the _buildNotesSection method:

// In application_details_screen.dart, update the _buildNotesSection method:

  Widget _buildNotesSection(dynamic t) {
    // Get notes based on current status
    final currentNote =
        widget.notes; // This will now be the status-specific note

    if (currentNote == null || currentNote.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildSection(
      title: t.applicationNotes ?? 'Application Notes',
      icon: Icons.note_rounded,
      iconColor: Colors.teal,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.withOpacity(0.05),
              Colors.teal.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.teal.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status-specific badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor(widget.applicationStatus),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: getStatusColor(widget.applicationStatus)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '${getStatusText(widget.applicationStatus)} Note',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Notes text
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.format_quote,
                        size: 18,
                        color: Colors.teal.withOpacity(0.4),
                      ),
                    ),
                    WidgetSpan(child: SizedBox(width: 6)),
                    TextSpan(
                      text: currentNote,
                      style: TextStyle(
                        fontSize: 15,
                        color: kCardTitleColor,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Info footer
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.teal.withOpacity(0.7),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t.notesDisclaimer ??
                          'This note is specific to your ${getStatusText(widget.applicationStatus).toLowerCase()} status',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.teal.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
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

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.1),
                  iconColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kCardTitleColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: kPrimaryColor),
          SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: kCardDescColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kCardTitleColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentTile({
    required String name,
    required String fileName,
    required String filePath,
    required String fileType,
  }) {
    final isPdf = fileType.toLowerCase() == 'pdf';
    final isImage =
        ['jpg', 'jpeg', 'png', 'gif'].contains(fileType.toLowerCase());

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle document viewing
            if (isPdf) {
              Get.to(
                () => PDFViewerScreen(
                  pdfUrl: filePath,
                  title: name,
                ),
                transition: Transition.rightToLeft,
              );
            } else if (isImage) {
              // Check if it's a URL or local file path
              if (filePath.startsWith('http://') ||
                  filePath.startsWith('https://')) {
                // It's a URL - open network image viewer
                Get.to(
                  () => ImageViewerScreen(
                    imageUrl: filePath, // Pass URL instead of file
                    title: name,
                  ),
                  transition: Transition.rightToLeft,
                );
              } else {
                // It's a local file path
                Get.to(
                  () => ImageViewerScreen(
                    imageFile: File(filePath),
                    title: name,
                  ),
                  transition: Transition.rightToLeft,
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isPdf
                        ? Colors.red.withOpacity(0.1)
                        : isImage
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isPdf
                        ? Icons.picture_as_pdf
                        : isImage
                            ? Icons.image
                            : Icons.insert_drive_file,
                    color: isPdf
                        ? Colors.red
                        : isImage
                            ? Colors.blue
                            : Colors.grey,
                    size: 24,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kCardTitleColor,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        fileName,
                        style: TextStyle(
                          fontSize: 11,
                          color: kCardDescColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 22),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: kCardDescColor, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusMessage(String status, dynamic t) {
    IconData icon;
    String title;
    String message;
    Color color;

    switch (status.toLowerCase()) {
      case 'approved':
        icon = Icons.celebration_rounded;
        title = t.congratulations ?? 'Congratulations!';
        message = t.applicationApprovedMessage ??
            'Your application has been approved. Further instructions will be provided soon.';
        color = Colors.green;
        break;
      case 'rejected':
        icon = Icons.info_outline_rounded;
        title = t.applicationRejected ?? 'Application Rejected';
        message = t.applicationRejectedMessage ??
            'Unfortunately, your application was not approved. You may reapply if eligible.';
        color = Colors.red;
        break;
      case 'pending':
      default:
        icon = Icons.pending_actions_rounded;
        title = t.underReview ?? 'Under Review';
        message = t.applicationPendingMessage ??
            'Your application is being reviewed. We will notify you once a decision is made.';
        color = Colors.orange;
        break;
    }

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: color.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatFieldName(String fieldKey) {
    return fieldKey
        .replaceAllMapped(RegExp(r'[_\s]+'), (match) => ' ')
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
