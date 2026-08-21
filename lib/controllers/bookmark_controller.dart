import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/bookmark_service.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';
import 'package:jobber_city/screens/role/seeker/save_job_screen/save_job_screen_view.dart';

class BookmarkController extends GetxController {
  final BookmarkService _bookmarkService = BookmarkService();

  Future<void> toggleBookmark({
    required JobFeedModel job,
    required VoidCallback onUpdate,
  }) async {
    // ១. Optimistic Update
    job.isSaved = !job.isSaved;
    onUpdate();

    try {
      // ២. ហៅ API បាញ់ទៅ Backend
      await _bookmarkService.toggleBookmark(job.id);

      // 🎯 ៣. បន្ថែមកូដនៅទីនេះ៖ បញ្ជាឱ្យទំព័រ Saved Jobs ទាញយកទិន្នន័យថ្មីដោយស្ងាត់ៗ
      if (Get.isRegistered<SaveJobScreenViewController>()) {
        Get.find<SaveJobScreenViewController>().fetchSavedJobs(isRefresh: true);
      }
    } catch (e) {
      // បើ API បរាជ័យ ត្រូវទាញទិន្នន័យមកដូចដើមវិញ
      job.isSaved = !job.isSaved;
      onUpdate();

      Get.snackbar(
        'Action Failed',
        'Could not update bookmark. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
