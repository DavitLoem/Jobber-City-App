part of 'my_job_view.dart';

class MyJobViewController extends GetxController {
  final JobService _jobService = JobService();

  // State UI
  final jobs = <JobDataModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  // State for search and filter
  final seletedTab = "All".obs;
  final searchController = TextEditingController();

  // State for pagination
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMoreData = true;
  final scrollController = ScrollController();

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    fetchJobs(isRefresh: true);

    scrollController.addListener(_scrollListener);
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
      // 🟢 បន្ថែមលក្ខខណ្ឌ Closed
      return jobs.where((j) => j.status.toLowerCase() == 'closed').toList();
    }
    return jobs;
  }

  Future<void> fetchJobs({bool isRefresh = false}) async {
    // ប្រសិនបើជាការ Refresh ឬប្តូរ Tab ថ្មី
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
      );

      if (response.success) {
        if (isRefresh) {
          jobs.assignAll(response.data); // add new data
        } else {
          jobs.addAll(response.data); // តទិន្នន័យពីក្រោយ​ (Load More)
        }

        // 🎯 ឆែកមើលថាអស់ទិន្នន័យឬនៅ (បើទាញបានតិចជាង Limit មានន័យថាអស់ហើយ)
        if (response.data.length < _limit) {
          _hasMoreData = false;
        } else {
          _currentPage++;
        }
      }
    } catch (e) {
      debugPrint("Error fetching jobs: $e");
      Get.snackbar(
        "Error",
        "Failed to load jobs. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      // 1. បង្ហាញរង្វង់ Loading ពេញអេក្រង់ និងមិនអនុញ្ញាតឱ្យចុចបិទ (barrierDismissible: false)
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

      // បិទរង្វង់ Loading វិញពេល API ដើរចប់
      Get.back();

      if (success) {
        // លុបទិន្នន័យចេញពី List ក្នុង UI ភ្លាមៗ (មិនបាច់ទាញ API ថ្មីនាំយឺត)
        jobs.removeWhere((job) => job.id == jobId);

        // បង្ហាញសារជោគជ័យ
        Get.snackbar(
          'Deleted',
          'The job has been removed successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // បិទរង្វង់ Loading វិញក្នុងករណីមាន Error
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        "Failed to delete",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ── មុខងារ Update Status (Active, Paused, Closed) ──
  Future<void> changeJobStatus(String jobId, String newStatus) async {
    try {
      // 1. បង្ហាញរង្វង់ Loading
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
        ),
        barrierDismissible: false,
      );

      // 2. ហៅ API ដើម្បី Update Status
      final success = await _jobService.updateJobStatus(jobId, newStatus);

      // 3. បិទ Loading
      Get.back();

      if (success) {
        for (int i = 0; i < jobs.length; i++) {
          if (jobs[i].id == jobId) {
            // ២. ធ្វើការ Update
            jobs[i] = jobs[i].copyWith(status: newStatus);
          }
        }

        // ៤. ទើបប្រាប់ UI ឱ្យ Rebuild
        jobs.refresh();

        Get.snackbar(
          'Status Updated',
          'The job status has been changed to $newStatus.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        "Update Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // មុខងារពេលអូសដល់បាតអេក្រង់
  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchJobs(isRefresh: false);
    }
  }

  void changeTab(String tabString) {
    String newFilter = 'All';
    if (tabString.startsWith('Active')) {
      newFilter = 'Active';
    } else if (tabString.startsWith('Paused')) {
      newFilter = 'Paused';
    } else if (tabString.startsWith('Draft')) {
      newFilter = 'Draft';
    } else if (tabString.startsWith('Closed')) {
      // 🟢 បន្ថែមលក្ខខណ្ឌ Closed
      newFilter = 'Closed';
    }

    // បើចុចចំ Tab ដដែល មិនបាច់ធ្វើអ្វីទេ
    if (seletedTab.value == newFilter) return;

    // 🎯 ២. គ្រាន់តែប្តូរតម្លៃឱ្យ Obx ធ្វើការ Rebuild UI ជាការស្រេច
    seletedTab.value = newFilter;
  }

  void onSearchChanged(String query) {
    // រាល់ពេលគាត់វាយអក្សរ វាមិនហៅ API ភ្លាមទេ វាចាំកន្លះវិនាទីសិន
    _debouncer.run(() {
      // ពេលគាត់ឈប់វាយកន្លះវិនាទី ទើបវាហៅមុខងារនេះ
      fetchJobs(isRefresh: true);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
