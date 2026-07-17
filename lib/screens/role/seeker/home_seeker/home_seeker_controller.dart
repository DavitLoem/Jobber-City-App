part of 'home_seeker_view.dart';

class HomeSeekerViewController extends GetxController {
  final _seekerServices = AuthServices();
  final _recommendedServices = JobRecommendedServices();
  final _recentServices = JobRecentServices();

  var recommendedJobs = <JobRecommendedModel>[].obs;
  var isRecommendedLoading = false.obs;

  var recentJobs = <JobRecentModel>[].obs;
  var isRecentLoading = false.obs;

  var isLoading = true.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var profileImageUrl = ''.obs;

  // Selected filter index for Recent Jobs
  var selectedRecentFilterIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobRecommended();
    fetchJobRecent();
    fetchProfileRaw();
  }

  void fetchJobRecommended() async {
    try {
      isRecommendedLoading.value = true;
      var data = await _recommendedServices.getJobRecommended();
      recommendedJobs.assignAll(data);
      debugPrint('Fetched ${recommendedJobs.length} recommended jobs');
    } catch (e) {
      debugPrint('Error fetching recommended jobs: $e');
    } finally {
      isRecommendedLoading.value = false;
    }
  }

  void fetchJobRecent() async {
    try {
      isRecentLoading.value = true;
      var data = await _recentServices.getJobRecent();
      recentJobs.assignAll(data);
      debugPrint('Fetched ${recentJobs.length} recent jobs');
    } catch (e) {
      debugPrint('Error fetching recent jobs: $e');
    } finally {
      isRecentLoading.value = false;
    }
  }

  void fetchProfileRaw() async {
    try {
      isLoading.value = true;
      AppLogger.i("⏳ កំពុងទាញយកទិន្នន័យ Profile...");

      final response = await _seekerServices.getRawProfile();
      var data = response['data'];
      firstName.value = data['first_name'] ?? 'NoName';
      lastName.value = data['last_name'] ?? '';
      profileImageUrl.value = data['profile_image_url'] ?? '';

      AppLogger.i("✅ ទាញយកជោគជ័យ: ${firstName.value} ${lastName.value}");
    } catch (e) {
      AppLogger.i("❌ បរាជ័យក្នុងការទាញយក Profile: $e");
      Get.snackbar("Error", "មិនអាចទាញយក Profile បានទេ");
    } finally {
      isLoading.value = false;
    }
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

  // 🟢 មុខងារសម្រាប់ចុច Save លើ Recommended Job
  void toggleSaveRecommendedJob(int index) {
    final job = recommendedJobs[index];

    // បង្កើត Object ថ្មីដោយចម្លងទិន្នន័យចាស់ទាំងអស់ លើកលែងតែ isSaved
    recommendedJobs[index] = JobRecommendedModel(
      id: job.id,
      title: job.title,
      minSalary: job.minSalary,
      maxSalary: job.maxSalary,
      salaryPeriod: job.salaryPeriod,
      companyName: job.companyName,
      logoUrl: job.logoUrl,
      location: job.location,
      employmentType: job.employmentType,
      isSaved: !job.isSaved, // 🔄 ប្តូរពី true ទៅ false ឬ false ទៅ true
    );
  }

  // 🟢 មុខងារសម្រាប់ចុច Save លើ Recent Job
  void toggleSaveRecentJob(int index) {
    final job = recentJobs[index];

    recentJobs[index] = JobRecentModel(
      id: job.id,
      title: job.title,
      minSalary: job.minSalary,
      maxSalary: job.maxSalary,
      salaryPeriod: job.salaryPeriod,
      companyName: job.companyName,
      logoUrl: job.logoUrl,
      location: job.location,
      employmentType: job.employmentType,
      workType: job.workType,
      isSaved: !job.isSaved, // 🔄 ប្តូរតម្លៃ
    );
  }
}
