part of 'save_job_screen_view.dart';

class SaveJobScreenViewController extends GetxController {
  final BookmarkService _bookmarkService = BookmarkService();

  var savedJobs = <JobFeedModel>[].obs;
  var selectedFilterIndex = 0.obs;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  int _currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchSavedJobs(isRefresh: true);
  }

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

      if (data.length < 10) {
        hasMoreData.value = false;
      } else {
        _currentPage++;
      }
    } catch (e) {
      debugPrint('🔥 Error fetching saved jobs: $e');
      Get.snackbar(
        'Fetch Failed'.tr, // 🟢 Added .tr
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  List<String> get filterOptions {
    final types = savedJobs
        .map((j) => j.workType)
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList();
    return ['All', ...types];
  }

  List<JobFeedModel> get filteredJobs {
    if (selectedFilterIndex.value == 0) return savedJobs;
    final options = filterOptions;
    if (selectedFilterIndex.value >= options.length) return savedJobs;
    final selected = options[selectedFilterIndex.value];
    return savedJobs.where((j) => j.workType == selected).toList();
  }

  Future<void> removeJob(String id) async {
    final index = savedJobs.indexWhere((j) => j.id == id);
    if (index == -1) return;

    final removedJob = savedJobs[index];
    savedJobs.removeAt(index);

    try {
      await _bookmarkService.toggleBookmark(id);

      Get.snackbar(
        'Removed from Saved'.tr, // 🟢 Added .tr
        '"@job" was removed.'.trParams({
          'job': removedJob.title,
        }), // 🟢 Added .trParams
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.textPrimary,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        mainButton: TextButton(
          onPressed: () async {
            Get.closeCurrentSnackbar();
            savedJobs.insert(index.clamp(0, savedJobs.length), removedJob);

            try {
              await _bookmarkService.toggleBookmark(id);
            } catch (e) {
              savedJobs.removeWhere((j) => j.id == id);
              Get.snackbar(
                'Error'.tr, // 🟢 Added .tr
                'Failed to undo action.'.tr, // 🟢 Added .tr
                backgroundColor: AppColors.error,
                colorText: Colors.white,
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
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }
}
