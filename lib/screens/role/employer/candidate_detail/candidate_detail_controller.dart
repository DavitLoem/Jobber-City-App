part of 'candidate_detail_view.dart';

class CandidateDetailViewController extends GetxController {
  final applicant = Rxn<ApplicantModel>();
  var isLoadingData = false.obs;

  late CandidatesViewController _listController;
  var isUpdating = false.obs;

  final feedbackController = TextEditingController();
  final locationController = TextEditingController();
  final messageController = TextEditingController();

  var selectedInterviewDate = Rxn<DateTime>();

  final ApplicantEmployerService _service = ApplicantEmployerService();

  @override
  void onInit() {
    super.onInit();
    try {
      if (Get.isRegistered<CandidatesViewController>()) {
        _listController = Get.find<CandidatesViewController>();
      }

      final arg = Get.arguments;
      if (arg is ApplicantModel) {
        applicant.value = arg;
      } else if (arg is String) {
        fetchCandidateDetail(arg);
      }
    } catch (e) {
      debugPrint("❌ Error in CandidateDetailController onInit: $e");
    }
  }

  Future<void> refreshDetail() async {
    final currentId =
        applicant.value?.applicationId ??
        (Get.arguments is String ? Get.arguments as String : null);

    if (currentId != null) {
      try {
        final result = await _service.getApplicationDetail(currentId);
        if (result != null) {
          applicant.value = result;
        }
      } catch (e) {
        debugPrint("❌ Error refreshing detail: $e");
      }
    }
  }

  Future<void> fetchCandidateDetail(String applicationId) async {
    final isDark = Get.isDarkMode; // 🟢 Theme Check
    try {
      isLoadingData.value = true;
      final result = await _service.getApplicationDetail(applicationId);
      if (result != null) {
        applicant.value = result;
      }
    } catch (e) {
      debugPrint("❌ Error fetching detail: $e");
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Could not load applicant details".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
    } finally {
      isLoadingData.value = false;
    }
  }

  Future<void> changeApplicantStatus(
    String newStatus, {
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    if (applicant.value == null) return;

    isUpdating.value = true;
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    final success = await _listController.updateApplicantStatus(
      applicant.value!.applicationId,
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
          backgroundColor: isDark
              ? AppColors.success.withValues(alpha: 0.15)
              : Colors.green.shade50,
          colorText: isDark ? Colors.greenAccent : Colors.green.shade800,
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

  Future<void> openDocument(String? url) async {
    final isDark = Get.isDarkMode; // 🟢 Theme Check
    if (url == null || url.isEmpty) {
      Get.snackbar(
        "Notice".tr, // 🟢 Added .tr
        "No document attached.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange.shade50,
        colorText: isDark ? Colors.orangeAccent : Colors.orange.shade800,
      );
      return;
    }

    Get.to(
      () => DocumentViewerScreen(documentUrl: url, title: "Cover Letter".tr),
    ); // 🟢 Added .tr
  }

  @override
  void onClose() {
    feedbackController.dispose();
    locationController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
