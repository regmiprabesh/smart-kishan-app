import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:smart_kishan/models/complaint.dart';
import 'package:smart_kishan/screens/complaints/services/remote_complaint_service.dart';

class ComplaintController extends GetxController {
  static ComplaintController instance = Get.find();

  RxList<Complaint> myComplaints = List<Complaint>.empty(growable: true).obs;
  Rx<Complaint?> selectedComplaint = Rx<Complaint?>(null);

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool isAddingComment = false.obs;
  RxBool isLoadingDetails = false.obs;

  @override
  void onInit() async {
    super.onInit();
    getMyComplaints();
  }

  @override
  void onClose() {
    myComplaints.clear();
    super.onClose();
  }

  // Get user's complaints
  Future<void> getMyComplaints() async {
    try {
      isLoading(true);
      var result = await RemoteComplaintService().getMyComplaints();

      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        myComplaints.assignAll(complaintListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      print('Error fetching complaints: $e');
    } finally {
      isLoading(false);
    }
  }

  // Get single complaint details with activities and comments
  Future<void> getComplaintDetails(int complaintId) async {
    try {
      isLoadingDetails(true);
      var result = await RemoteComplaintService().getComplaintDetails(
        complaintId: complaintId,
      );

      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        selectedComplaint.value = Complaint.fromJson(body['data']);
      }
    } catch (e) {
      print('Error fetching complaint details: $e');
    } finally {
      isLoadingDetails(false);
    }
  }

  // Submit new complaint
  Future<bool> submitComplaint({
    required String title,
    required String description,
    required String category,
    required String priority,
    required String submittedToLevel,
    String? specificLocation,
    double? latitude,
    double? longitude,
    File? attachmentFile,
  }) async {
    try {
      isSubmitting(true);

      var result = await RemoteComplaintService().submitComplaint(
        title: title,
        description: description,
        category: category,
        priority: priority,
        submittedToLevel: submittedToLevel,
        specificLocation: specificLocation,
        latitude: latitude,
        longitude: longitude,
        attachmentFile: attachmentFile,
      );

      if (result.statusCode == 201) {
        await getMyComplaints();
        return true;
      }
    } catch (e) {
      print('Error submitting complaint: $e');
    } finally {
      isSubmitting(false);
    }
    return false;
  }

  // Add comment
  Future<bool> addComment({
    required int complaintId,
    required String comment,
  }) async {
    try {
      isAddingComment(true);

      var result = await RemoteComplaintService().addComment(
        complaintId: complaintId,
        comment: comment,
      );
      print(result.body);
      if (result.statusCode == 201) {
        // Refresh complaint details to get new comment
        await getComplaintDetails(complaintId);
        return true;
      }
    } catch (e) {
      print('Error adding comment: $e');
    } finally {
      isAddingComment(false);
    }
    return false;
  }

  // Cancel/Delete a pending complaint
  Future<bool> cancelComplaint(int complaintId) async {
    try {
      var result = await RemoteComplaintService().cancelComplaint(
        complaintId: complaintId,
      );

      if (result.statusCode == 200) {
        await getMyComplaints();
        return true;
      }
    } catch (e) {
      print('Error cancelling complaint: $e');
    }
    return false;
  }

  // Filter complaints by status
  List<Complaint> getComplaintsByStatus(String status) {
    return myComplaints.where((c) => c.status == status).toList();
  }

  // Filter complaints by priority
  List<Complaint> getComplaintsByPriority(String priority) {
    return myComplaints.where((c) => c.priority == priority).toList();
  }

  // Get pending complaints count
  int getPendingCount() {
    return myComplaints.where((c) => c.status == 'pending').length;
  }

  // Get resolved complaints count
  int getResolvedCount() {
    return myComplaints.where((c) => c.status == 'resolved').length;
  }

  void reset() {
    myComplaints.clear();
    selectedComplaint.value = null;
    isLoading(false);
    isSubmitting(false);
    isAddingComment(false);
  }
}
