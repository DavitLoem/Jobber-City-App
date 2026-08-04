part of 'save_job_screen_view.dart';

/// Plain local data holder for a saved job card.
///
/// This screen has no backend wired up yet, so this is intentionally a
/// small, self-contained model (not the API-backed `JobRecentModel` /
/// `JobRecommendedModel`) — swap this out once a real "Saved Jobs" endpoint
/// exists.
class _SavedJobData {
  const _SavedJobData({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.minSalary,
    required this.maxSalary,
    required this.salaryPeriod,
    required this.employmentType,
    required this.workType,
    required this.savedDaysAgo,
  });

  final String id;
  final String title;
  final String companyName;
  final String location;
  final int minSalary;
  final int maxSalary;
  final String salaryPeriod;
  final String employmentType; // Full-time / Part-time / Contract
  final String workType; // Remote / Onsite / Hybrid
  final int savedDaysAgo;
}

class SaveJobScreenViewController extends GetxController {
  // Local, in-memory "saved jobs" list — no API call.
  var savedJobs = <_SavedJobData>[].obs;

  // Filter chip state ("All" + one chip per work type present in the list).
  var selectedFilterIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockSavedJobs();
  }

  void _loadMockSavedJobs() {
    savedJobs.assignAll(const [
      _SavedJobData(
        id: '1',
        title: 'Senior UI/UX Designer',
        companyName: 'Nexora Studio',
        location: 'Phnom Penh, Cambodia',
        minSalary: 800,
        maxSalary: 1200,
        salaryPeriod: 'month',
        employmentType: 'Full-time',
        workType: 'Remote',
        savedDaysAgo: 1,
      ),
      _SavedJobData(
        id: '2',
        title: 'Flutter Developer',
        companyName: 'Jobber City Tech',
        location: 'Siem Reap, Cambodia',
        minSalary: 600,
        maxSalary: 950,
        salaryPeriod: 'month',
        employmentType: 'Full-time',
        workType: 'Hybrid',
        savedDaysAgo: 2,
      ),
      _SavedJobData(
        id: '3',
        title: 'Digital Marketing Intern',
        companyName: 'BrightWave Media',
        location: 'Phnom Penh, Cambodia',
        minSalary: 150,
        maxSalary: 250,
        salaryPeriod: 'month',
        employmentType: 'Part-time',
        workType: 'Onsite',
        savedDaysAgo: 4,
      ),
      _SavedJobData(
        id: '4',
        title: 'Backend Engineer (Node.js)',
        companyName: 'Cloudline Systems',
        location: 'Phnom Penh, Cambodia',
        minSalary: 900,
        maxSalary: 1500,
        salaryPeriod: 'month',
        employmentType: 'Full-time',
        workType: 'Remote',
        savedDaysAgo: 6,
      ),
    ]);
  }

  List<String> get filterOptions {
    final types = savedJobs.map((j) => j.workType).toSet().toList();
    return ['All', ...types];
  }

  List<_SavedJobData> get filteredJobs {
    if (selectedFilterIndex.value == 0) return savedJobs;
    final options = filterOptions;
    if (selectedFilterIndex.value >= options.length) return savedJobs;
    final selected = options[selectedFilterIndex.value];
    return savedJobs.where((j) => j.workType == selected).toList();
  }

  // Removes a job, but keeps a copy + index around briefly so "Undo" works.
  void removeJob(String id) {
    final index = savedJobs.indexWhere((j) => j.id == id);
    if (index == -1) return;
    final removed = savedJobs[index];
    savedJobs.removeAt(index);

    Get.snackbar(
      'Removed from Saved',
      '"${removed.title}" was removed.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      mainButton: TextButton(
        onPressed: () {
          savedJobs.insert(index.clamp(0, savedJobs.length), removed);
          Get.closeCurrentSnackbar();
        },
        child: const Text('UNDO', style: TextStyle(color: AppColors.accent)),
      ),
    );
  }

  void clearAll() {
    if (savedJobs.isEmpty) return;
    savedJobs.clear();
    Get.snackbar(
      'Saved Jobs Cleared',
      'All saved jobs were removed.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.textPrimary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
    );
  }
}
