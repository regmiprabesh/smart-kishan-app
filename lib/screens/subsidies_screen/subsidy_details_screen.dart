import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/subsidy_controller..dart';
import 'package:smart_kishan/helpers/nepali_date_helper.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/subsidies_screen/pdf_viewer_screen.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';

class SubsidyDetailsScreen extends StatefulWidget {
  const SubsidyDetailsScreen({super.key});

  @override
  State<SubsidyDetailsScreen> createState() => _SubsidyDetailsScreenState();
}

class _SubsidyDetailsScreenState extends State<SubsidyDetailsScreen> {
  late final SubsidyController subsidyController;

  @override
  void initState() {
    super.initState();
    subsidyController = Get.isRegistered<SubsidyController>()
        ? Get.find<SubsidyController>()
        : Get.put(SubsidyController());
  }

  String formatDate(String? date, {String? nepaliDate}) {
    final t = translation(context);
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;

    if (date == null) return t.noInfo;

    if (lang == 'ne' && nepaliDate != null && nepaliDate.isNotEmpty) {
      return NepaliDateHelper.formatNepaliDate(nepaliDate);
    }

    try {
      final dateTime = DateTime.parse(date);
      return DateFormat('MMMM dd, yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  bool isDeadlinePassed(String? deadline) {
    if (deadline == null) return false;
    try {
      final deadlineDate = DateTime.parse(deadline);
      return deadlineDate.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  String _getCategoryInNepali(String? type) {
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
      case 'organic':
        return t.organic;
      default:
        return t.general;
    }
  }

  String _getLocationInNepali(String? level) {
    if (level == null) return '';
    final t = translation(context);

    switch (level.toLowerCase()) {
      case 'central':
        return t.central;
      case 'province':
        return t.provinceLevel;
      case 'district':
        return t.districtLevel;
      case 'municipality':
        return t.municipalityLevel;
      case 'ward':
        return t.wardLevel;
      default:
        return level;
    }
  }

  Future<void> _openDocument(String? url, String? fileName) async {
    if (url == null || url.isEmpty) return;

    // Check if it's a PDF
    if (url.toLowerCase().endsWith('.pdf')) {
      // Navigate to PDF viewer screen
      Get.to(() => PDFViewerScreen(
            pdfUrl: url,
            title: fileName ?? translation(context).document,
          ));
    } else if (_isImageFile(url)) {
      // Show image in a dialog or full screen viewer
      _showFullScreenImage(url, fileName);
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
              content: Text(translation(context).cannotOpenDocument),
            ),
          );
        }
      }
    }
  }

// Helper method to check if file is an image
  bool _isImageFile(String url) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    final lowerUrl = url.toLowerCase();
    return imageExtensions.any((ext) => lowerUrl.endsWith(ext));
  }

