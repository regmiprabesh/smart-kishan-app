import 'dart:convert';
import 'package:get/get.dart';
import 'package:smart_kishan/models/survey.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/surveys/services/remote_survey_service.dart';

class SurveyController extends GetxController {
  static SurveyController instance = Get.find();

  RxList<Survey> availableSurveys = List<Survey>.empty(growable: true).obs;
  RxList<Survey> mandatorySurveys = List<Survey>.empty(growable: true).obs;

  Rx<Survey?> selectedSurvey = Rx<Survey?>(null);

  RxBool isSurveysLoading = false.obs;
  RxBool isSubmitting = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getAvailableSurveys();
  }

  @override
  void onClose() {
    availableSurveys.clear();
    mandatorySurveys.clear();
    super.onClose();
  }

  // Get all available surveys for farmer
  Future<void> getAvailableSurveys() async {
    try {
      isSurveysLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteSurveyService().getSurveys(token: token!);

      print('=== Survey Response ===');
      print('Status Code: ${result.statusCode}');
      print('Response Body: ${result.body}');

      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        final surveys = surveyListFromJson(jsonEncode(body['data']));

        print('Total surveys received: ${surveys.length}');
        surveys.forEach((s) {
          print(
              'Survey: ${s.title?.en}, Has Responded: ${s.hasResponded}, Can Respond: ${s.canRespond}');
        });

        availableSurveys.assignAll(surveys);

        // Separate mandatory surveys
        mandatorySurveys.assignAll(surveys
            .where((s) => s.isMandatory == true && s.hasResponded == false)
            .toList());

        print('Available surveys: ${availableSurveys.length}');
        print('Mandatory surveys: ${mandatorySurveys.length}');
      }
    } catch (e) {
      print('Error fetching surveys: $e');
    } finally {
      isSurveysLoading(false);
    }
  }

  // Submit survey response
  Future<bool> submitSurveyResponse(
    int surveyId,
    Map<int, dynamic> answers, {
    required DateTime startedAt,
    required DateTime completedAt,
  }) async {
    try {
      isSubmitting(true);
      String? token = await _localAuthService.getToken();

      var result = await RemoteSurveyService().submitResponse(
        token: token!,
        surveyId: surveyId,
        answers: answers,
        startedAt: startedAt,
        completedAt: completedAt,
      );
      print(result.body);
      return false;
      if (result.statusCode == 200 || result.statusCode == 201) {
        // Refresh surveys to update hasResponded status
        await getAvailableSurveys();
        return true;
      }
    } catch (e) {
      print('Error submitting survey: $e');
    } finally {
      isSubmitting(false);
    }
    return false;
  }

  // Get survey details with questions
  Future<Survey?> getSurveyDetails(int surveyId) async {
    try {
      String? token = await _localAuthService.getToken();
      var result = await RemoteSurveyService().getSurveyDetails(
        token: token!,
        surveyId: surveyId,
      );

      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        return Survey.fromJson(body['data']);
      }
    } catch (e) {
      print('Error fetching survey details: $e');
    }
    return null;
  }

  void reset() {
    availableSurveys.clear();
    mandatorySurveys.clear();
    selectedSurvey.value = null;
    isSurveysLoading(false);
    isSubmitting(false);
  }
}
