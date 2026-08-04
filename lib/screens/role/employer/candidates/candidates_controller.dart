part of 'candidates_view.dart';

class CandidatesViewController extends GetxController {
  // 🎯 ហៅ Service ដែលយើងបានបង្កើត
  final ApplicantEmployerService _applicantService = ApplicantEmployerService();

  // 🎯 គ្រប់គ្រងស្ថានភាពនៃការ Load
  var isLoading = false.obs;

  // 🎯 បញ្ជីរក្សាទុកទិន្នន័យបេក្ខជន
  var applicants = <ApplicantModel>[].obs;

  // 🎯 Status បច្ចុប្បន្ន (Tab ដែលកំពុងឈរ) - Default គឺ 'pending' (ត្រូវនឹងពាក្យថា "New" លើ UI)
  var currentStatus = 'pending'.obs;

  // 🎯 Job ID សម្រាប់ការទាញយកបេក្ខជន
  // (អាចទាញពី Dropdown "All Jobs" ឬបញ្ជូនមកពីទំព័រ My Jobs)
  var selectedJobId = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // ឆែកមើលថាតើមានបញ្ជូន Job ID មកពីទំព័រមុនដែរឬទេ
    if (Get.arguments != null && Get.arguments is String) {
      selectedJobId.value = Get.arguments as String;
    } else {
      // 🎯 បើគ្មានទេ កំណត់វាឱ្យស្មើ 'all' ជាលំនាំដើម
      selectedJobId.value = 'all';
    }
    fetchApplicants();
  }

  /// 🎯 ទាញយកបញ្ជីបេក្ខជនតាម Status នៃ Tab នីមួយៗ
  Future<void> fetchApplicants() async {
    if (selectedJobId.value.isEmpty) return;

    try {
      isLoading.value = true;
      applicants.clear(); // លុបទិន្នន័យចាស់ពេលប្តូរ Tab

      final result = await _applicantService.getJobApplicants(
        jobId: selectedJobId.value,
        status: currentStatus.value,
      );

      applicants.assignAll(result);
    } catch (e) {
      debugPrint("❌ Error in Controller: $e");
      Get.snackbar(
        "Error",
        "Failed to load candidates. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🎯 ពេល Employer ចុចដូរ Tab (New -> Shortlisted -> Interviewed...)
  void changeTab(String status) {
    // បើគាត់ចុច Tab ដដែល មិនបាច់ Load សារថ្មីទេ
    if (currentStatus.value == status) return;

    currentStatus.value = status;
    fetchApplicants();
  }

  /// 🎯 មុខងារប្តូរស្ថានភាពបេក្ខជន (ឧ. Employer ចុចប៊ូតុង "Shortlist" លើកាត)
  Future<void> updateApplicantStatus(
    String applicationId,
    String newStatus,
  ) async {
    try {
      // បង្ហាញ Loading ដដែលៗកុំឱ្យគាត់ចុចផ្ទួនៗ
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final success = await _applicantService.updateApplicationStatus(
        applicationId: applicationId,
        newStatus: newStatus,
      );

      Get.back(); // បិទ Loading

      if (success) {
        // 🎯 ល្បិច UX: លុបបេក្ខជននេះចេញពី UI ភ្លាមៗ (ព្រោះគាត់ត្រូវរើទៅ Tab ផ្សេងហើយ) ដោយមិនបាច់ហៅ API ម្តងទៀត
        applicants.removeWhere((app) => app.applicationId == applicationId);

        Get.snackbar(
          "Success",
          "Candidate has been moved to $newStatus.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade800,
        );
      }
    } catch (e) {
      Get.back(); // បិទ Loading
      Get.snackbar(
        "Action Failed",
        "Could not update status.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    }
  }
}
