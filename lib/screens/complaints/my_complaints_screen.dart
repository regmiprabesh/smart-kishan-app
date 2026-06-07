import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/helpers/complaint_helpers.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/controllers/complaint_controller.dart';
import 'package:smart_kishan/models/complaint.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:intl/intl.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen>
    with SingleTickerProviderStateMixin {
  final ComplaintController _complaintController = Get.find();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _complaintController.getMyComplaints();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = translation(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
          t.myComplaints,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          unselectedLabelStyle:
              const TextStyle(fontSize: 14, color: Colors.white),
          tabs: [
            Tab(text: t.all),
            Tab(text: t.pending),
            Tab(text: t.active),
            Tab(text: t.resolved),
          ],
        ),
      ),
      body: Obx(() {
        if (_complaintController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          );
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildComplaintsList(_complaintController.myComplaints),
            _buildComplaintsList(_complaintController.myComplaints
                .where((c) => c.status == 'pending')
                .toList()),
            _buildComplaintsList(_complaintController.myComplaints
                .where((c) =>
                    c.status == 'acknowledged' ||
                    c.status == 'under_investigation' ||
                    c.status == 'in_progress')
                .toList()),
            _buildComplaintsList(_complaintController.myComplaints
                .where((c) => c.status == 'resolved' || c.status == 'closed')
                .toList()),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoute.fileComplaintScreen);
        },
        backgroundColor: kPrimaryColor,
        elevation: 6,
        icon: const Icon(Icons.add),
        label: Text(
          t.newComplaint,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildComplaintsList(List<Complaint> complaints) {
    final t = translation(context);

    if (complaints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              t.noComplaintsFound,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.fileComplaintToGetStarted,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _complaintController.getMyComplaints(),
      color: kPrimaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          return _buildComplaintCard(complaints[index]);
        },
      ),
    );
  }

  Widget _buildComplaintCard(Complaint complaint) {
    final statusColor = _getStatusColor(complaint.status ?? 'pending');
    final priorityColor = _getPriorityColor(complaint.priority ?? 'medium');
    final categoryIcon = _getCategoryIcon(complaint.category ?? 'other');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.toNamed(
              AppRoute.complaintDetailsScreen,
              arguments: complaint,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: categoryIcon['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        categoryIcon['icon'],
                        color: categoryIcon['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complaint.complaintNumber ?? 'N/A',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            complaint.title ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Priority Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: priorityColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        ComplaintHelpers.getPriorityTranslation(
                            context, complaint.priority ?? 'medium'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  complaint.description ?? 'No description',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Footer Row
                Row(
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            ComplaintHelpers.getStatusTranslation(
                                context, complaint.status ?? 'pending'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(complaint.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
      case 'acknowledged':
        return Colors.orange;
      case 'under_investigation':
      case 'in_progress':
        return Colors.blue;
      case 'forwarded':
        return Colors.purple;
      case 'resolved':
      case 'closed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red[700]!;
      case 'high':
        return Colors.orange[700]!;
      case 'medium':
        return Colors.blue[700]!;
      case 'low':
        return Colors.green[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Map<String, dynamic> _getCategoryIcon(String category) {
    switch (category) {
      case 'crop_disease':
        return {'icon': Icons.bug_report, 'color': Colors.red};
      case 'pest_infestation':
        return {'icon': Icons.pest_control, 'color': Colors.orange};
      case 'irrigation_issue':
        return {'icon': Icons.water_drop, 'color': Colors.blue};
      case 'road_infrastructure':
        return {'icon': Icons.route, 'color': Colors.grey[700]};
      case 'electricity':
        return {'icon': Icons.electric_bolt, 'color': Colors.yellow[700]};
      case 'fertilizer_quality':
        return {'icon': Icons.science, 'color': Colors.brown};
      case 'seed_quality':
        return {'icon': Icons.grass, 'color': Colors.green};
      case 'equipment_issue':
        return {'icon': Icons.build, 'color': Colors.blueGrey};
      case 'water_supply':
        return {'icon': Icons.water, 'color': Colors.lightBlue};
      case 'market_access':
        return {'icon': Icons.store, 'color': Colors.purple};
      case 'extension_service':
        return {'icon': Icons.support_agent, 'color': Colors.teal};
      case 'subsidy_related':
        return {'icon': Icons.account_balance_wallet, 'color': Colors.amber};
      default:
        return {'icon': Icons.help_outline, 'color': Colors.grey};
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
