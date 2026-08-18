part of 'candidate_detail_view.dart';

class CandidateDetailViewController extends GetxController {
  late ApplicantModel applicant;
  late CandidatesViewController _listController;

  var isUpdating = false.obs;

  final feedbackController = TextEditingController();
  final locationController = TextEditingController();
  final messageController = TextEditingController();

  var selectedInterviewDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    try {
      _listController = Get.find<CandidatesViewController>();

      if (Get.arguments is ApplicantModel) {
        applicant = Get.arguments as ApplicantModel;
      }
    } catch (e) {
      debugPrint("❌ Error in CandidateDetailController onInit: $e");
    }
  }

  Future<void> changeApplicantStatus(
    String newStatus, {
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    isUpdating.value = true;

    final success = await _listController.updateApplicantStatus(
      applicant.applicationId,
      newStatus,
      interviewSchedule: interviewSchedule,
      feedback: feedback,
    );

    isUpdating.value = false;

    if (success) {
      Get.back();

      Future.delayed(const Duration(milliseconds: 400), () {
        Get.snackbar(
          "Success".tr, // 🟢 Added .tr
          "Candidate has been moved to @status.".trParams({
            'status': newStatus.capitalizeFirst ?? newStatus,
          }), // 🟢 Added .trParams
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.successBackground,
          colorText: AppColors.success,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );
      });
    }
  }

  String getCvFileName(String? url) {
    if (url == null || url.isEmpty) return "No CV Attached".tr; // 🟢 Added .tr

    try {
      String cleanUrl = url.split('?').first;
      String fileName = cleanUrl.split('/').last;
      return Uri.decodeComponent(fileName);
    } catch (e) {
      return "Applicant_Resume.pdf";
    }
  }

  @override
  void onClose() {
    feedbackController.dispose();
    locationController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
