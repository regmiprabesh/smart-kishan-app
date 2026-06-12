import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/survey_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/models/survey.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/utils/custom_snackbar.dart';
import 'package:intl/intl.dart';

class TakeSurveyScreen extends StatefulWidget {
  const TakeSurveyScreen({super.key});

  @override
  State<TakeSurveyScreen> createState() => _TakeSurveyScreenState();
}

class _TakeSurveyScreenState extends State<TakeSurveyScreen> {
  final SurveyController surveyController = Get.find<SurveyController>();
  final _formKey = GlobalKey<FormState>();
  final Map<int, dynamic> answers = {};
  final Map<int, TextEditingController> textControllers = {};
  final Map<int, File?> uploadedFiles = {};
  bool hasAttemptedSubmit = false;
  bool isLoading = true;

  late DateTime surveyStartTime;

  @override
  void initState() {
    super.initState();
    surveyStartTime = DateTime.now();
    _loadSurveyDetails();
  }

  Future<void> _loadSurveyDetails() async {
    final survey = surveyController.selectedSurvey.value;
    if (survey != null &&
        (survey.questions == null || survey.questions!.isEmpty)) {
      final detailedSurvey =
          await surveyController.getSurveyDetails(survey.id!);
      if (detailedSurvey != null) {
        surveyController.selectedSurvey.value = detailedSurvey;
      }
    }
    _initializeControllers();
    setState(() {
      isLoading = false;
    });
  }

  void _initializeControllers() {
    final survey = surveyController.selectedSurvey.value;
    if (survey?.questions != null) {
      for (var question in survey!.questions!) {
        if (_needsController(question.questionType)) {
          textControllers[question.id!] = TextEditingController();
        }
      }
    }
  }

  bool _needsController(String? type) {
    return ['text', 'number', 'decimal', 'textarea'].contains(type);
  }

  @override
  void dispose() {
    textControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _pickFile(SurveyQuestion question) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        // Check file size (example: 5MB limit)
        int fileSizeInBytes = await file.length();
        int maxSizeInBytes = 5 * 1024 * 1024;

        if (fileSizeInBytes > maxSizeInBytes) {
          CustomSnackbar.error(
            title: l10n.fileTooLarge,
            message: l10n.maximumFileSize('5'),
          );
          return;
        }

        setState(() {
          uploadedFiles[question.id!] = file;
          answers[question.id!] = file.path;
        });

        CustomSnackbar.success(
          title: l10n.uploaded,
          message: l10n.fileUploaded,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      CustomSnackbar.error(
        title: l10n.error,
        message: l10n.failedToPickFile,
      );
    }
  }

  void _removeFile(int questionId) {
    setState(() {
      uploadedFiles.remove(questionId);
      answers.remove(questionId);
    });
  }

