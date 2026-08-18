part of 'my_job_view.dart';

class MyJobViewController extends GetxController {
  final JobService _jobService = JobService();

  final statusSummary = {
    'all': 0,
    'active': 0,
    'paused': 0,
    'closed': 0,
    'draft': 0,
  }.obs;

  final jobs = <JobDataModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  final seletedTab = "All".obs;
  final searchController = TextEditingController();

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMoreData = true;
  final scrollController = ScrollController();

  final _debouncer = Debouncer(milliseconds: 500);

  final currentSort = 'newest'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatusSummary();
    fetchJobs(isRefresh: true);
    scrollController.addListener(_scrollListener);
  }

  Future<void> fetchStatusSummary() async {
    final summary = await _jobService.getJobStatusSummary();
    if (summary.isNotEmpty) {
      statusSummary.assignAll(summary);
    }
  }

  List<JobDataModel> get displayJobs {
    if (seletedTab.value == 'Active') {
      return jobs.where((j) => j.status.toLowerCase() == 'active').toList();
    } else if (seletedTab.value == 'Paused') {
      return jobs
          .where(
            (j) =>
                j.status.toLowerCase() == 'inactive' ||
                j.status.toLowerCase() == 'paused',
          )
          .toList();
    } else if (seletedTab.value == 'Draft') {
      return jobs.where((j) => j.status.toLowerCase() == 'draft').toList();
    } else if (seletedTab.value == 'Closed') {
      return jobs.where((j) => j.status.toLowerCase() == 'closed').toList();
    }
    return jobs;
  }

  Future<void> fetchJobs({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      isLoading.value = true;
      jobs.clear(); // clear old data
    } else {
      if (isLoadingMore.value || !_hasMoreData) return;
      isLoadingMore.value = true;
    }

    try {
      final response = await _jobService.getJobs(
        page: _currentPage,
        limit: _limit,
        // status: seletedTab.value,
        searchKeyword: searchController.text,
        sortBy: currentSort.value,
      );

      if (response.success) {
        if (isRefresh) {
          jobs.assignAll(response.data);
        } else {
          jobs.addAll(response.data);
        }

        if (response.data.length < _limit) {
          _hasMoreData = false;
        } else {
          _currentPage++;
        }
      }
    } catch (e) {
      debugPrint("Error fetching jobs: $e");
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Failed to load jobs. Please try again.".tr, // 🟢 Added .tr
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
        ),
        barrierDismissible: false,
      );

      final success = await _jobService.deleteJob(jobId);

      Get.back();

      if (success) {
        jobs.removeWhere((job) => job.id == jobId);

        Get.snackbar(
          'Deleted'.tr, // 🟢 Added .tr
          'The job has been removed successfully.'.tr, // 🟢 Added .tr
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        "Failed to delete".tr, // 🟢 Added .tr
        e.toString(),
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> changeJobStatus(String jobId, String newStatus) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
        ),
        barrierDismissible: false,
      );

      final success = await _jobService.updateJobStatus(jobId, newStatus);

      Get.back();

      if (success) {
        for (int i = 0; i < jobs.length; i++) {
          if (jobs[i].id == jobId) {
            jobs[i] = jobs[i].copyWith(status: newStatus);
          }
        }

        jobs.refresh();

        Get.snackbar(
          'Status Updated'.tr, // 🟢 Added .tr
          'The job status has been changed to @status.'.trParams({
            'status': newStatus,
          }), // 🟢 Added .trParams
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        "Update Failed".tr, // 🟢 Added .tr
        e.toString(),
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchJobs(isRefresh: false);
    }
  }

  void changeTab(String tabString) {
    String newFilter = 'All';
    // 🟢 Updated to match both English and Translated strings dynamically
    if (tabString.startsWith('Active'.tr) || tabString.startsWith('Active')) {
      newFilter = 'Active';
    } else if (tabString.startsWith('Paused'.tr) ||
        tabString.startsWith('Paused')) {
      newFilter = 'Paused';
    } else if (tabString.startsWith('Draft'.tr) ||
        tabString.startsWith('Draft')) {
      newFilter = 'Draft';
    } else if (tabString.startsWith('Closed')) {
      // 🟢 បន្ថែមលក្ខខណ្ឌ Closed
      newFilter = 'Closed';
    }

    if (seletedTab.value == newFilter) return;

    // 🎯 ២. គ្រាន់តែប្តូរតម្លៃឱ្យ Obx ធ្វើការ Rebuild UI ជាការស្រេច
    seletedTab.value = newFilter;

    // 🎯 ២. [បន្ថែមថ្មី] ត្រូវហៅ API ទាញយកទិន្នន័យថ្មីរាល់ពេលដូរ Tab!
    fetchJobs(isRefresh: true);
  }

  void onSearchChanged(String query) {
    _debouncer.run(() {
      fetchJobs(isRefresh: true);
    });
  }

  void changeSortOption(String newSort) {
    if (currentSort.value == newSort) return;
    currentSort.value = newSort;
    fetchJobs(isRefresh: true); // ហៅទិន្នន័យសារថ្មី
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
