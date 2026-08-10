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

  // 🎯 មុខងារប្តូរ Status
  Future<void> changeApplicantStatus(
    String newStatus, {
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    isUpdating.value = true;

    // ១. រង់ចាំលទ្ធផលពី Controller មេ
    final success = await _listController.updateApplicantStatus(
      applicant.applicationId,
      newStatus,
      interviewSchedule: interviewSchedule,
      feedback: feedback,
    );

    isUpdating.value = false;

    // ២. ប្រសិនបើជោគជ័យ ទើបយើងបិទទំព័រ និងបង្ហាញ Snackbar
    if (success) {
      Get.back(); // 🎯 បិទទំព័រ Detail (ត្រឡប់ទៅកាន់បញ្ជីវិញ)

      // 🎯 ប្រើប្រាស់ Delay បន្តិច ដើម្បីឱ្យ Animation បិទទំព័រដើរចប់សិន ទើបបញ្ចេញ Snackbar
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
      // ១. កាត់ចោល Query Parameters (បើមាន ឧ. ?alt=media...)
      String cleanUrl = url.split('?').first;

      // ២. ទាញយកឈ្មោះឯកសារក្រោយសញ្ញា / ចុងក្រោយគេ
      String fileName = cleanUrl.split('/').last;

      // ៣. បំប្លែងកូដដូចជា %20 មកជាដកឃ្លា (Space) វិញឱ្យស្រួលអាន
      return Uri.decodeComponent(fileName);
    } catch (e) {
      return "Applicant_Resume.pdf"; // Fallback បើមាន Error
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
