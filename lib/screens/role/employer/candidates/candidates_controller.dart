part of 'candidates_view.dart';

class CandidatesViewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // 🎯 ហៅ Service ដែលយើងបានបង្កើត
  final ApplicantEmployerService _applicantService = ApplicantEmployerService();

  // 🎯 គ្រប់គ្រងស្ថានភាពនៃការ Load
  var isLoading = false.obs;
  var isJobsLoading = false.obs; // 🟢 សម្រាប់ Load បញ្ជីការងារ

  // 🎯 បញ្ជីរក្សាទុកទិន្នន័យបេក្ខជន
  var applicants = <ApplicantModel>[].obs;

  // 🟢 បញ្ជីរក្សាទុកការងារសម្រាប់ Bottom Sheet
  var postedJobs = <JobDropdownItemModel>[].obs;

  // 🎯 Job ID សម្រាប់ការទាញយកបេក្ខជន
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

    // 🟢 ហៅទិន្នន័យទាំង ២ ស្របពេលគ្នា
    fetchPostedJobs();
    fetchApplicants();
  }

  /// 🟢 ទាញយកបញ្ជីការងារសម្រាប់ដាក់ក្នុង Modal Bottom Sheet
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

  /// 🟢 អនុគមន៍ជំនួយសម្រាប់បង្ហាញឈ្មោះការងារដែលបានរើសនៅលើប៊ូតុង
  String get selectedJobDisplayName {
    if (selectedJobId.value == 'all' || selectedJobId.value.isEmpty) {
      return 'All Jobs';
    }

    final job = postedJobs.firstWhere(
      (j) => j.jobId == selectedJobId.value,
      orElse: () => JobDropdownItemModel(
        jobId: '',
        displayName: 'Loading...',
        status: '',
      ),
    );

    return job.displayName;
  }

  /// 🎯 ទាញយកបញ្ជីបេក្ខជនតាម Status នៃ Tab នីមួយៗ
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

  void changeTab(String status) {
    fetchApplicants();
  }

  /// 🎯 មុខងារប្តូរស្ថានភាពបេក្ខជន (ផ្លាស់ប្តូរឱ្យ Return ជា bool វិញ)
  Future<bool> updateApplicantStatus(
    String applicationId,
    String newStatus, {
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // កុំភ្លេច Update Service របស់អ្នកឱ្យទទួលយក Parameter ២ នេះផងដែរ
      final success = await _applicantService.updateApplicationStatus(
        applicationId: applicationId,
        newStatus: newStatus,
        interviewSchedule: interviewSchedule,
        feedback: feedback,
      );

      Get.back(); // បិទ Loading Dialog

      if (success) {
        // លុបបេក្ខជននេះចេញពី UI ភ្លាមៗ
        applicants.removeWhere((app) => app.applicationId == applicationId);
        return true; // 🟢 បញ្ជាក់ថាជោគជ័យ
      }
      return false;
    } catch (e) {
      Get.back(); // បិទ Loading Dialog
      Get.snackbar(
        "Action Failed",
        "Could not update status.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
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
