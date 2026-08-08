part of 'job_list_view.dart';

class JobListViewController extends GetxController {
  final JobFeedService _jobFeedService = JobFeedService();

  // ── ផ្នែកទិន្នន័យពី Arguments ──
  var pageTitle = ''.obs;
  var listType = ''.obs; // អាចជា 'recommended' ឬ 'recent'

  // ── ផ្នែកគ្រប់គ្រង State និង Pagination ──
  var jobs = <JobFeedModel>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  int _currentPage = 1;
  var hasMoreData = true.obs;

  // ── ផ្នែកសម្រាប់ Filter (ប្រើតែពេល listType == 'recent') ──
  var selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 🎯 ១. អានទិន្នន័យដែលបោះមកពី Get.toNamed(..., arguments: {...})
    if (Get.arguments != null) {
      pageTitle.value = Get.arguments['title'] ?? 'Jobs';
      listType.value = Get.arguments['type'] ?? 'recent';
    }

    // 🎯 ២. ហៅ API ទាញយកទិន្នន័យលើកដំបូង
    fetchJobs(isRefresh: true);
  }

  /// 🎯 មុខងាររួមសម្រាប់ទាញយកការងារទាំង ២ ប្រភេទ
  Future<void> fetchJobs({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      hasMoreData.value = true;
      isLoading.value = true;
      jobs.clear();
    } else {
      if (isLoadingMore.value || !hasMoreData.value) return;
      isLoadingMore.value = true;
    }

    try {
      List<JobFeedModel> newData = [];

      // 🎯 ៣. ឆែកលក្ខខណ្ឌហៅ API ទៅតាម listType
      if (listType.value == 'recommended') {
        newData = await _jobFeedService.getRecommendedJobs(
          page: _currentPage,
          limit: 10,
        ); //[cite: 11]
      } else {
        newData = await _jobFeedService.getRecentJobs(
          page: _currentPage,
          limit: 10,
          categoryId: selectedCategoryId.value.isNotEmpty
              ? selectedCategoryId.value
              : null,
        ); //[cite: 11]
      }

      jobs.addAll(newData);

      // 🎯 ៤. កំណត់ស្ថានភាព Pagination
      if (newData.length < 10) {
        hasMoreData.value = false; // អស់ទិន្នន័យពី Server
      } else {
        _currentPage++; // តម្លើង Page សម្រាប់អូសលើកក្រោយ
      }
    } catch (e) {
      debugPrint('Error fetching jobs in See All: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// 🎯 សម្រាប់ចុចដូរ Category (ប្រើតែជាមួយ Recent Jobs ប៉ុណ្ណោះ)
  void onCategorySelected(String categoryId) {
    if (selectedCategoryId.value == categoryId) return;

    selectedCategoryId.value = categoryId;
    fetchJobs(isRefresh: true);
  }

  /// 🎯 សម្រាប់ Save/Unsave Job នៅក្នុង List
  void toggleSaveJob(int index) {
    var job = jobs[index];
    job.isSaved = !job.isSaved;
    jobs.refresh();
  }
}
