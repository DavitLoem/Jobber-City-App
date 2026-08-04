part of 'candidate_detail_view.dart';

class CandidateDetailViewController extends GetxController {
  late ApplicantModel applicant;

  // 🎯 ទាញយក Controller មេមកប្រើប្រាស់
  late CandidatesViewController _listController;

  var isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      // ព្យាយាមចាប់យក Controller មេ
      _listController = Get.find<CandidatesViewController>();

      if (Get.arguments is ApplicantModel) {
        applicant = Get.arguments as ApplicantModel;
        debugPrint("✅ Applicant received: ${applicant.fullName}");
      } else {
        debugPrint("❌ Error: Get.arguments is not ApplicantModel");
      }
    } catch (e) {
      debugPrint("❌ Error in CandidateDetailController onInit: $e");
    }
  }

  // 🎯 មុខងារប្តូរ Status
  Future<void> changeApplicantStatus(String newStatus) async {
    isUpdating.value = true;

    // ហៅមុខងារពី Controller មេ ដើម្បី Update API និងដកទិន្នន័យចេញពី List
    await _listController.updateApplicantStatus(
      applicant.applicationId,
      newStatus,
    );

    isUpdating.value = false;
    Get.back();
  }
}
