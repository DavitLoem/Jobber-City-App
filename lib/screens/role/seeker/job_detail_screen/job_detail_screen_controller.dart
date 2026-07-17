import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class JobDetailScreenViewController extends GetxController {
  var job = Rxn<dynamic>();

  @override
  void onInit() {
    super.onInit();
    // ទទួលយកទិន្នន័យដែលបោះមកពី Home Screen
    if (Get.arguments != null) {
      job.value = Get.arguments;
    }
  }

  void applyForJob() {
    // TODO: សរសេរកូដភ្ជាប់ API ដើម្បី Apply ការងារនៅទីនេះ
    Get.snackbar(
      "Success",
      "Application initiated successfully!",
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  // ក្នុង JobDetailScreenViewController
  void toggleSaveJob() {
    if (job.value != null) {
      // ប្ដូរតម្លៃ isSaved ដោយប្រើ copyWith
      final updatedJob = job.value!.copyWith(isSaved: !job.value!.isSaved);
      job.value = updatedJob; // Update UI ក្នុងទំព័រ Detail
    }
    Get.snackbar(
      "Success",
      job.value!.isSaved ? "Job saved" : "Job unsaved",
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
