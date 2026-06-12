import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/controllers/subsidy_request_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';

class RequestSubsidyScreen extends StatefulWidget {
  const RequestSubsidyScreen({Key? key}) : super(key: key);

  @override
  _RequestSubsidyScreenState createState() => _RequestSubsidyScreenState();
}

class _RequestSubsidyScreenState extends State<RequestSubsidyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController justificationController = TextEditingController();
  final TextEditingController targetCropController = TextEditingController();

  String? selectedCategory;
  String? selectedLevel;
  bool isSubmitting = false;

  final SubsidyRequestController requestController =
      Get.put(SubsidyRequestController());

  List<Map<String, String>> getCategories(BuildContext context) {
    final t = translation(context);
    return [
      {'value': 'fertilizer', 'label': t.fertilizer},
      {'value': 'equipment', 'label': t.equipment},
      {'value': 'training', 'label': t.training},
      {'value': 'irrigation', 'label': t.irrigation},
      {'value': 'livestock', 'label': t.livestock},
      {'value': 'seeds', 'label': t.seeds},
      {'value': 'insurance', 'label': t.insurance},
      {'value': 'loan', 'label': t.loan},
      {'value': 'other', 'label': t.general},
    ];
  }

  List<Map<String, String>> getLevels(BuildContext context) {
    final t = translation(context);
    return [
      {'value': 'ward', 'label': t.wardLevel},
      {'value': 'municipality', 'label': t.municipalityLevel},
      {'value': 'district', 'label': t.districtLevel},
      {'value': 'province', 'label': t.provinceLevel},
      {'value': 'central', 'label': t.central},
    ];
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null || selectedLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(translation(context).pleaseSelectAll),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final success = await requestController.submitRequest(
      titleEn: titleController.text.trim(),
      descriptionEn: descriptionController.text.trim(),
      subsidyType: selectedCategory!,
      targetCropEn: targetCropController.text.trim().isEmpty
          ? null
          : targetCropController.text.trim(),
      justificationEn: justificationController.text.trim(),
      requestedToLevel: selectedLevel!,
    );

    setState(() {
      isSubmitting = false;
    });

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  translation(context).subsidyRequestSubmitted,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(16),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translation(context).requestFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = translation(context);
    final categories = getCategories(context);
    final levels = getLevels(context);

    selectedCategory ??= categories[0]['value'];
    selectedLevel ??= levels[0]['value'];

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar with gradient
              SliverAppBar(
                expandedHeight: 160,
                floating: false,
                pinned: true,
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    t.requestNewSubsidy,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green[400]!,
                          Colors.green[600]!,
                          Colors.green[700]!,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -50,
                          top: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -30,
                          bottom: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Form content
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                  ),
                  padding: EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      // Info card at top
                      Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.blue[700],
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.requestSubsidyHint,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    t.requestInfo,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form card
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section: Basic Information
                              _buildSectionHeader(
                                icon: Icons.edit_document,
                                title: l10n.basicInformation,
                                color: Colors.green,
                              ),
                              SizedBox(height: 20),

                              // Title
                              _buildTextField(
                                controller: titleController,
                                label: t.subsidyTitle,
                                hint: t.enterTitle,
                                icon: Icons.title,
                                enabled: !isSubmitting,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return t.pleaseEnterTitle;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),

                              // Category
                              _buildDropdown(
                                value: selectedCategory,
                                label: t.category,
                                icon: Icons.category,
                                items: categories,
                                enabled: !isSubmitting,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCategory = newValue;
                                  });
                                },
                              ),
                              SizedBox(height: 20),

                              // Target Crop
                              _buildTextField(
                                controller: targetCropController,
                                label: t.targetCrop,
                                hint: t.enterTargetCrop,
                                icon: Icons.grass,
                                enabled: !isSubmitting,
                                isOptional: true,
                              ),
                              SizedBox(height: 32),

                              // Section: Details
                              _buildSectionHeader(
                                icon: Icons.description,
                                title: l10n.requestDetails,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 20),

                              // Description
                              _buildTextField(
                                controller: descriptionController,
                                label: t.descriptionLabel,
                                hint: t.descriptionHint,
                                icon: Icons.description,
                                enabled: !isSubmitting,
                                maxLines: 4,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return t.pleaseEnterDescription;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),

                              // Justification
                              _buildTextField(
                                controller: justificationController,
                                label: t.justification,
                                hint: t.justificationHint,
                                icon: Icons.help_outline,
                                enabled: !isSubmitting,
                                maxLines: 5,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return t.pleaseEnterJustification;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 32),

                              // Section: Request Target
                              _buildSectionHeader(
                                icon: Icons.location_city,
                                title: l10n.requestTarget,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 20),

                              // Request To Level
                              _buildDropdown(
                                value: selectedLevel,
                                label: t.requestTo,
                                icon: Icons.location_city,
                                items: levels,
                                enabled: !isSubmitting,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLevel = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // Fixed bottom action buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      isSubmitting ? null : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    t.cancel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isSubmitting
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, size: 20),
                            SizedBox(width: 10),
                            Text(
                              t.submitRequest,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required MaterialColor color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color[700], size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 12),
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool enabled,
    int maxLines = 1,
    bool isOptional = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.grey[500]),
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.grey[500]),
        prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.green[600]) : null,
        suffixText: isOptional ? 'Optional' : null,
        suffixStyle: TextStyle(fontSize: 11, color: Colors.grey[500]),
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
          borderSide: BorderSide(color: Colors.green[600]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required List<Map<String, String>> items,
    required bool enabled,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green[600]),
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
          borderSide: BorderSide(color: Colors.green[600]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item['value'],
          child: Text(item['label']!),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    justificationController.dispose();
    targetCropController.dispose();
    super.dispose();
  }
}
