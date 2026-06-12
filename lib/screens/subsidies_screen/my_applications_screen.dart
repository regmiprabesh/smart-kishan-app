import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/subsidy_controller..dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/screens/subsidies_screen/application_details_screen.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/utils/custom_snackbar.dart';
import 'package:intl/intl.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  late final SubsidyController subsidyController;

  @override
  void initState() {
    super.initState();
    subsidyController = Get.isRegistered<SubsidyController>()
        ? Get.find<SubsidyController>()
        : Get.put(SubsidyController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subsidyController.getMyApplications();
    });
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
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_empty;
      default:
        return Icons.info;
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

  void _showWithdrawDialog(int subsidyId, String subsidyTitle) {
    final t = translation(context);

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
              // Animated Warning Icon
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

              // Title
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

              // Subsidy Title Card
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
                        subsidyTitle,
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

              // Warning Message
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
              SizedBox(height: 28),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: kPrimaryGrey, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.cancel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kCardDescColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back(); // Close dialog

                        // Show loading
                        Get.dialog(
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kPrimaryColor),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Withdrawing...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: kCardTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          barrierDismissible: false,
                        );

                        final success = await subsidyController
                            .withdrawApplication(subsidyId);

                        Get.back(); // Close loading

                        if (success) {
                          CustomSnackbar.success(
                            title: t.success ?? 'Success',
                            message: t.applicationWithdrawn,
                          );
                        } else {
                          CustomSnackbar.error(
                            title: t.failed ?? 'Failed',
                            message: t.applicationWithdrawFailed ??
                                'Failed to withdraw application. Please try again.',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        t.withdraw ?? 'Withdraw',
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
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final t = translation(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
          t.myApplications,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () => subsidyController.isSubsidiesLoading.value
            ? const Center(child: CircularProgressIndicator())
            : subsidyController.myApplications.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      await subsidyController.getMyApplications();
                    },
                    color: kPrimaryColor,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemBuilder: ((context, index) {
                        final subsidy = subsidyController.myApplications[index];
                        final status = subsidy.applicationStatus ?? 'pending';
                        final appliedAt = subsidy.appliedAt ?? subsidy.deadline;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildApplicationCard(
                            subsidy: subsidy,
                            status: status,
                            appliedAt: appliedAt,
                            lang: lang,
                            t: t,
                          ),
                        );
                      }),
                      itemCount: subsidyController.myApplications.length,
                    ),
                  )
                : _buildEmptyState(t),
      ),
    );
  }

  Widget _buildApplicationCard({
    required subsidy,
    required String status,
    required String? appliedAt,
    required String lang,
    required dynamic t,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: getStatusColor(status).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(
              () => ApplicationDetailsScreen(
                applicationId: subsidy.id ?? 1000,
                subsidy: subsidy,
                applicationStatus: subsidy.applicationStatus ?? status,
                appliedAt: subsidy.appliedAt ?? appliedAt,
                reviewedAt: subsidy.reviewedAt,
                notes: subsidy.applicationNotes,
                formData: subsidy.formData,
                applicationDocuments: subsidy.applicationDocuments,
              ),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 300),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Icon Circle
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: getStatusColor(status).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: getStatusColor(status),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        getStatusIcon(status),
                        color: getStatusColor(status),
                        size: 22,
                      ),
                    ),
                    SizedBox(width: 12),
                    // Title and Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subsidy.title?.get(lang) ?? t.untitled,
                            style: TextStyle(
                              fontSize: 15,
                              color: kCardTitleColor,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(status),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  getStatusIcon(status),
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  getStatusText(status).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14),

                // Description
                if (subsidy.description != null)
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      subsidy.description!.get(lang),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: kCardDescColor,
                        height: 1.5,
                      ),
                    ),
                  ),

                SizedBox(height: 14),

                // Applied Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: kCardDescColor,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '${t.applied}: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: kCardDescColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formatDate(appliedAt, l10n.localeName),
                      style: TextStyle(
                        fontSize: 12,
                        color: kCardTitleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Divider
                Divider(height: 1, color: Colors.grey[300]),

                SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(
                            () => ApplicationDetailsScreen(
                              applicationId: subsidy.id ?? 1000,
                              subsidy: subsidy,
                              applicationStatus:
                                  subsidy.applicationStatus ?? status,
                              appliedAt: subsidy.appliedAt ?? appliedAt,
                              reviewedAt: subsidy.reviewedAt,
                              notes: subsidy.applicationNotes,
                              formData: subsidy.formData,
                              applicationDocuments:
                                  subsidy.applicationDocuments,
                            ),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 300),
                          );
                        },
                        icon: Icon(Icons.visibility_rounded, size: 16),
                        label: Text(
                          t.viewDetails ?? 'View Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    if (status.toLowerCase() == 'pending') ...[
                      SizedBox(width: 8),
                      SizedBox(
                        height: 42,
                        width: 42,
                        child: OutlinedButton(
                          onPressed: () {
                            _showWithdrawDialog(
                              subsidy.id!,
                              subsidy.title?.get(lang) ?? t.untitled,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red, width: 1.5),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(dynamic t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kPrimaryColor.withOpacity(0.1),
                  kPrimaryColor.withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 80,
              color: kPrimaryColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 28),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              t.noApplicationsYet,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kCardTitleColor,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              t.startApplyingMessage ??
                  'Start applying for subsidies to see them here',
              style: TextStyle(
                fontSize: 14,
                color: kCardDescColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: Icon(Icons.explore, size: 20),
            label: Text(
              t.exploreSubsidies ?? 'Explore Subsidies',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}