// Alternative: Full-screen image viewer as a separate screen
  void _showFullScreenImage(String imageUrl, String? fileName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              fileName ?? translation(context).document,
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.white, size: 48),
                        SizedBox(height: 16),
                        Text(
                          translation(context).cannotOpenDocument,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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

    return Obx(() {
      final subsidy = subsidyController.selectedSubsidy.value;
      if (subsidy == null) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text(t.subsidyDetails),
          ),
          body: Center(child: Text(t.noSubsidySelected)),
        );
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            t.subsidyDetails,
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimaryColor, kPrimaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subsidy.title?.get(lang) ?? t.untitled,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getCategoryInNepali(subsidy.subsidyType),
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(10)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getLocationInNepali(subsidy.locationLevel),
                            style: const TextStyle(
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    if (subsidy.description != null) ...[
                      _buildSectionTitle(t.description),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        subsidy.description!.get(lang),
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          color: kCardDescColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],

                    // Eligibility Criteria
                    if (subsidy.eligibilityCriteria != null) ...[
                      _buildSectionTitle(t.eligibility),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: kPrimaryColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          subsidy.eligibilityCriteria!.get(lang),
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            color: kCardTitleColor,
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],

                    // Info Grid
                    _buildInfoGrid(subsidy, lang),

                    SizedBox(height: getProportionateScreenHeight(20)),

                    // Required Documents Section
                    if (subsidy.requiredDocuments != null &&
                        subsidy.requiredDocuments!.isNotEmpty) ...[
                      _buildSectionTitle(t.requiredDocumentsForApplication),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      _buildRequiredDocumentsList(subsidy, lang),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],

                    // Subsidy Detail Documents Section (Admin uploaded)
                    if (subsidy.documents != null &&
                        subsidy.documents!.isNotEmpty) ...[
                      _buildSectionTitle(t.subsidyDetailDocuments),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      _buildSubsidyDocumentsList(subsidy, lang),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],

                    // Location Details
                    if (subsidy.province != null ||
                        subsidy.district != null ||
                        subsidy.municipality != null ||
                        subsidy.ward != null) ...[
                      _buildSectionTitle(t.locationDetails),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      _buildLocationCard(subsidy, lang),
                      SizedBox(height: getProportionateScreenHeight(30)),
                    ],

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (subsidy.hasApplied ?? false)
                              ? Colors.grey
                              : isDeadlinePassed(subsidy.deadline)
                                  ? Colors.red
                                  : kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: ((subsidy.hasApplied ?? false) ||
                                isDeadlinePassed(subsidy.deadline))
                            ? null
                            : () {
                                Get.toNamed(AppRoute.applySubsidyScreen);
                              },
                        child: Text(
                          (subsidy.hasApplied ?? false)
                              ? t.alreadyApplied
                              : isDeadlinePassed(subsidy.deadline)
                                  ? t.deadlinePassed
                                  : t.applyNow,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: kCardTitleColor,
      ),
    );
  }

  Widget _buildRequiredDocumentsList(subsidy, String lang) {
    final t = translation(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t.documentsUploadWarning,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Documents list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: subsidy.requiredDocuments!.length,
            separatorBuilder: (context, index) => Divider(height: 20),
            itemBuilder: (context, index) {
              final doc = subsidy.requiredDocuments![index];
              return _buildRequiredDocumentItem(doc, lang);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredDocumentItem(doc, String lang) {
    final t = translation(context);
    final formats = doc.acceptedFormats.join(', ').toUpperCase();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Required badge
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: doc.isRequired ? Colors.red : Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            doc.isRequired ? t.required : t.optional,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 12),
        // Document details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doc.name?.get(lang) ?? '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kCardTitleColor,
                ),
              ),
              if (doc.description != null &&
                  doc.description!.get(lang).isNotEmpty) ...[
                SizedBox(height: 4),
                Text(
                  doc.description!.get(lang),
                  style: TextStyle(
                    fontSize: 12,
                    color: kCardDescColor,
                  ),
                ),
              ],
              SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildDocInfoChip(
                    Icons.file_present,
                    formats,
                    Colors.blue,
                  ),
                  _buildDocInfoChip(
                    Icons.cloud_upload,
                    '${doc.maxFileSize} MB',
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsidyDocumentsList(subsidy, String lang) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: subsidy.documents!.length,
        separatorBuilder: (context, index) => Divider(height: 16),
        itemBuilder: (context, index) {
          final doc = subsidy.documents![index];
          return _buildSubsidyDocumentItem(doc, lang);
        },
      ),
    );
  }

  Widget _buildSubsidyDocumentItem(doc, String lang) {
    final t = translation(context);
    final isPdf = doc.isPdf;
    final isImage = doc.isImage;

    return InkWell(
      onTap: () => _openDocument(doc.filePath, doc.fileName),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kPrimaryGrey),
        ),
        child: Row(
          children: [
            // Icon based on file type
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isPdf
                    ? Colors.red.withOpacity(0.1)
                    : isImage
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
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
            SizedBox(width: 12),
            // File details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.fileName ?? t.document,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kCardTitleColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        doc.fileType?.toUpperCase() ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: kCardDescColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (doc.fileSize != null) ...[
                        Text(
                          ' • ${(doc.fileSize! / 1024).toStringAsFixed(1)} KB',
                          style: TextStyle(
                            fontSize: 11,
                            color: kCardDescColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Download/View icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGrid(subsidy, String lang) {
    final t = translation(context);

    return Column(
      children: [
        if (subsidy.targetCropOrSector != null)
          _buildInfoRow(
            t.targetSector,
            subsidy.targetCropOrSector!.get(lang),
          ),
        if (subsidy.fiscalYear != null)
          _buildInfoRow(
            t.fiscalYear,
            subsidy.fiscalYear!,
          ),
        if (subsidy.expectedBeneficiaries != null)
          _buildInfoRow(
            t.expectedBeneficiaries,
            subsidy.expectedBeneficiaries.toString(),
          ),
        if (subsidy.budgetPerBeneficiary != null)
          _buildInfoRow(
            t.budgetPerBeneficiary,
            'रू ${subsidy.budgetPerBeneficiary}',
          ),
        if (subsidy.totalBudget != null)
          _buildInfoRow(
            t.totalBudget,
            'रू ${subsidy.totalBudget}',
          ),
        if (subsidy.deadline != null)
          _buildInfoRow(
            t.deadline,
            formatDate(subsidy.deadline, nepaliDate: subsidy.deadlineNepali),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kCardTitleColor,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: kCardDescColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(subsidy, String lang) {
    final t = translation(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subsidy.province != null)
            _buildLocationItem(
              Icons.map,
              t.province,
              subsidy.province!.name?.get(lang) ?? '',
            ),
          if (subsidy.district != null)
            _buildLocationItem(
              Icons.location_city,
              t.district,
              subsidy.district!.name?.get(lang) ?? '',
            ),
          if (subsidy.municipality != null)
            _buildLocationItem(
              Icons.apartment,
              t.municipality,
              '${subsidy.municipality!.name?.get(lang) ?? ''} (${subsidy.municipality!.type ?? ''})',
            ),
          if (subsidy.ward != null)
            _buildLocationItem(
              Icons.home,
              t.ward,
              subsidy.ward!.name?.get(lang) ?? '',
            ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: kPrimaryColor),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kCardTitleColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: kCardDescColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