  void _submitSurvey() async {
    setState(() {
      hasAttemptedSubmit = true;
    });

    final survey = surveyController.selectedSurvey.value!;

    if (survey.questions == null || survey.questions!.isEmpty) {
      CustomSnackbar.error(
        title: l10n.error,
        message: l10n.noQuestionsFound,
      );
      return;
    }

    // Validate required questions
    for (var question in survey.questions!) {
      if (!question.shouldShow(answers)) continue;

      if (question.isRequired == true && !answers.containsKey(question.id)) {
        CustomSnackbar.warning(
          title: l10n.requiredQuestion,
          message: l10n.answerAllRequired,
        );
        return;
      }
    }

    if (_formKey.currentState!.validate()) {
      final success = await surveyController.submitSurveyResponse(
        survey.id!,
        answers,
        startedAt: surveyStartTime,
        completedAt: DateTime.now(),
      );

      if (success) {
        Get.back();
        CustomSnackbar.success(
          title: l10n.success,
          message: l10n.surveySubmittedSuccess,
        );
      } else {
        CustomSnackbar.error(
          title: l10n.failed,
          message: l10n.surveySubmitFailed,
        );
      }
    } else {
      CustomSnackbar.warning(
        title: l10n.validationError,
        message: l10n.checkRequiredFields,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final survey = surveyController.selectedSurvey.value;
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;

    if (survey == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            l10n.survey,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(child: Text(l10n.noSurveySelected)),
      );
    }

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            survey.title?.get(lang) ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: kPrimaryColor),
              SizedBox(height: 16),
              Text(
                l10n.loadingSurveyQuestions,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    if (survey.questions == null || survey.questions!.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            survey.title?.get(lang) ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.orange),
                SizedBox(height: 16),
                Text(
                  l10n.noQuestionsAvailable,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.goBack),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Separate questions by type
    final regularQuestions = survey.questions!
        .where((q) =>
            q.questionType != 'file_upload' && q.questionType != 'location')
        .toList();
    final fileUploadQuestions = survey.questions!
        .where((q) => q.questionType == 'file_upload')
        .toList();
    final locationQuestions =
        survey.questions!.where((q) => q.questionType == 'location').toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          survey.title?.get(lang) ?? '',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simple Survey Info
              _buildSurveyHeader(survey, lang),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Regular Questions Card
                    if (regularQuestions.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...regularQuestions.asMap().entries.map((entry) {
                              final index = entry.key;
                              final question = entry.value;
                              if (!question.shouldShow(answers))
                                return SizedBox.shrink();
                              return Column(
                                children: [
                                  if (index > 0)
                                    Divider(height: 32, thickness: 1),
                                  _buildQuestionContent(question, lang),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(16)),
                    ],

                    // File Upload Questions Card
                    if (fileUploadQuestions.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.upload_file,
                                    color: kPrimaryColor, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  l10n.fileUploads,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: kCardTitleColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ...fileUploadQuestions.asMap().entries.map((entry) {
                              final index = entry.key;
                              final question = entry.value;
                              if (!question.shouldShow(answers))
                                return SizedBox.shrink();
                              return Column(
                                children: [
                                  if (index > 0)
                                    Divider(height: 32, thickness: 1),
                                  _buildFileUploadQuestion(question, lang),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(16)),
                    ],

                    // Location Questions Card
                    if (locationQuestions.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: kPrimaryColor, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  l10n.locationInformation,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: kCardTitleColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ...locationQuestions.asMap().entries.map((entry) {
                              final index = entry.key;
                              final question = entry.value;
                              if (!question.shouldShow(answers))
                                return SizedBox.shrink();
                              return Column(
                                children: [
                                  if (index > 0)
                                    Divider(height: 32, thickness: 1),
                                  _buildLocationQuestion(question, lang),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(16)),
                    ],

                    SizedBox(height: getProportionateScreenHeight(8)),

                    // Important Note
                    _buildImportantNote(),

                    SizedBox(height: getProportionateScreenHeight(30)),

                    // Submit Button
                    Obx(() => _buildSubmitButton()),

                    SizedBox(height: getProportionateScreenHeight(20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurveyHeader(Survey survey, String lang) {
    return Column(
      children: [
        // Title section with chips overlaid on green background
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                survey.title?.get(lang) ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              // Chips row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    Icons.quiz,
                    l10n.questionsCount(
                        localizedNumber(survey.totalQuestions ?? 0)),
                    Colors.white,
                  ),
                  if (survey.estimatedDurationMinutes != null)
                    _buildInfoChip(
                      Icons.timer,
                      l10n.estimatedMinutes(
                          localizedNumber(survey.estimatedDurationMinutes!)),
                      Colors.white,
                    ),
                  if (survey.isMandatory == true)
                    _buildInfoChip(
                      Icons.star,
                      l10n.requiredLabel,
                      Colors.white,
                    ),
                ],
              ),
            ],
          ),
        ),

        // Overlapping description card
        Transform.translate(
          offset: Offset(0, -30),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description title
                Text(
                  l10n.description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                // Description text
                if (survey.description != null)
                  Text(
                    survey.description!.get(lang),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),

                SizedBox(height: 16),

                // Eligibility criteria section
                Text(
                  l10n.instruction,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    survey.instructions?.get(lang) ?? l10n.defaultEligibility,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(SurveyQuestion question, String lang) {
    // Determine border color for validation
    bool showError = hasAttemptedSubmit &&
        question.isRequired == true &&
        !answers.containsKey(question.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Text with required indicator
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.isRequired == true)
              Text(
                '* ',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Expanded(
              child: Text(
                question.questionText?.get(lang) ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: showError ? Colors.red : Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),

        // Help text (only if available)
        if (question.helpText != null &&
            question.helpText!.get(lang).isNotEmpty) ...[
          SizedBox(height: 8),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[700]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.helpText!.get(lang),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[900],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        SizedBox(height: 16),

        // Question input
        _buildQuestionInput(question, lang),
      ],
    );
  }

  Widget _buildQuestionInput(SurveyQuestion question, String lang) {
    switch (question.questionType) {
      case 'text':
      case 'textarea':
        return _buildTextInput(question);
      case 'number':
      case 'decimal':
        return _buildNumberInput(question);
      case 'single_choice':
        return _buildSingleChoice(question, lang);
      case 'multiple_choice':
        return _buildMultipleChoice(question, lang);
      case 'dropdown':
        return _buildDropdown(question, lang);
      case 'date':
        return _buildDatePicker(question, lang);
      case 'yes_no':
        return _buildYesNo(question, lang);
      case 'rating':
        return _buildRating(question);
      default:
        return _buildTextInput(question);
    }
  }

  Widget _buildTextInput(SurveyQuestion question) {
    return TextFormField(
      controller: textControllers[question.id],
      onChanged: (value) => answers[question.id!] = value,
      maxLines: question.questionType == 'textarea' ? 4 : 1,
      maxLength: question.maxLength,
      decoration: InputDecoration(
        hintText: l10n.enterYourAnswer,
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
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenHeight(12),
        ),
      ),
      validator: (value) {
        if (question.isRequired == true && (value == null || value.isEmpty)) {
          return l10n.fieldRequired;
        }
        if (question.minLength != null &&
            value != null &&
            value.length < question.minLength!) {
          return l10n
              .minCharactersRequired(localizedNumber(question.minLength!));
        }
        return null;
      },
    );
  }

  Widget _buildNumberInput(SurveyQuestion question) {
    return TextFormField(
      controller: textControllers[question.id],
      keyboardType: TextInputType.numberWithOptions(
        decimal: question.questionType == 'decimal',
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          answers[question.id!] = question.questionType == 'decimal'
              ? double.tryParse(value) ?? 0.0
              : int.tryParse(value) ?? 0;
        }
      },
      decoration: InputDecoration(
        hintText: l10n.enterNumber,
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
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenHeight(12),
        ),
      ),
      validator: (value) {
        if (question.isRequired == true && (value == null || value.isEmpty)) {
          return l10n.fieldRequired;
        }
        if (value != null && value.isNotEmpty) {
          final num = question.questionType == 'decimal'
              ? double.tryParse(value)
              : int.tryParse(value);
          if (num == null) return l10n.enterValidNumber;
          if (question.minValue != null && num < question.minValue!) {
            return l10n.minValueIs(localizedNumber(question.minValue!));
          }
          if (question.maxValue != null && num > question.maxValue!) {
            return l10n.maxValueIs(localizedNumber(question.maxValue!));
          }
        }
        return null;
      },
    );
  }

  Widget _buildSingleChoice(SurveyQuestion question, String lang) {
    return Column(
      children: question.options!.map((option) {
        final isSelected = answers[question.id] == option.value;
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? kPrimaryColor : kPrimaryGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: RadioListTile<String>(
            title: Text(
              option.getLabel(lang),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            value: option.value!,
            groupValue: answers[question.id],
            onChanged: (value) {
              setState(() {
                answers[question.id!] = value;
              });
            },
            activeColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoice(SurveyQuestion question, String lang) {
    if (!answers.containsKey(question.id)) {
      answers[question.id!] = <String>[];
    }

    return Column(
      children: question.options!.map((option) {
        final isSelected =
            (answers[question.id] as List).contains(option.value);
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? kPrimaryColor : kPrimaryGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: CheckboxListTile(
            title: Text(
              option.getLabel(lang),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            value: isSelected,
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  (answers[question.id!] as List).add(option.value);
                } else {
                  (answers[question.id!] as List).remove(option.value);
                }
              });
            },
            activeColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown(SurveyQuestion question, String lang) {
    return DropdownButtonFormField<String>(
      value: answers[question.id],
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
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenHeight(12),
        ),
      ),
      hint: Text(l10n.selectOption),
      items: question.options!.map((option) {
        return DropdownMenuItem<String>(
          value: option.value,
          child: Text(option.getLabel(lang)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          answers[question.id!] = value;
        });
      },
      validator: (value) {
        if (question.isRequired == true && value == null) {
          return l10n.pleaseSelectOption;
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker(SurveyQuestion question, String lang) {
    final selectedDate = answers[question.id] as DateTime?;

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: kPrimaryColor,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          setState(() {
            answers[question.id!] = date;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPrimaryGrey),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: kPrimaryColor, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate != null
                    ? DateFormat('MMM dd, yyyy', localeCode)
                        .format(selectedDate)
                    : l10n.selectDate,
                style: TextStyle(
                  fontSize: 15,
                  color:
                      selectedDate != null ? Colors.black87 : Colors.grey[600],
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildYesNo(SurveyQuestion question, String lang) {
    return Row(
      children: [
        Expanded(
          child:
              _buildYesNoButton(question, true, l10n.yes, Icons.check_circle),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildYesNoButton(question, false, l10n.no, Icons.cancel),
        ),
      ],
    );
  }

  Widget _buildYesNoButton(
      SurveyQuestion question, bool value, String label, IconData icon) {
    final isSelected = answers[question.id] == value;
    return InkWell(
      onTap: () {
        setState(() {
          answers[question.id!] = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? kPrimaryColor : kPrimaryGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating(SurveyQuestion question) {
    final maxRating = question.maxValue?.toInt() ?? 5;
    final currentRating = answers[question.id] as int? ?? 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(maxRating, (index) {
              final rating = index + 1;
              return IconButton(
                icon: Icon(
                  rating <= currentRating ? Icons.star : Icons.star_border,
                  size: 40,
                ),
                color: Colors.amber,
                onPressed: () {
                  setState(() {
                    answers[question.id!] = rating;
                  });
                },
              );
            }),
          ),
          if (currentRating > 0)
            Text(
              l10n.ratingOutOf(
                  localizedNumber(currentRating), localizedNumber(maxRating)),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFileUploadQuestion(SurveyQuestion question, String lang) {
    bool showError = hasAttemptedSubmit &&
        question.isRequired == true &&
        !answers.containsKey(question.id);

    final isUploaded = uploadedFiles.containsKey(question.id) &&
        uploadedFiles[question.id] != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Text
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.isRequired == true)
              Text(
                '* ',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Expanded(
              child: Text(
                question.questionText?.get(lang) ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: showError ? Colors.red : Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),

        // Help text
        if (question.helpText != null &&
            question.helpText!.get(lang).isNotEmpty) ...[
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.helpText!.get(lang),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[900],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        SizedBox(height: 12),

        // File format info
        Row(
          children: [
            Chip(
              label: Text(
                l10n.allowedFileFormats,
                style: TextStyle(fontSize: 10),
              ),
              backgroundColor: Colors.blue.withOpacity(0.1),
            ),
            SizedBox(width: 8),
            Chip(
              label: Text(
                l10n.maxFileSizeLabel,
                style: TextStyle(fontSize: 10),
              ),
              backgroundColor: Colors.green.withOpacity(0.1),
            ),
          ],
        ),

        SizedBox(height: 12),

        // Uploaded file display
        if (isUploaded) ...[
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    uploadedFiles[question.id]!.path.split('/').last,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red, size: 20),
                  onPressed: () => _removeFile(question.id!),
                  tooltip: l10n.remove,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],

        // Upload button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _pickFile(question),
            icon: Icon(isUploaded ? Icons.refresh : Icons.upload_file),
            label: Text(
              isUploaded ? l10n.changeFile : l10n.uploadFile,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUploaded ? Colors.orange : kPrimaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationQuestion(SurveyQuestion question, String lang) {
    bool showError = hasAttemptedSubmit &&
        question.isRequired == true &&
        !answers.containsKey(question.id);

    // For now, storing as a simple object with lat/lng
    final selectedLocation = answers[question.id] as Map<String, dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Text
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.isRequired == true)
              Text(
                '* ',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Expanded(
              child: Text(
                question.questionText?.get(lang) ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: showError ? Colors.red : Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),

        // Help text
        if (question.helpText != null &&
            question.helpText!.get(lang).isNotEmpty) ...[
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.helpText!.get(lang),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[900],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        SizedBox(height: 12),

        // Location display
        if (selectedLocation != null) ...[
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.latLngLabel(
                      selectedLocation['lat']?.toStringAsFixed(6) ?? '',
                      selectedLocation['lng']?.toStringAsFixed(6) ?? '',
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red, size: 20),
                  onPressed: () {
                    setState(() {
                      answers.remove(question.id);
                    });
                  },
                  tooltip: l10n.remove,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],

        // Location selection buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  // TODO: Implement current location picker
                  // For now, using dummy coordinates
                  setState(() {
                    answers[question.id!] = {
                      'lat': 27.7172,
                      'lng': 85.3240,
                    };
                  });
                  CustomSnackbar.success(
                    title: l10n.locationSet,
                    message: l10n.currentLocationSet,
                    duration: Duration(seconds: 2),
                  );
                },
                icon: Icon(Icons.my_location, size: 18),
                label: Text(
                  l10n.currentLocation,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  // TODO: Implement map picker
                  CustomSnackbar.info(
                    title: l10n.comingSoon,
                    message: l10n.mapPickerComingSoon,
                    duration: Duration(seconds: 2),
                  );
                },
                icon: Icon(Icons.map, size: 18),
                label: Text(
                  l10n.chooseOnMap,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: kPrimaryColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImportantNote() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.importantNoteLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  l10n.surveyImportantNote,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: surveyController.isSubmitting.value ? null : _submitSurvey,
        child: surveyController.isSubmitting.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    l10n.submitting,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, size: 20),
                  SizedBox(width: 8),
                  Text(
                    l10n.submitSurvey,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
