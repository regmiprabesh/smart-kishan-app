import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/helpers/complaint_helpers.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/models/complaint.dart';
import 'package:smart_kishan/controllers/complaint_controller.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/screens/subsidies_screen/image_viewer_screen.dart';
import 'package:smart_kishan/screens/subsidies_screen/pdf_viewer_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  const ComplaintDetailsScreen({super.key});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen>
    with SingleTickerProviderStateMixin {
  final ComplaintController _complaintController = Get.find();
  late Complaint complaint;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    complaint = Get.arguments as Complaint;

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

    // Fetch full complaint details including comments
    if (complaint.id != null) {
      _complaintController.getComplaintDetails(complaint.id!);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final t = translation(context);

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kErrorColor,
          content: Text(t.pleaseEnterComment), // ← Translated
        ),
      );
      return;
    }

    if (_commentController.text.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kErrorColor,
          content: Text(t.commentMinLength), // ← Translated
        ),
      );
      return;
    }

    final success = await _complaintController.addComment(
      complaintId: complaint.id!,
      comment: _commentController.text.trim(),
    );

    if (success) {
      _commentController.clear();
      // Update local complaint with new data
      setState(() {
        complaint = _complaintController.selectedComplaint.value!;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kSuccessColor,
          content: Text(t.commentAddedSuccessfully), // ← Translated
        ),
      );
      // Scroll to bottom to show new comment
      Future.delayed(Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kErrorColor,
          content: Text(t.failedToAddComment), // ← Translated
        ),
      );
    }
  }

  Future<void> _openAttachment(String url, String fileName) async {
    if (url.isEmpty) return;

    // Check if it's a PDF
    if (url.toLowerCase().endsWith('.pdf')) {
      // Navigate to PDF viewer screen
      Get.to(() => PDFViewerScreen(
            pdfUrl: imgUrl + url,
            title: fileName,
          ));
    } else if (_isImageFile(url)) {
      // Show image in full screen viewer
      _showFullScreenImage(imgUrl + url, fileName);
    } else {
      // For other file types, use url_launcher
      final Uri uri = Uri.parse(url);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Cannot open document'),
            ),
          );
        }
      }
    }
  }

  bool _isImageFile(String url) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    final lowerUrl = url.toLowerCase();
    return imageExtensions.any((ext) => lowerUrl.endsWith(ext));
  }

  void _showFullScreenImage(String imageUrl, String fileName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ImageViewerScreen(
                title: fileName,
                imageUrl: imageUrl,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(complaint.status ?? 'pending');
    final priorityColor = _getPriorityColor(complaint.priority ?? 'medium');
    final t = translation(context);
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        // Use selectedComplaint from controller if available (has comments)
        final displayComplaint =
            _complaintController.selectedComplaint.value ?? complaint;

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            // SliverAppBar with status
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: statusColor,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed = constraints.maxHeight <=
                      kToolbarHeight + MediaQuery.of(context).padding.top;

                  return FlexibleSpaceBar(
                    title: isCollapsed
                        ? Text(
                            displayComplaint.complaintNumber ?? 'Complaint',
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
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            statusColor,
                            statusColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: 'complaint_${displayComplaint.id}',
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getStatusIcon(
                                          displayComplaint.status ?? 'pending'),
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  ComplaintHelpers.getStatusTranslation(context,
                                          displayComplaint.status ?? 'pending')
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 18,
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
                                    displayComplaint.complaintNumber ?? 'N/A',
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
              actions: [
                if (complaint.status == 'pending')
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert_rounded),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded,
                                color: Colors.red, size: 20),
                            SizedBox(width: 10),
                            Text(
                              t.cancelComplaint,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        onTap: () {
                          Future.delayed(
                            const Duration(milliseconds: 300),
                            () => _showCancelDialog(),
                          );
                        },
                      ),
                    ],
                  ),
              ],
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
                        // Title & Priority Card
                        _buildTitleCard(displayComplaint, priorityColor, t),

                        SizedBox(height: 10),

                        // Description Section
                        _buildCard(
                          title: t.description,
                          icon: Icons.description_outlined,
                          child: Text(
                            displayComplaint.description ?? t.noInfo,
                            style: TextStyle(
                              fontSize: 14,
                              color: kCardTitleColor,
                              height: 1.6,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        // Location Section
                        if (displayComplaint.specificLocation != null ||
                            displayComplaint.ward != null ||
                            displayComplaint.municipality != null ||
                            displayComplaint.district != null ||
                            displayComplaint.province != null)
                          _buildLocationCard(displayComplaint, t, lang),

                        if (displayComplaint.specificLocation != null ||
                            displayComplaint.ward != null ||
                            displayComplaint.municipality != null ||
                            displayComplaint.district != null ||
                            displayComplaint.province != null)
                          SizedBox(height: 10),

                        // Attachments Section
                        if (displayComplaint.attachments != null &&
                            displayComplaint.attachments!.isNotEmpty)
                          _buildAttachmentsCard(
                              displayComplaint.attachments!, t),

                        if (displayComplaint.attachments != null &&
                            displayComplaint.attachments!.isNotEmpty)
                          SizedBox(height: 10),

                        // Submitted To Section
                        _buildSubmittedToCard(displayComplaint, t),

                        SizedBox(height: 10),

                        // Assigned To Section
                        if (displayComplaint.assignedToUser != null)
                          _buildAssignedToCard(displayComplaint, t),

                        if (displayComplaint.assignedToUser != null)
                          SizedBox(height: 10),

                        // Resolution Section (if resolved)
                        if (displayComplaint.status == 'resolved' &&
                            displayComplaint.resolutionNotes != null)
                          _buildResolutionCard(displayComplaint, t),

                        if (displayComplaint.status == 'resolved' &&
                            displayComplaint.resolutionNotes != null)
                          SizedBox(height: 10),

                        // Comments Section
                        if (displayComplaint.comments != null &&
                            displayComplaint.comments!.isNotEmpty)
                          _buildCommentsSection(displayComplaint, lang, t),

                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      // Add Comment Section - Fixed at bottom
      bottomNavigationBar: _buildAddCommentSection(t),
    );
  }

  Widget _buildTitleCard(Complaint complaint, Color priorityColor, dynamic t) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: priorityColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Priority Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: priorityColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.flag_rounded,
                  color: priorityColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Title and Priority Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaint.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: priorityColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            ComplaintHelpers.getPriorityTranslation(
                                    context, complaint.priority)
                                .toUpperCase(),
                            style: const TextStyle(
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
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Category and Date Info
          Row(
            children: [
              Icon(Icons.category_outlined, size: 16, color: kPrimaryColor),
              const SizedBox(width: 8),
              Text(
                ComplaintHelpers.getCategoryTranslation(
                    context, complaint.category),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                '${t.submitted}: ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatDate(complaint.createdAt, l10n.localeName),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Complaint complaint, dynamic t, String lang) {
    return _buildCard(
      title: t.location,
      icon: Icons.location_on_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Only show specific location if it exists
          if (complaint.specificLocation != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.place, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      complaint.specificLocation!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 12), // Add spacing before administrative locations
          ],
          // Administrative locations (always show if they exist)
          if (complaint.ward != null ||
              complaint.municipality != null ||
              complaint.district != null ||
              complaint.province != null) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (complaint.ward?.name != null)
                  _buildLocationChip(
                      Icons.home_work, complaint.ward!.name!.get(lang)),
                if (complaint.municipality?.name != null)
                  _buildLocationChip(Icons.location_city,
                      complaint.municipality!.name!.get(lang)),
                if (complaint.district?.name != null)
                  _buildLocationChip(
                      Icons.map, complaint.district!.name!.get(lang)),
                if (complaint.province?.name != null)
                  _buildLocationChip(
                      Icons.public, complaint.province!.name!.get(lang)),
              ],
            ),
          ],
          // Coordinates (if they exist)
          if (complaint.latitude != null && complaint.longitude != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.1),
                    Colors.green.withOpacity(0.05)
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.my_location, color: Colors.green[700], size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${localizedNumber(complaint.latitude!.toStringAsFixed(6))}, ${localizedNumber(complaint.longitude!.toStringAsFixed(6))}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsCard(List<Attachment> attachments, dynamic t) {
    return _buildCard(
      title: t.attachmentsCount(attachments.length),
      icon: Icons.attach_file_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: kPrimaryColor, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.tapAnyFileToViewOrDownload,
                    style: TextStyle(
                      fontSize: 12,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Files list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: attachments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              final attachment = attachments[index];
              return _buildAttachmentItem(attachment);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(Attachment attachment) {
    final t = translation(context);
    final fileName = attachment.originalName ??
        attachment.url?.split('/').last ??
        'Attachment';
    final fileType = attachment.type?.toUpperCase() ?? '';
    final fileSize = attachment.size != null
        ? '${(attachment.size! / 1024).toStringAsFixed(1)} KB'
        : '';

    final isPdf = fileName.toLowerCase().endsWith('.pdf');
    final isImage = _isImageFile(fileName);

    return InkWell(
      onTap: () => _openAttachment(attachment.url ?? '', fileName),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon based on file type
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPdf
                    ? Colors.red.withOpacity(0.1)
                    : isImage
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isPdf
                      ? Colors.red.withOpacity(0.3)
                      : isImage
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Icon(
                isPdf
                    ? Icons.picture_as_pdf_rounded
                    : isImage
                        ? Icons.image_rounded
                        : Icons.insert_drive_file_rounded,
                color: isPdf
                    ? Colors.red[700]
                    : isImage
                        ? Colors.blue[700]
                        : Colors.grey[700],
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            // File details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (fileType.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            fileType,
                            style: TextStyle(
                              fontSize: 10,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      if (fileSize.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.data_usage,
                            size: 11, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          fileSize,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // View/Download icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmittedToCard(Complaint complaint, dynamic t) {
    return _buildCard(
      title: t.submitTo,
      icon: Icons.account_balance_outlined,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPrimaryColor.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getLevelIcon(complaint.submittedToLevel ?? 'ward'),
                color: Colors.white,
                size: 15,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              ComplaintHelpers.getLevelTranslation(
                  context, complaint.submittedToLevel ?? 'ward'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedToCard(Complaint complaint, dynamic t) {
    return _buildCard(
      title: t.assignedTo,
      icon: Icons.person_outline_rounded,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green.withOpacity(0.15),
              child: Text(
                complaint.assignedToUser!.name![0].toUpperCase(),
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    complaint.assignedToUser!.name ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 13, color: Colors.grey[600]),
                      const SizedBox(width: 5),
                      Text(
                        complaint.assignedToUser!.phone ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionCard(Complaint complaint, dynamic t) {
    return _buildCard(
      title: t.resolution,
      icon: Icons.check_circle_outline_rounded,
      color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.verified_rounded,
                        color: Colors.green[700], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Resolution Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  complaint.resolutionNotes!.en ??
                      complaint.resolutionNotes!.ne ??
                      t.noInfo,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          if (complaint.resolvedAt != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 13, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  '${t.resolvedOn}: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDate(complaint.resolvedAt, l10n.localeName),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentsSection(Complaint complaint, String lang, dynamic t) {
    return _buildCard(
      title: '${t.comments} (${localizedNumber(complaint.comments!.length)})',
      icon: Icons.comment_outlined,
      child: ListView.separated(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: complaint.comments!.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final comment = complaint.comments![index];
          return Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: kPrimaryColor.withOpacity(0.15),
                      child: Text(
                        comment.user?.name?[0].toUpperCase() ?? '?',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.user?.name ?? 'Unknown',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey[900],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 10, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(comment.createdAt, l10n.localeName),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  comment.comment?.en ?? comment.comment?.ne ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddCommentSection(dynamic t) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 +
            MediaQuery.of(context).viewInsets.bottom, // ← Fix keyboard overlap
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _addComment(),
                decoration: InputDecoration(
                  hintText: t.addComment, // ← Translated
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: kPrimaryColor, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Obx(() => _complaintController.isAddingComment.value
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                      ),
                    ),
                  )
                : Material(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: _addComment,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.send_rounded,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (color ?? kPrimaryColor).withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: (color ?? kPrimaryColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (color ?? kPrimaryColor).withOpacity(0.3),
                  ),
                ),
                child: Icon(icon, color: color ?? kPrimaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kPrimaryColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog() {
    final t = translation(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Text(
              t.cancelComplaint,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          t.confirmCancelComplaint,
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.noKeepIt,
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success =
                  await _complaintController.cancelComplaint(complaint.id!);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: kSuccessColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          t.complaintCancelled,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
                Get.back();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: kErrorColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          t.failedToCancel,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              t.yesCancel,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'acknowledged':
        return Icons.mark_email_read_rounded;
      case 'under_investigation':
        return Icons.search_rounded;
      case 'in_progress':
        return Icons.construction_rounded;
      case 'forwarded':
        return Icons.forward_to_inbox_rounded;
      case 'resolved':
        return Icons.check_circle_rounded;
      case 'closed':
        return Icons.done_all_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  IconData _getLevelIcon(String level) {
    switch (level) {
      case 'ward':
        return Icons.home_work_rounded;
      case 'municipality':
        return Icons.location_city_rounded;
      case 'district':
        return Icons.map_rounded;
      case 'province':
        return Icons.public_rounded;
      case 'central':
        return Icons.account_balance_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  String _getLevelName(String level) {
    switch (level) {
      case 'ward':
        return 'Ward Level';
      case 'municipality':
        return 'Municipality Level';
      case 'district':
        return 'District Level';
      case 'province':
        return 'Province Level';
      case 'central':
        return 'Central Level';
      default:
        return 'Unknown Level';
    }
  }

  String _formatDate(String? dateString, String localeName) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    final date = DateTime.tryParse(dateString);
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy • hh:mm a', localeName).format(date);
  }
}
