part of 'home_seeker_view.dart';

class HomeSeekerViewController extends GetxController {
  // 🎯 ១. ប្រើប្រាស់ Service តែមួយគត់សម្រាប់ Job Feed និង ApiClient សម្រាប់ Profile
  final JobFeedService _jobFeedService = JobFeedService();
  final ApiClient _apiClient = ApiClient();

  // ── ផ្នែក Recommended Jobs ──
  var recommendedJobs = <JobFeedModel>[].obs;
  var isRecommendedLoading = false.obs;

  // ── ផ្នែក Recent Jobs (ភ្ជាប់ជាមួយ Pagination) ──
  var recentJobs = <JobFeedModel>[].obs;
  var isRecentLoading = false.obs;
  var isRecentLoadingMore = false.obs; // សម្រាប់បង្ហាញ Loading ពេលអូសចុះក្រោម
  int _recentPage = 1;
  bool _hasMoreRecent = true; // សម្គាល់ថាមានទិន្នន័យនៅសល់ឬអត់

  // ── ផ្នែក Profile ──
  var isLoadingProfile = true.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var profileImageUrl = ''.obs;

  // Selected filter index for Recent Jobs[cite: 10]
  var selectedRecentFilterIndex = 0.obs;

  var selectedCategoryId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchProfileRaw();
    fetchJobRecommended();
    fetchJobRecent(isRefresh: true);

    // 🎯 បន្ថែមកូដខាងក្រោមនេះ
    // ទាញយក CategoryController មកឆែកមើល បើទទេ ត្រូវហៅ API ម្ដងទៀត
    final categoryCtrl = Get.put(CategoryController());
    if (categoryCtrl.categories.isEmpty) {
      categoryCtrl.fetchCategories();
    }
  }

  /// 🎯 ២. ការទាញយក Profile ដោយប្រើប្រាស់ API ផ្ទាល់ (បោះបង់ AuthServices)[cite: 10]
  void fetchProfileRaw() async {
    try {
      isLoadingProfile.value = true;
      AppLogger.i("⏳ កំពុងទាញយកទិន្នន័យ Profile...");

      final response = await _apiClient.get('/seeker/profile/');

      if (response != null && response['data'] != null) {
        var data = response['data'];
        firstName.value = data['first_name'] ?? 'NoName';
        lastName.value = data['last_name'] ?? '';
        profileImageUrl.value = data['profile_image_url'] ?? '';
        AppLogger.i("✅ ទាញយកជោគជ័យ: ${firstName.value} ${lastName.value}");
      }
    } catch (e) {
      AppLogger.i("❌ បរាជ័យក្នុងការទាញយក Profile: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// ទាញយក Recommended Jobs (ទាញម្ដង ១០ សិន មិនបាច់មាន Infinite Scroll ទេព្រោះវាជា Horizontal List)
  void fetchJobRecommended() async {
    try {
      isRecommendedLoading.value = true;
      var data = await _jobFeedService.getRecommendedJobs(page: 1, limit: 10);
      recommendedJobs.assignAll(data);
    } catch (e) {
      debugPrint('Error fetching recommended jobs: $e');
    } finally {
      isRecommendedLoading.value = false;
    }
  }

  /// 🎯 ៣. ការទាញយក Recent Jobs ភ្ជាប់ជាមួយប្រព័ន្ធ Pagination ដ៏រឹងមាំ
  Future<void> fetchJobRecent({bool isRefresh = false}) async {
    if (isRefresh) {
      _recentPage = 1;
      _hasMoreRecent = true;
      isRecentLoading.value = true;
      recentJobs.clear(); // លុបទិន្នន័យចាស់ចោល ពេលប្តូរ Category
    } else {
      if (isRecentLoadingMore.value || !_hasMoreRecent) return;
      isRecentLoadingMore.value = true;
    }

    try {
      var data = await _jobFeedService.getRecentJobs(
        page: _recentPage,
        limit: 10,
        categoryId: selectedCategoryId.value.isNotEmpty
            ? selectedCategoryId.value
            : null,
      );

      recentJobs.addAll(data);

      if (data.length < 10) {
        _hasMoreRecent = false;
      } else {
        _recentPage++;
      }
    } catch (e) {
      debugPrint('Error fetching recent jobs: $e');
    } finally {
      isRecentLoading.value = false;
      isRecentLoadingMore.value = false;
    }
  }

  void onCategorySelected(String categoryId) {
    if (selectedCategoryId.value == categoryId) {
      return;
    }
    selectedCategoryId.value = categoryId;
    fetchJobRecent(isRefresh: true); // ហៅ API ទាញយកការងារថ្មីពីទំព័រទី ១ មកវិញ
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good morning";
    } else if (hour < 17) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  /// 🎯 ៤. ការកែសម្រួលមុខងារ Bookmark ដោយផ្លាស់ប្ដូរតម្លៃផ្ទាល់ និង Refresh UI
  void toggleSaveRecommendedJob(int index) {
    var job = recommendedJobs[index];
    job.isSaved = !job.isSaved;
    recommendedJobs.refresh(); // ប្រាប់ GetX ឱ្យគូរ UI កាតនេះឡើងវិញ
  }

  void toggleSaveRecentJob(int index) {
    var job = recentJobs[index];
    job.isSaved = !job.isSaved;
    recentJobs.refresh();
  }
}
