part of 'save_job_screen_view.dart';

class SaveJobScreenViewController extends GetxController {
  final BookmarkService _bookmarkService = BookmarkService();

  // 🎯 ប្រើប្រាស់ Model ផ្លូវការជំនួសឱ្យ _SavedJobData
  var savedJobs = <JobFeedModel>[].obs;

  // Filter chip state ("All" + one chip per work type present in the list)
  var selectedFilterIndex = 0.obs;

  // ── ផ្នែក Pagination & Loading ──
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  int _currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchSavedJobs(isRefresh: true);
  }

  /// 🎯 ទាញយកបញ្ជីការងារដែលបាន Save ពី API
  Future<void> fetchSavedJobs({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      hasMoreData.value = true;
      isLoading.value = true;
      savedJobs.clear();
    } else {
      if (isLoadingMore.value || !hasMoreData.value) return;
      isLoadingMore.value = true;
    }

    try {
      final data = await _bookmarkService.getSavedJobs(
        page: _currentPage,
        limit: 10,
      );

      if (isRefresh) {
        savedJobs.assignAll(data);
      } else {
        savedJobs.addAll(data);
      }

      // ឆែកមើលថាតើមានទិន្នន័យសល់សម្រាប់ទាញយកនៅទំព័របន្ទាប់ទៀតឬទេ
      if (data.length < 10) {
        hasMoreData.value = false;
      } else {
        _currentPage++;
      }
    } catch (e) {
      debugPrint('🔥 Error fetching saved jobs: $e');
      final isDark = Get.isDarkMode; // 🟢 Theme Check
      Get.snackbar(
        'Fetch Failed'.tr, // 🟢 Added .tr
        e.toString().tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50, // 🟢 Dynamic BG
        colorText: isDark
            ? Colors.redAccent
            : Colors.red.shade700, // 🟢 Dynamic Text
        duration: const Duration(seconds: 6),
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// 🎯 ទាញយកប្រភេទការងារ (Work Type) ដើម្បីធ្វើជា Filter Chips
  List<String> get filterOptions {
    final types = savedJobs
        .map((j) => j.workType)
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList();
    return ['All'.tr, ...types]; // 🟢 Added .tr
  }

  List<JobFeedModel> get filteredJobs {
    if (selectedFilterIndex.value == 0) return savedJobs;
    final options = filterOptions;
    if (selectedFilterIndex.value >= options.length) return savedJobs;
    final selected = options[selectedFilterIndex.value];
    return savedJobs.where((j) => j.workType == selected).toList();
  }

  /// 🎯 ដកការងារចេញពីការរក្សាទុក (Unsave) ភ្ជាប់ជាមួយ API និងមុខងារ Undo
  Future<void> removeJob(String id) async {
    final index = savedJobs.indexWhere((j) => j.id == id);
    if (index == -1) return;

    final removedJob = savedJobs[index];
    final isDark = Get.isDarkMode; // 🟢 Get Theme State for Snackbars

    // Optimistic UI Update
    savedJobs.removeAt(index);

    try {
      // ហៅ API ដើម្បី Unsave
      await _bookmarkService.toggleBookmark(id);

      Get.snackbar(
        'Removed from Saved'.tr, // 🟢 Added .tr
        '"@title" was removed.'.trParams({
          'title': removedJob.title,
        }), // 🟢 Added .trParams
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isDark
            ? AppColors.darkSurfaceElevated
            : AppColors.textPrimary, // 🟢 Dynamic BG
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        mainButton: TextButton(
          onPressed: () async {
            Get.closeCurrentSnackbar();

            // ដាក់ចូលក្នុងបញ្ជី UI វិញ
            savedJobs.insert(index.clamp(0, savedJobs.length), removedJob);

            try {
              // ហៅ API ដើម្បី Save ម្តងទៀត (Undo)
              await _bookmarkService.toggleBookmark(id);
            } catch (e) {
              savedJobs.removeWhere((j) => j.id == id);
              Get.snackbar(
                'Error'.tr, // 🟢 Added .tr
                'Failed to undo action.'.tr, // 🟢 Added .tr
                backgroundColor: isDark
                    ? AppColors.error.withValues(alpha: 0.15)
                    : Colors.red.shade50,
                colorText: isDark ? Colors.redAccent : Colors.red.shade700,
              );
            }
          },
          child: Text(
            'UNDO'.tr,
            style: const TextStyle(color: AppColors.accent),
          ), // 🟢 Added .tr
        ),
      );
    } catch (e) {
      savedJobs.insert(index.clamp(0, savedJobs.length), removedJob);
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Failed to remove job.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
    }
  }
}
