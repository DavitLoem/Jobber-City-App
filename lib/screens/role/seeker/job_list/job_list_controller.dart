part of 'job_list_view.dart';

class JobListViewController extends GetxController {
  final JobFeedService _jobFeedService = JobFeedService();

  var pageTitle = ''.obs;
  var listType = ''.obs;

  var jobs = <JobFeedModel>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  int _currentPage = 1;
  var hasMoreData = true.obs;

  var selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      pageTitle.value =
          Get.arguments['title'] ??
          'Jobs'; // 🟢 Translation is handled in the view
      listType.value = Get.arguments['type'] ?? 'recent';
    }

    fetchJobs(isRefresh: true);
  }

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

      if (listType.value == 'recommended') {
        newData = await _jobFeedService.getRecommendedJobs(
          page: _currentPage,
          limit: 10,
        );
      } else {
        newData = await _jobFeedService.getRecentJobs(
          page: _currentPage,
          limit: 10,
          categoryId: selectedCategoryId.value.isNotEmpty
              ? selectedCategoryId.value
              : null,
        );
      }

      jobs.addAll(newData);

      if (newData.length < 10) {
        hasMoreData.value = false;
      } else {
        _currentPage++;
      }
    } catch (e) {
      debugPrint('Error fetching jobs in See All: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void onCategorySelected(String categoryId) {
    if (selectedCategoryId.value == categoryId) return;

    selectedCategoryId.value = categoryId;
    fetchJobs(isRefresh: true);
  }

  void toggleSaveJob(int index) {
    var job = jobs[index];
    job.isSaved = !job.isSaved;
    jobs.refresh();
  }
}
