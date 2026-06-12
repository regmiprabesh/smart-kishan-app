import 'dart:convert';
import 'package:get/get.dart';
import 'package:smart_kishan/models/subsidyRequest.dart';
import 'package:smart_kishan/screens/subsidy_requests/services/remote_subsidy_request_service.dart';

class SubsidyRequestController extends GetxController {
  static SubsidyRequestController instance = Get.find();

  RxList<SubsidyRequest> myRequests =
      List<SubsidyRequest>.empty(growable: true).obs;
  Rx<SubsidyRequest?> selectedRequest = Rx<SubsidyRequest?>(null);

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;

  @override
  void onInit() async {
    super.onInit();
    getMyRequests();
  }

  @override
  void onClose() {
    myRequests.clear();
    super.onClose();
  }

  // Get user's subsidy requests
  Future<void> getMyRequests() async {
    try {
      isLoading(true);
      var result = await RemoteSubsidyRequestService().getMyRequests();

      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        myRequests
            .assignAll(subsidyRequestListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      print('Error fetching requests: $e');
    } finally {
      isLoading(false);
    }
  }

  // Submit new subsidy request
  Future<bool> submitRequest({
    required String titleEn,
    String? titleNe,
    required String descriptionEn,
    String? descriptionNe,
    required String subsidyType,
    String? targetCropEn,
    String? targetCropNe,
    required String justificationEn,
    String? justificationNe,
    required String requestedToLevel,
  }) async {
    try {
      isSubmitting(true);

      var result = await RemoteSubsidyRequestService().submitRequest(
        titleEn: titleEn,
        titleNe: titleNe,
        descriptionEn: descriptionEn,
        descriptionNe: descriptionNe,
        subsidyType: subsidyType,
        targetCropEn: targetCropEn,
        targetCropNe: targetCropNe,
        justificationEn: justificationEn,
        justificationNe: justificationNe,
        requestedToLevel: requestedToLevel,
      );

      if (result.statusCode == 201) {
        await getMyRequests();
        return true;
      }
    } catch (e) {
      print('Error submitting request: $e');
    } finally {
      isSubmitting(false);
    }
    return false;
  }

  // Cancel/Delete a pending request
  Future<bool> cancelRequest(int requestId) async {
    try {
      var result = await RemoteSubsidyRequestService().cancelRequest(
        requestId: requestId,
      );

      if (result.statusCode == 200) {
        await getMyRequests();
        return true;
      }
    } catch (e) {
      print('Error cancelling request: $e');
    }
    return false;
  }

  void reset() {
    myRequests.clear();
    selectedRequest.value = null;
    isLoading(false);
    isSubmitting(false);
  }
}
