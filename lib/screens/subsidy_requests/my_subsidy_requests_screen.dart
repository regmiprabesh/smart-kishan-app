import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/subsidy_request_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:intl/intl.dart';

class MySubsidyRequestsScreen extends StatefulWidget {
  const MySubsidyRequestsScreen({super.key});

  @override
  State<MySubsidyRequestsScreen> createState() =>
      _MySubsidyRequestsScreenState();
}

class _MySubsidyRequestsScreenState extends State<MySubsidyRequestsScreen> {
  final SubsidyRequestController requestController =
      Get.put(SubsidyRequestController());

  @override
  void initState() {
    super.initState();
    requestController.getMyRequests();
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

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'under_review':
        return Icons.rate_review;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'converted':
        return Icons.arrow_forward;
      default:
        return Icons.help_outline;
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

  String _formatDate(String? rawDate, String localeName) {
    if (rawDate == null || rawDate.isEmpty) return '';
    final dt = DateTime.tryParse(rawDate);
    if (dt == null) return rawDate;
    return DateFormat('EEEE, dd MMMM, yyyy', localeName).format(dt);
  }

  void _showCancelDialog(BuildContext context, int requestId, String title) {
    final t = translation(context);

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
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
                '${t.cancelRequestMessage}\n\n"$title"',
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
                      onPressed: () => Navigator.pop(context),
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
                        Navigator.pop(context);
                        final success =
                            await requestController.cancelRequest(requestId);

                        if (success && mounted) {
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
                        t.yesCancel ?? 'Yes, Cancel',
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

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final t = translation(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          t.myRequests,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
      ),
      body: Obx(
        () => requestController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : requestController.myRequests.isEmpty
                ? _buildEmptyState(t)
                : RefreshIndicator(
                    onRefresh: () async {
                      await requestController.getMyRequests();
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: requestController.myRequests.length,
                      itemBuilder: (context, index) {
                        final request = requestController.myRequests[index];
                        return _buildRequestCard(request, lang, t);
                      },
                    ),
                  ),
      ),
      // Floating Action Button - Always visible
      floatingActionButton: Obx(
        () => requestController.myRequests.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () => Get.toNamed(AppRoute.requestSubsidyScreen),
                backgroundColor: Colors.green[600],
                icon: Icon(Icons.add),
                label: Text(
                  t.requestNewSubsidy,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildEmptyState(dynamic t) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[200]!, Colors.grey[100]!],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 24),
            Text(
              t.noRequests ?? 'No Requests Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Text(
              t.noRequestsDescription ??
                  'You haven\'t submitted any subsidy requests',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoute.requestSubsidyScreen),
              icon: Icon(Icons.add),
              label: Text(
                t.requestNewSubsidy,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(request, String lang, dynamic t) {
    final statusColor = _getStatusColor(request.status);
    final canCancel = request.status?.toLowerCase() == 'pending';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            requestController.selectedRequest.value = request;
            Get.toNamed(AppRoute.subsidyRequestDetailsScreen);
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withOpacity(0.1),
                      statusColor.withOpacity(0.05)
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.title?.get(lang) ?? t.untitled,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                child: Text(
                                  _getCategoryName(
                                      request.subsidyType, context),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                              SizedBox(width: 6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.green[200]!),
                                ),
                                child: Text(
                                  _getLevelName(
                                      request.requestedToLevel, context),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(request.status),
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            _getStatusName(request.status, context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    if (request.description != null)
                      Text(
                        request.description!.get(lang),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                    SizedBox(height: 12),

                    // Info row
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey[600]),
                        SizedBox(width: 6),
                        Text(
                          '${t.submitted ?? "Submitted"}: ${_formatDate(request.createdAt, l10n.localeName)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (request.subsidyId != null) ...[
                          SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.link,
                                    size: 12, color: Colors.purple[700]),
                                SizedBox(width: 4),
                                Text(
                                  'Subsidy #${request.subsidyId}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.purple[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: 12),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              requestController.selectedRequest.value = request;
                              Get.toNamed(AppRoute.subsidyRequestDetailsScreen);
                            },
                            icon: Icon(Icons.visibility, size: 18),
                            label: Text(
                              t.viewDetails ?? 'View Details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green[700],
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        if (canCancel) ...[
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showCancelDialog(
                                context,
                                request.id!,
                                request.title?.get(lang) ?? '',
                              ),
                              icon: Icon(Icons.cancel, size: 18),
                              label: Text(
                                t.cancel,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
