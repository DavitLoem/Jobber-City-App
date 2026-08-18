part of 'candidates_view.dart';

class CandidatesViewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApplicantEmployerService _applicantService = ApplicantEmployerService();

  var isLoading = false.obs;
  var isJobsLoading = false.obs;

  var applicants = <ApplicantModel>[].obs;
  var postedJobs = <JobDropdownItemModel>[].obs;
  var selectedJobId = ''.obs;

  final List<String> tabs = [
    'pending',
    'shortlisted',
    'interview',
    'hired',
    'rejected',
  ];

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is String) {
      selectedJobId.value = Get.arguments as String;
    } else {
      selectedJobId.value = 'all';
    }

    tabController = TabController(length: tabs.length, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        changeTab(tabs[tabController.index]);
      }
    });

    fetchPostedJobs();
    fetchApplicants();
  }

  Future<void> fetchPostedJobs() async {
    try {
      isJobsLoading.value = true;
      final result = await _applicantService.getJobDropdownList();
      postedJobs.assignAll(result);
    } catch (e) {
      debugPrint("❌ Error fetching jobs for dropdown: $e");
    } finally {
      isJobsLoading.value = false;
    }
  }

  String get selectedJobDisplayName {
    if (selectedJobId.value == 'all' || selectedJobId.value.isEmpty) {
      return 'All Jobs'.tr; // 🟢 Added .tr
    }

    final job = postedJobs.firstWhere(
      (j) => j.jobId == selectedJobId.value,
      orElse: () => JobDropdownItemModel(
        jobId: '',
        displayName: 'Loading...'.tr, // 🟢 Added .tr
        status: '',
      ),
    );

    return job.displayName;
  }

  Future<void> fetchApplicants() async {
    if (selectedJobId.value.isEmpty) return;

    try {
      isLoading.value = true;
      applicants.clear();

      String activeStatus = tabs[tabController.index];

      final result = await _applicantService.getJobApplicants(
        jobId: selectedJobId.value,
        status: activeStatus,
      );

      applicants.assignAll(result);
    } catch (e) {
      debugPrint("❌ Error in Controller: $e");
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Failed to load candidates. Please try again.".tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(String status) {
    fetchApplicants();
  }

  Future<bool> updateApplicantStatus(
    String applicationId,
    String newStatus, {
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        barrierDismissible: false,
      );

      final success = await _applicantService.updateApplicationStatus(
        applicationId: applicationId,
        newStatus: newStatus,
        interviewSchedule: interviewSchedule,
        feedback: feedback,
      );

      Get.back();

      if (success) {
        applicants.removeWhere((app) => app.applicationId == applicationId);
        return true;
      }
      return false;
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Action Failed".tr, // 🟢 Added .tr
        "Could not update status.".tr, // 🟢 Added .tr
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return false;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
