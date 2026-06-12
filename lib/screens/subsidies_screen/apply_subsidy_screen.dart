import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/subsidy_controller..dart';
import 'package:smart_kishan/controllers/auth_controller.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/subsidies_screen/image_viewer_screen.dart';
import 'package:smart_kishan/screens/subsidies_screen/pdf_viewer_screen.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/models/subsidy.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/utils/custom_snackbar.dart';

class ApplySubsidyScreen extends StatefulWidget {
  const ApplySubsidyScreen({super.key});

  @override
  State<ApplySubsidyScreen> createState() => _ApplySubsidyScreenState();
}

class _ApplySubsidyScreenState extends State<ApplySubsidyScreen> {
  final TextEditingController notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Store dynamic form field controllers
  final Map<String, TextEditingController> _formFieldControllers = {};
  final Map<String, dynamic> _formFieldValues = {};

  // Store uploaded documents
  final Map<String, File?> _uploadedDocuments = {};
  bool _hasAttemptedSubmit = false;

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  bool _isPreviewable(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    return ['pdf', 'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp']
        .contains(extension);
  }

  void _previewDocument(File file, String title) {
    final extension = file.path.toLowerCase().split('.').last;

    if (extension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            pdfFile: file,
            title: title,
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
            title: title,
          ),
        ),
      );
    }
  }

  void _initializeFormFields() {
    final SubsidyController subsidyController = Get.find<SubsidyController>();
    final subsidy = subsidyController.selectedSubsidy.value;

    if (subsidy?.applicationFormFields != null) {
      for (var field in subsidy!.applicationFormFields!) {
        if (field.fieldKey != null) {
          // Create controller for text-based fields
          if (_needsController(field.fieldType)) {
            _formFieldControllers[field.fieldKey!] = TextEditingController();
          }

          // Prefill if needed
          if (field.isPrefilled && field.prefillSource != null) {
            _prefillField(field);
          }
        }
      }
    }
  }

  bool _needsController(String? fieldType) {
    return ['text', 'number', 'email', 'phone', 'textarea', 'date']
        .contains(fieldType);
  }

  void _prefillField(ApplicationFormField field) {
    try {
      final authController = Get.find<AuthController>();
      final user = authController.currentUser.value;

      if (user == null) return;

      String? prefillValue;

      switch (field.prefillSource) {
        case 'full_name':
          prefillValue = user.fullName;
          break;
        case 'email':
          prefillValue = user.emailAddress;
          break;
        case 'phone':
          prefillValue = user.phoneNumber;
          break;
        case 'province':
          prefillValue = user.province?.name?.get('en');
          break;
        case 'district':
          prefillValue = user.district?.name?.get('en');
          break;
        case 'municipality':
          prefillValue = user.municipality?.name?.get('en');
          break;
        case 'ward':
          prefillValue = user.ward?.name?.get('en');
          break;
        case 'address':
          prefillValue = user.fullAddress ?? user.address;
          break;
      }

      if (prefillValue != null && field.fieldKey != null) {
        if (_formFieldControllers.containsKey(field.fieldKey!)) {
          _formFieldControllers[field.fieldKey!]!.text = prefillValue;
        }
        _formFieldValues[field.fieldKey!] = prefillValue;
      }
    } catch (e) {
      print('Error prefilling field: $e');
      // AuthController not registered or user not available, skip prefilling
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    _formFieldControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _pickDocument(RequiredDocument doc) async {
    final t = translation(context);

    try {
      // Determine the file type based on accepted formats
      FileType fileType;
      List<String>? allowedExtensions;

      // Check if all formats are images
      bool allImages = doc.acceptedFormats.every((format) => [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'bmp',
            'webp',
            'heic'
          ].contains(format.toLowerCase()));

      // Check if all formats are PDFs
      bool allPdfs =
          doc.acceptedFormats.every((format) => format.toLowerCase() == 'pdf');

      if (allImages) {
        fileType = FileType.image;
      } else if (allPdfs) {
        fileType = FileType.custom;
        allowedExtensions = ['pdf'];
      } else {
        // Mixed types - use custom with specific extensions
        fileType = FileType.custom;
        allowedExtensions = doc.acceptedFormats;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions:
            fileType == FileType.custom ? allowedExtensions : null,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        // Get file extension
        String fileName = result.files.single.name;
        String fileExtension = fileName.split('.').last.toLowerCase();

        // Validate file type
        if (!doc.acceptedFormats.contains(fileExtension)) {
          CustomSnackbar.error(
            title: t.invalidFileType ?? 'Invalid File Type',
            message:
                'Please upload: ${doc.acceptedFormats.join(", ").toUpperCase()}',
          );
          return;
        }

        // Check file size
        int fileSizeInBytes = await file.length();
        int maxSizeInBytes = doc.maxFileSize * 1024 * 1024;

        if (fileSizeInBytes > maxSizeInBytes) {
          CustomSnackbar.error(
            title: t.fileTooLarge ?? 'File Too Large',
            message: 'Maximum file size is ${doc.maxFileSize} MB',
          );
          return;
        }

        setState(() {
          _uploadedDocuments[doc.name?.get('en') ?? ''] = file;
        });

        CustomSnackbar.success(
          title: t.uploaded ?? 'Uploaded',
          message: 'Document uploaded successfully',
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      CustomSnackbar.error(
        title: t.error ?? 'Error',
        message: 'Failed to pick file: ${e.toString()}',
      );
    }
  }

  void _removeDocument(String docName) {
    setState(() {
      _uploadedDocuments.remove(docName);
    });
  }

  void _submitApplication() async {
    setState(() {
      _hasAttemptedSubmit = true;
    });
    final t = translation(context);

    if (_formKey.currentState!.validate()) {
      final SubsidyController subsidyController = Get.find<SubsidyController>();
      final subsidy = subsidyController.selectedSubsidy.value;

      if (subsidy == null) {
        CustomSnackbar.error(
          title: t.error ?? 'Error',
          message: t.noSubsidySelected,
        );
        return;
      }

      // Validate required documents
      if (subsidy.requiredDocuments != null) {
        for (var doc in subsidy.requiredDocuments!) {
          if (doc.isRequired) {
            String docKey = doc.name?.get('en') ?? '';
            if (!_uploadedDocuments.containsKey(docKey) ||
                _uploadedDocuments[docKey] == null) {
              CustomSnackbar.warning(
                title: t.documentRequired ?? 'Document Required',
                message: '${doc.name?.get('en')} is required to proceed',
              );
              return;
            }
          }
        }
      }

      // Collect form field data
      Map<String, dynamic> formData = {};
      _formFieldControllers.forEach((key, controller) {
        formData[key] = controller.text;
      });
      formData.addAll(_formFieldValues);

      final success = await subsidyController.applyForSubsidy(
        subsidy.id!,
        notesController.text,
        documents: _uploadedDocuments,
        formData: formData,
      );

      if (success) {
        Get.until((route) => route.settings.name == AppRoute.subsidyScreen);
        CustomSnackbar.success(
          title: t.success ?? 'Success',
          message: t.applicationSuccessful,
        );
      } else {
        CustomSnackbar.error(
          title: t.failed ?? 'Failed',
          message: t.applicationFailed,
        );
      }
    } else {
      CustomSnackbar.warning(
        title: t.validationErrorMessage ?? 'Validation Error',
        message: t.pleaseCheckAllFields ?? 'Please check all required fields',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final SubsidyController subsidyController = Get.find<SubsidyController>();
    final subsidy = subsidyController.selectedSubsidy.value;
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final t = translation(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          t.applyForSubsidy,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: subsidy == null
          ? Center(child: Text(t.noSubsidySelected))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subsidy Info Card
                      _buildSubsidyInfoCard(subsidy, lang, t),

                      SizedBox(height: getProportionateScreenHeight(20)),

                      // Dynamic Form Fields Section
                      if (subsidy.applicationFormFields != null &&
                          subsidy.applicationFormFields!.isNotEmpty) ...[
                        _buildSectionTitle(
                            t.applicationForm ?? 'Application Form'),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        _buildDynamicFormFields(subsidy, lang, t),
                        SizedBox(height: getProportionateScreenHeight(20)),
                      ],

                      // Document Upload Section
                      if (subsidy.requiredDocuments != null &&
                          subsidy.requiredDocuments!.isNotEmpty) ...[
                        _buildSectionTitle(t.requiredDocumentsForApplication),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        _buildDocumentUploadSection(subsidy, lang, t),
                        SizedBox(height: getProportionateScreenHeight(20)),
                      ],

                      // Application Notes
                      _buildSectionTitle(t.applicationNotes),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        t.explainEligibility,
                        style: TextStyle(
                          fontSize: 13,
                          color: kCardDescColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      TextFormField(
                        controller: notesController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: t.enterNotes,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kPrimaryGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kPrimaryGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        // validator: (value) {
                        //   if (value == null || value.trim().isEmpty) {
                        //     return t.enterApplicationNotes;
                        //   }
                        //   if (value.trim().length < 10) {
                        //     return t.min10Characters;
                        //   }
                        //   return null;
                        // },
                      ),

                      SizedBox(height: getProportionateScreenHeight(30)),

                      // Important Note
                      _buildImportantNote(t),

                      SizedBox(height: getProportionateScreenHeight(30)),

                      // Submit Button
                      Obx(() => _buildSubmitButton(subsidyController, t)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSubsidyInfoCard(Subsidy subsidy, String lang, dynamic t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subsidy.title?.get(lang) ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          if (subsidy.description != null)
            Text(
              subsidy.description!.get(lang),
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                color: kCardDescColor,
              ),
            ),
        ],
      ),
    );
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

  Widget _buildDynamicFormFields(Subsidy subsidy, String lang, dynamic t) {
    return Column(
      children: subsidy.applicationFormFields!.map((field) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildFormField(field, lang, t),
        );
      }).toList(),
    );
  }

  Widget _buildFormField(ApplicationFormField field, String lang, dynamic t) {
    switch (field.fieldType) {
      case 'text':
      case 'email':
      case 'phone':
        return _buildTextFormField(field, lang, t);
      case 'number':
        return _buildNumberFormField(field, lang, t);
      case 'textarea':
        return _buildTextAreaFormField(field, lang, t);
      case 'date':
        return _buildDateFormField(field, lang, t);
      case 'dropdown':
        return _buildDropdownFormField(field, lang, t);
      case 'radio':
        return _buildRadioFormField(field, lang, t);
      case 'checkbox':
        return _buildCheckboxFormField(field, lang, t);
      default:
        return _buildTextFormField(field, lang, t);
    }
  }

  Widget _buildTextFormField(
      ApplicationFormField field, String lang, dynamic t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label?.get(lang) ?? '',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: _formFieldControllers[field.fieldKey],
          readOnly: field.isPrefilled && !field.prefillEditable,
          keyboardType: field.fieldType == 'email'
              ? TextInputType.emailAddress
              : field.fieldType == 'phone'
                  ? TextInputType.phone
                  : TextInputType.text,
          decoration: InputDecoration(
            hintText: field.placeholder?.get(lang),
            suffixIcon: field.isPrefilled && !field.prefillEditable
                ? Icon(Icons.lock_outline, color: Colors.grey)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
              vertical: getProportionateScreenHeight(12),
            ),
          ),
          validator: (value) {
            if (field.isRequired && (value == null || value.trim().isEmpty)) {
              return field.validationMessage?.get(lang) ??
                  '${field.label?.get(lang)} is required';
            }
            if (field.minLength != null && value!.length < field.minLength!) {
              return 'Minimum ${field.minLength} characters required';
            }
            if (field.maxLength != null && value!.length > field.maxLength!) {
              return 'Maximum ${field.maxLength} characters allowed';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNumberFormField(
      ApplicationFormField field, String lang, dynamic t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label?.get(lang) ?? '',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: _formFieldControllers[field.fieldKey],
          readOnly: field.isPrefilled && !field.prefillEditable,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: field.placeholder?.get(lang),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
              vertical: getProportionateScreenHeight(12),
            ),
          ),
          validator: (value) {
            if (field.isRequired && (value == null || value.trim().isEmpty)) {
              return field.validationMessage?.get(lang) ??
                  '${field.label?.get(lang)} is required';
            }
            if (value != null && value.isNotEmpty) {
              double? numValue = double.tryParse(value);
              if (numValue == null) {
                return 'Please enter a valid number';
              }
              if (field.minValue != null && numValue < field.minValue!) {
                return 'Minimum value is ${field.minValue}';
              }
              if (field.maxValue != null && numValue > field.maxValue!) {
                return 'Maximum value is ${field.maxValue}';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextAreaFormField(
      ApplicationFormField field, String lang, dynamic t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label?.get(lang) ?? '',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: _formFieldControllers[field.fieldKey],
          maxLines: 4,
          decoration: InputDecoration(
            hintText: field.placeholder?.get(lang),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
              vertical: getProportionateScreenHeight(12),
            ),
          ),
          validator: (value) {
            if (field.isRequired && (value == null || value.trim().isEmpty)) {
              return field.validationMessage?.get(lang) ??
                  '${field.label?.get(lang)} is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateFormField(
      ApplicationFormField field, String lang, dynamic t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label?.get(lang) ?? '',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: _formFieldControllers[field.fieldKey],
          readOnly: true,
          onTap: () async {
            // Get the currently selected date or use today as default
            DateTime initialDate = DateTime.now();

            if (_formFieldControllers[field.fieldKey]?.text.isNotEmpty ??
                false) {
              try {
                initialDate = DateFormat('yyyy-MM-dd')
                    .parse(_formFieldControllers[field.fieldKey]!.text);
              } catch (e) {
                // If parsing fails, use today's date
                initialDate = DateTime.now();
              }
            }

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              setState(() {
                _formFieldControllers[field.fieldKey]?.text = formattedDate;
                _formFieldValues[field.fieldKey!] = formattedDate;
              });
            }
          },
          decoration: InputDecoration(
            hintText: field.placeholder?.get(lang),
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
              vertical: getProportionateScreenHeight(12),
            ),
          ),
          validator: (value) {
            if (field.isRequired && (value == null || value.trim().isEmpty)) {
              return field.validationMessage?.get(lang) ??
                  '${field.label?.get(lang)} is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownFormField(
      ApplicationFormField field, String lang, dynamic t) {
    // Set default value if not already set and options exist
    if (field.fieldKey != null &&
        _formFieldValues[field.fieldKey] == null &&
        field.options != null &&
        field.options!.isNotEmpty &&
        field.options!.first.value != null) {
      _formFieldValues[field.fieldKey!] = field.options!.first.value!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label?.get(lang) ?? '',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownButtonFormField<String>(
          initialValue: _formFieldValues[field.fieldKey],
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kPrimaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
              vertical: getProportionateScreenHeight(12),
            ),
          ),
          items: field.options?.map((option) {
            return DropdownMenuItem<String>(
              value: option.value,
              child: Text(
                // Get label based on current language
                lang == 'ne'
                    ? (option.labelNe ?? option.labelEn ?? option.label ?? '')
                    : (option.labelEn ?? option.label ?? ''),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _formFieldValues[field.fieldKey!] = value;
            });
          },
          validator: (value) {
            if (field.isRequired && value == null) {
              return field.validationMessage?.get(lang) ??
                  '${field.label?.get(lang)} is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRadioFormField(
      ApplicationFormField field, String lang, dynamic t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label?.get(lang) ?? '',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        ...field.options!.map((option) {
          return RadioListTile<String>(
            title: Text(
              // Get label based on current language
              lang == 'ne'
                  ? (option.labelNe ?? option.labelEn ?? option.label ?? '')
                  : (option.labelEn ?? option.label ?? ''),
            ),
            value: option.value!,
            contentPadding: EdgeInsets.zero,
            groupValue: _formFieldValues[field.fieldKey],
            onChanged: (value) {
              setState(() {
                _formFieldValues[field.fieldKey!] = value;
              });
            },
            activeColor: kPrimaryColor,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCheckboxFormField(
      ApplicationFormField field, String lang, dynamic t) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(field.label?.get(lang) ?? ''),
      value: _formFieldValues[field.fieldKey] ?? false,
      onChanged: (value) {
        setState(() {
          _formFieldValues[field.fieldKey!] = value ?? false;
        });
      },
      activeColor: kPrimaryColor,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildDocumentUploadSection(Subsidy subsidy, String lang, dynamic t) {
    return Column(
      children: subsidy.requiredDocuments!.map((doc) {
        // Use consistent key - always use 'en' for storage
        String docKey = doc.name?.get('en') ?? '';
        String displayName = doc.name?.get(lang) ?? '';

        bool isUploaded = _uploadedDocuments.containsKey(docKey) &&
            _uploadedDocuments[docKey] != null;

        // Determine border color based on submission attempt and upload status
        Color borderColor;
        if (doc.isRequired && _hasAttemptedSubmit && !isUploaded) {
          borderColor =
              Colors.red; // Show red only after submit attempt if not uploaded
        } else {
          borderColor =
              Colors.grey.withOpacity(0.3); // Default grey for all other cases
        }

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isUploaded)
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                ],
              ),
              if (doc.description != null &&
                  doc.description!.get(lang).isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  doc.description!.get(lang),
                  style: TextStyle(
                    fontSize: 12,
                    color: kCardDescColor,
                  ),
                ),
              ],
              SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text(
                      doc.acceptedFormats.join(', ').toUpperCase(),
                      style: TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                  ),
                  SizedBox(width: 8),
                  Chip(
                    label: Text(
                      'Max ${doc.maxFileSize} MB',
                      style: TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.green.withOpacity(0.1),
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (isUploaded) ...[
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _uploadedDocuments[docKey]!.path.split('/').last,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Preview button
                      if (_isPreviewable(_uploadedDocuments[docKey]!.path))
                        IconButton(
                          icon: Icon(Icons.visibility,
                              color: kPrimaryColor, size: 20),
                          onPressed: () => _previewDocument(
                              _uploadedDocuments[docKey]!, displayName),
                          tooltip: 'Preview',
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red, size: 20),
                        onPressed: () => _removeDocument(docKey),
                        tooltip: 'Remove',
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _pickDocument(doc),
                  icon: Icon(isUploaded ? Icons.refresh : Icons.upload_file),
                  label: Text(
                    isUploaded ? t.changeFile : t.uploadFile,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUploaded ? Colors.orange : kPrimaryColor,
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
        );
      }).toList(),
    );
  }

  Widget _buildImportantNote(dynamic t) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange),
          SizedBox(width: getProportionateScreenWidth(10)),
          Expanded(
            child: Text(
              t.importantNote,
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(SubsidyController subsidyController, dynamic t) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed:
            subsidyController.isApplying.value ? null : _submitApplication,
        child: subsidyController.isApplying.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                t.submitApplication,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
