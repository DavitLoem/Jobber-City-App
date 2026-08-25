part of 'candidate_detail_view.dart';

class CandidateDetailViewController extends GetxController {
  // 🟢 ១. ប្តូរពី late ទៅជា Rxn (Nullable) និងបន្ថែម State សម្រាប់ Loading
  final applicant = Rxn<ApplicantModel>();
  var isLoadingData = false.obs;

  late CandidatesViewController _listController;
  var isUpdating = false.obs;

  final feedbackController = TextEditingController();
  final locationController = TextEditingController();
  final messageController = TextEditingController();

  var selectedInterviewDate = Rxn<DateTime>();

  // 🟢 ២. ទាញយក Service មកប្រើប្រាស់
  final ApplicantEmployerService _service = ApplicantEmployerService();

  @override
  void onInit() {
    super.onInit();
    try {
      if (Get.isRegistered<CandidatesViewController>()) {
        _listController = Get.find<CandidatesViewController>();
      }

      final arg = Get.arguments;
      // 🟢 ៣. ឆែកលក្ខខណ្ឌ៖ បើជា Object យកប្រើតែម្តង, បើជា String(ID) ហៅ API
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
    // ស្វែងរក ID បច្ចុប្បន្ន (អាចពី Object ដែលមានស្រាប់ ឬពី Arguments)
    final currentId =
        applicant.value?.applicationId ??
        (Get.arguments is String ? Get.arguments as String : null);

    if (currentId != null) {
      // មិនបាច់កំណត់ isLoadingData = true ទេ ព្រោះ RefreshIndicator មានរង្វង់វិលរបស់វារួចហើយ
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

  // 🟢 ៤. មុខងារទាញយកទិន្នន័យពី API ពេលចុចពីកាត Recent Applicant
  Future<void> fetchCandidateDetail(String applicationId) async {
    try {
      isLoadingData.value = true;
      final result = await _service.getApplicationDetail(applicationId);
      if (result != null) {
        applicant.value = result;
      }
    } catch (e) {
      debugPrint("❌ Error fetching detail: $e");
      Get.snackbar("Error", "Could not load applicant details");
    } finally {
      isLoadingData.value = false;
    }
  }

  // 🎯 មុខងារប្តូរ Status
  Future<void> changeApplicantStatus(
    String newStatus, {
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    if (applicant.value == null) return; // 🟢 ការពារ Error បើគ្មានទិន្នន័យ

    isUpdating.value = true;

    // 🟢 ប្រើប្រាស់ applicant.value!
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
          "Success",
          "Candidate has been moved to ${newStatus.capitalizeFirst}.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade800,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );
      });
    }
  }

  // 🎯 អនុគមន៍សម្រាប់ទាញយកឈ្មោះ CV ចេញពី URL
  String getCvFileName(String? url) {
    if (url == null || url.isEmpty) return "No CV Attached";
    try {
      String cleanUrl = url.split('?').first;
      String fileName = cleanUrl.split('/').last;
      return Uri.decodeComponent(fileName);
    } catch (e) {
      return "Applicant_Resume.pdf";
    }
  }

  Future<void> openDocument(String? url) async {
    if (url == null || url.isEmpty) {
      Get.snackbar("Notice", "No document attached.");
      return;
    }

    // 🎯 ប្រើប្រាស់ Screen ថ្មីដើម្បីបង្ហាញ Cover Letter ដោយផ្ទាល់
    Get.to(() => DocumentViewerScreen(documentUrl: url, title: "Cover Letter"));
  }

  @override
  void onClose() {
    feedbackController.dispose();
    locationController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
