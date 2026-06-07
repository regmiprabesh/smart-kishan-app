import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:smart_kishan/models/subsidy.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/subsidies_screen/services/remote_subsidy_service.dart';

class SubsidyController extends GetxController {
  static SubsidyController instance = Get.find();

  RxList<Subsidy> subsidies = List<Subsidy>.empty(growable: true).obs;
  RxList<Subsidy> myApplications = List<Subsidy>.empty(growable: true).obs;

  Rx<Subsidy?> selectedSubsidy = Rx<Subsidy?>(null);

  RxBool isSubsidiesLoading = false.obs;
  RxBool isApplying = false.obs;
  RxBool isRating = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getSubsidies();
  }

  @override
  void onClose() {
    subsidies.clear();
    myApplications.clear();
    super.onClose();
  }

  // Get all available subsidies for farmer
  Future<void> getSubsidies() async {
    try {
      isSubsidiesLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteSubsidyService().getSubsidies(token: token!);
      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        subsidies.assignAll(subsidyListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      print('Error fetching subsidies: $e');
    } finally {
      isSubsidiesLoading(false);
    }
  }

  // Get subsidies user has applied to
  Future<void> getMyApplications() async {
    try {
      isSubsidiesLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteSubsidyService().getMyApplications(token: token!);
      print(result.body);
      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        myApplications.assignAll(subsidyListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      print('Error fetching applications: $e');
    } finally {
      isSubsidiesLoading(false);
    }
  }

  // Apply for subsidy with documents and form data
  Future<bool> applyForSubsidy(
    int subsidyId,
    String applicationNotes, {
    Map<String, File?>? documents,
    Map<String, dynamic>? formData,
  }) async {
    try {
      isApplying(true);
      String? token = await _localAuthService.getToken();

      var result = await RemoteSubsidyService().applyForSubsidy(
        token: token!,
        subsidyId: subsidyId,
        notes: applicationNotes,
        documents: documents,
        formData: formData,
      );

      if (result.statusCode == 200) {
        // Refresh subsidies to update hasApplied status
        await getSubsidies();
        return true;
      }
    } catch (e) {
      print('Error applying for subsidy: $e');
    } finally {
      isApplying(false);
    }
    return false;
  }

  // Withdraw application
  Future<bool> withdrawApplication(int subsidyId) async {
    try {
      String? token = await _localAuthService.getToken();

      var result = await RemoteSubsidyService().withdrawApplication(
        token: token!,
        subsidyId: subsidyId,
      );

      if (result.statusCode == 200) {
        await getSubsidies();
        await getMyApplications();
        return true;
      }
    } catch (e) {
      print('Error withdrawing application: $e');
    }
    return false;
  }

  // Rate a subsidy
  Future<bool> rateSubsidy(
    int subsidyId,
    int rating, {
    String? review,
  }) async {
    try {
      isRating(true);
      String? token = await _localAuthService.getToken();

      var result = await RemoteSubsidyService().rateSubsidy(
        token: token!,
        subsidyId: subsidyId,
        rating: rating,
        review: review,
      );
      print(result.body);
      if (result.statusCode == 200) {
        // Refresh subsidies to update ratings
        await getSubsidies();
        return true;
      }
    } catch (e) {
      print('Error rating subsidy: $e');
    } finally {
      isRating(false);
    }
    return false;
  }

  // Get user's rating for a subsidy
  Future<Map<String, dynamic>?> getUserRating(int subsidyId) async {
    try {
      String? token = await _localAuthService.getToken();

      var result = await RemoteSubsidyService().getUserRating(
        token: token!,
        subsidyId: subsidyId,
      );

      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        return body['data'];
      }
    } catch (e) {
      print('Error fetching user rating: $e');
    }
    return null;
  }

  // Delete user's rating
  Future<bool> deleteRating(int subsidyId) async {
    try {
      String? token = await _localAuthService.getToken();

      var result = await RemoteSubsidyService().deleteRating(
        token: token!,
        subsidyId: subsidyId,
      );

      if (result.statusCode == 200) {
        await getSubsidies();
        return true;
      }
    } catch (e) {
      print('Error deleting rating: $e');
    }
    return false;
  }

  void reset() {
    subsidies.clear();
    myApplications.clear();
    selectedSubsidy.value = null;
    isSubsidiesLoading(false);
    isRating(false);
  }
}
