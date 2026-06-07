import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/complaint_controller.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/screens/subsidies_screen/pdf_viewer_screen.dart';
import 'package:smart_kishan/screens/subsidies_screen/image_viewer_screen.dart';

class FileComplaintScreen extends StatefulWidget {
  const FileComplaintScreen({super.key});

  @override
  State<FileComplaintScreen> createState() => _FileComplaintScreenState();
}

class _FileComplaintScreenState extends State<FileComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final ComplaintController _complaintController = Get.find();

  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  // Selected values
  String? _selectedCategory;
  String? _selectedPriority;
  String? _selectedLevel;

  // Validation flags
  bool _categoryError = false;
  bool _priorityError = false;
  bool _levelError = false;

  // File attachment
  File? _attachedFile;

  bool _hasAttemptedSubmit = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  // Category options with multilingual support
  List<Map<String, dynamic>> _getCategories(dynamic t) {
    return [
      {
        'value': 'crop_disease',
        'label_en': 'Crop Disease',
        'label_ne': 'बाली रोग',
        'icon': Icons.bug_report,
        'color': Colors.red
      },
      {
        'value': 'pest_infestation',
        'label_en': 'Pest Infestation',
        'label_ne': 'कीट प्रकोप',
        'icon': Icons.pest_control,
        'color': Colors.orange
      },
      {
        'value': 'irrigation_issue',
        'label_en': 'Irrigation Issue',
        'label_ne': 'सिँचाइ समस्या',
        'icon': Icons.water_drop,
        'color': Colors.blue
      },
      {
        'value': 'road_infrastructure',
        'label_en': 'Road Infrastructure',
        'label_ne': 'सडक पूर्वाधार',
        'icon': Icons.route,
        'color': Colors.grey
      },
      {
        'value': 'electricity',
        'label_en': 'Electricity',
        'label_ne': 'बिजुली',
        'icon': Icons.electric_bolt,
        'color': Colors.yellow[700]
      },
      {
        'value': 'fertilizer_quality',
        'label_en': 'Fertilizer Quality',
        'label_ne': 'मल गुणस्तर',
        'icon': Icons.science,
        'color': Colors.brown
      },
      {
        'value': 'seed_quality',
        'label_en': 'Seed Quality',
        'label_ne': 'बीउ गुणस्तर',
        'icon': Icons.grass,
        'color': Colors.green
      },
      {
        'value': 'equipment_issue',
        'label_en': 'Equipment Issue',
        'label_ne': 'उपकरण समस्या',
        'icon': Icons.build,
        'color': Colors.blueGrey
      },
      {
        'value': 'water_supply',
        'label_en': 'Water Supply',
        'label_ne': 'पानी आपूर्ति',
        'icon': Icons.water,
        'color': Colors.lightBlue
      },
      {
        'value': 'market_access',
        'label_en': 'Market Access',
        'label_ne': 'बजार पहुँच',
        'icon': Icons.store,
        'color': Colors.purple
      },
      {
        'value': 'extension_service',
        'label_en': 'Extension Service',
        'label_ne': 'विस्तार सेवा',
        'icon': Icons.support_agent,
        'color': Colors.teal
      },
      {
        'value': 'subsidy_related',
        'label_en': 'Subsidy Related',
        'label_ne': 'अनुदान सम्बन्धित',
        'icon': Icons.account_balance_wallet,
        'color': Colors.amber
      },
    ];
  }

  // Priority options with multilingual support
  List<Map<String, dynamic>> _getPriorities(dynamic t) {
    return [
      {
        'value': 'urgent',
        'label_en': 'Urgent',
        'label_ne': 'अत्यावश्यक',
        'color': Colors.red[700],
        'icon': Icons.warning_amber
      },
      {
        'value': 'high',
        'label_en': 'High',
        'label_ne': 'उच्च',
        'color': Colors.orange[700],
        'icon': Icons.priority_high
      },
      {
        'value': 'medium',
        'label_en': 'Medium',
        'label_ne': 'मध्यम',
        'color': Colors.blue[700],
        'icon': Icons.remove
      },
      {
        'value': 'low',
        'label_en': 'Low',
        'label_ne': 'कम',
        'color': Colors.green[700],
        'icon': Icons.arrow_downward
      },
    ];
  }

  // Government levels with multilingual support
  List<Map<String, dynamic>> _getLevels(dynamic t) {
    return [
      {
        'value': 'ward',
        'label_en': 'Ward Level',
        'label_ne': 'वडा तह',
        'icon': Icons.home_work
      },
      {
        'value': 'municipality',
        'label_en': 'Municipality Level',
        'label_ne': 'नगरपालिका तह',
        'icon': Icons.location_city
      },
      {
        'value': 'district',
        'label_en': 'District Level',
        'label_ne': 'जिल्ला तह',
        'icon': Icons.map
      },
      {
        'value': 'province',
        'label_en': 'Province Level',
        'label_ne': 'प्रदेश तह',
        'icon': Icons.public
      },
      {
        'value': 'central',
        'label_en': 'Central Level',
        'label_ne': 'केन्द्रीय तह',
        'icon': Icons.account_balance
      },
    ];
  }

  bool _isPreviewable(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    return ['pdf', 'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp']
        .contains(extension);
  }

  void _previewDocument(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    final t = translation(context);

    if (extension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            pdfFile: file,
            title: t.attachmentPreview ?? 'Attachment Preview',
          ),
        ),
      );
    } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp']
        .contains(extension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewerScreen(
            imageFile: file,
            title: t.attachmentPreview ?? 'Attachment Preview',
          ),
        ),
      );
    }
  }

  Future<void> _pickFile() async {
    final t = translation(context);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        // Check file size (max 5MB)
        int fileSizeInBytes = await file.length();
        int maxSizeInBytes = 5 * 1024 * 1024;

        if (fileSizeInBytes > maxSizeInBytes) {
          _showSnackBar(t.fileTooLarge ?? 'File size must be less than 5MB',
              isError: true);
          return;
        }

        setState(() {
          _attachedFile = file;
        });

        _showSnackBar('File attached successfully', isError: false);
      }
    } catch (e) {
      _showSnackBar('Failed to pick file: ${e.toString()}', isError: true);
    }
  }

  void _removeFile() {
    setState(() {
      _attachedFile = null;
    });
  }

  Future<void> _getMyLocation() async {
    final t = translation(context);
    try {
      Map<String, double>? myPosition = await farmlandController.getMyLatLng();
      if (myPosition != null &&
          myPosition.containsKey('lat') &&
          myPosition.containsKey('lng')) {
        setState(() {
          _latitudeController.text = myPosition['lat'].toString();
          _longitudeController.text = myPosition['lng'].toString();
        });
        _showSnackBar(t.locationFetched ?? 'Location fetched successfully',
            isError: false);
      }
    } catch (e) {
      _showSnackBar(t.failedToGetLocation ?? 'Failed to get location',
          isError: true);
    }
  }

  Future<void> _submitComplaint() async {
    final t = translation(context);

    // SET THE FLAG FIRST - before any validation
    setState(() {
      _hasAttemptedSubmit = true;
    });

    // Now validate form
    bool formValid = _formKey.currentState!.validate();

    // Check selections
    bool selectionsValid = _selectedCategory != null &&
        _selectedPriority != null &&
        _selectedLevel != null;

    if (!formValid || !selectionsValid) {
      _showSnackBar(
        t.pleaseCheckAllFields ?? 'Please fill all required fields',
        isError: true,
      );
      return;
    }

    final success = await _complaintController.submitComplaint(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      priority: _selectedPriority!,
      submittedToLevel: _selectedLevel!,
      specificLocation: _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : null,
      latitude: _latitudeController.text.isNotEmpty
          ? double.tryParse(_latitudeController.text)
          : null,
      longitude: _longitudeController.text.isNotEmpty
          ? double.tryParse(_longitudeController.text)
          : null,
      attachmentFile: _attachedFile,
    );

    if (success) {
      _showSnackBar(t.complaintSubmitted, isError: false);
      Get.back();
    } else {
      _showSnackBar(t.failedToSubmit, isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? kErrorColor : kSuccessColor,
        content: Text(
          message,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = translation(context);
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;

    final categories = _getCategories(t);
    final priorities = _getPriorities(t);
    final levels = _getLevels(t);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
          t.fileComplaint,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header Card - Gradient like before
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kPrimaryColor, Colors.green[700]!],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.report_problem_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.reportYourIssue,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t.weAreHereToHelp,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Category Selection
                        _buildSectionTitle(
                            t.complaintCategory + ' *', Icons.category),
                        const SizedBox(height: 12),
                        _buildCategoryGrid(categories, lang),
                        if (_hasAttemptedSubmit && _selectedCategory == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 12),
                            child: Text(
                              t.pleaseSelectCategory,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),

                        // Priority Selection
                        _buildSectionTitle(t.priorityLevel + ' *', Icons.flag),
                        const SizedBox(height: 12),
                        _buildPrioritySelection(priorities, lang),
                        if (_hasAttemptedSubmit && _selectedPriority == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 12),
                            child: Text(
                              t.pleaseSelectPriority,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),

                        // Title Field
                        _buildSectionTitle(
                            t.complaintTitle + ' *', Icons.title),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _titleController,
                          label: t.complaintTitle,
                          hint: t.enterComplaintTitle,
                          icon: Icons.text_fields,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return t.pleaseEnterTitle;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // Description Field (No prefix icon, top-aligned label)
                        _buildSectionTitle(
                            t.detailedDescription + ' *', Icons.description),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _descriptionController,
                          label: t.description,
                          hint: t.describeComplaint,
                          maxLines: 5,
                          showPrefixIcon: false,
                          alignLabelWithText: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return t.pleaseProvideDescription;
                            }
                            if (value.trim().length < 5) {
                              return t.descriptionMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Location Field
                        _buildSectionTitle(
                            t.specificLocation, Icons.location_on),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _locationController,
                          label: t.locationDetailsOptional,
                          hint: t.locationHint,
                          icon: Icons.place,
                        ),
                        const SizedBox(height: 24),

                        // Latitude & Longitude Section (Optional)
                        _buildSectionTitle(
                            t.coordinates ?? 'Coordinates', Icons.location_on),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _latitudeController,
                                      label: t.latitude ?? 'Latitude',
                                      hint: t.enterLatitude ?? 'Enter latitude',
                                      icon: Icons.location_on,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _longitudeController,
                                      label: t.longitude ?? 'Longitude',
                                      hint:
                                          t.enterLongitude ?? 'Enter longitude',
                                      icon: Icons.location_on,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _getMyLocation,
                                  icon: Icon(Icons.my_location, size: 18),
                                  label: Text(
                                    t.getMyLocation ?? 'Get My Location',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // File Attachment Section
                        _buildSectionTitle(
                            t.attachment ?? 'Attachment', Icons.attach_file),
                        const SizedBox(height: 12),
                        _buildFileAttachmentSection(t),
                        const SizedBox(height: 24),

                        // Government Level Selection
                        _buildSectionTitle(
                            t.submitTo + ' *', Icons.account_balance),
                        const SizedBox(height: 12),
                        _buildLevelSelection(levels, lang),
                        if (_levelError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 12),
                            child: Text(
                              t.pleaseSelectLevel,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 32),

                        // Submit Button
                        Obx(() => SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed:
                                    _complaintController.isSubmitting.value
                                        ? null
                                        : _submitComplaint,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  shadowColor: kPrimaryColor.withOpacity(0.5),
                                ),
                                child: _complaintController.isSubmitting.value
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.send, size: 22),
                                          SizedBox(width: 10),
                                          Text(
                                            t.submitComplaint,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: kPrimaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(
      List<Map<String, dynamic>> categories, String lang) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = _selectedCategory == category['value'];
        final label =
            lang == 'ne' ? category['label_ne'] : category['label_en'];

        // Show red border only if submitted and nothing is selected
        bool showError = _hasAttemptedSubmit && _selectedCategory == null;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category['value'];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? category['color'].withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: showError
                    ? Colors.red
                    : (isSelected ? category['color'] : Colors.grey[300]!),
                width: isSelected ? 2 : (showError ? 2 : 1),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: category['color'].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'],
                  color: isSelected ? category['color'] : Colors.grey[600],
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? category['color'] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrioritySelection(
      List<Map<String, dynamic>> priorities, String lang) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: priorities.map((priority) {
        final isSelected = _selectedPriority == priority['value'];
        final label =
            lang == 'ne' ? priority['label_ne'] : priority['label_en'];

        // Show red border only if submitted and nothing is selected
        bool showError = _hasAttemptedSubmit && _selectedPriority == null;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPriority = priority['value'];
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? priority['color'].withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: showError
                    ? Colors.red
                    : (isSelected ? priority['color'] : Colors.grey[300]!),
                width: isSelected ? 2 : (showError ? 2 : 1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  priority['icon'],
                  color: isSelected ? priority['color'] : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? priority['color'] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLevelSelection(List<Map<String, dynamic>> levels, String lang) {
    return Column(
      children: levels.map((level) {
        final isSelected = _selectedLevel == level['value'];
        final label = lang == 'ne' ? level['label_ne'] : level['label_en'];

        // Show red border only if submitted and nothing is selected
        bool showError = _hasAttemptedSubmit && _selectedLevel == null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedLevel = level['value'];
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: showError
                      ? Colors.red
                      : (isSelected ? kPrimaryColor : Colors.grey[300]!),
                  width: isSelected ? 2 : (showError ? 2 : 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryColor : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      level['icon'],
                      color: isSelected ? Colors.white : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? kPrimaryColor : Colors.grey[700],
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    Icon(Icons.check_circle, color: kPrimaryColor, size: 24),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFileAttachmentSection(dynamic t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_attachedFile == null) ...[
            Text(
              t.attachmentDescription ??
                  'Attach a file (PDF, JPG, PNG - Max 5MB)',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickFile,
                icon: Icon(Icons.attach_file),
                label: Text(t.chooseFile ?? 'Choose File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _attachedFile!.path.split('/').last,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${(_attachedFile!.lengthSync() / 1024).toStringAsFixed(1)} KB',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isPreviewable(_attachedFile!.path))
                    IconButton(
                      icon: Icon(Icons.visibility, color: kPrimaryColor),
                      onPressed: () => _previewDocument(_attachedFile!),
                      tooltip: t.preview ?? 'Preview',
                    ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: _removeFile,
                    tooltip: t.remove ?? 'Remove',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickFile,
                icon: Icon(Icons.refresh),
                label: Text(t.changeFile ?? 'Change File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    bool showPrefixIcon = true,
    bool alignLabelWithText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: alignLabelWithText,
          prefixIcon: showPrefixIcon && icon != null
              ? Icon(icon, color: kPrimaryColor)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kPrimaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
