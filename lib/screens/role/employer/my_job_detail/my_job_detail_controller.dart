part of 'my_job_detail_view.dart';

class MyJobDetailViewController extends GetxController {
  final JobService _jobService = JobService();

  final companyProfile = Rxn<CompanyProfileModel>();

  final masterCtrl = Get.find<MasterDataController>();
  final locationCtrl = Get.find<LocationController>();
  final categoryCtrl = Get.find<CategoryController>();

  final isLoading = false.obs;
  final jobData = Rxn<JobDataModel>();
  late String jobId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is String) {
      jobId = Get.arguments;
    }
  }

  @override
  void onReady() {
    super.onReady();

    if (Get.arguments == null || Get.arguments is! String) {
      final isDark = Get.isDarkMode; // 🟢 Theme Check
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Job ID is missing".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red,
        colorText: isDark ? Colors.redAccent : Colors.white,
      );
      Get.back();
    } else {
      _fetchJobDetail();
    }
  }

  Future<void> _fetchJobDetail() async {
    isLoading.value = true;
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    try {
      if (masterCtrl.masterDataCache['employment-types'] == null) {
        await masterCtrl.getMasterData(endpoint: 'employment-types');
      }

      if (masterCtrl.masterDataCache['skills'] == null) {
        await masterCtrl.getMasterData(endpoint: 'skills');
      }

      final response = await _jobService.getJobById(jobId);

      if (response.success && response.data != null) {
        jobData.value = response.data;

        if (jobData.value?.provinceId != null) {
          await locationCtrl.getDistricts(jobData.value!.provinceId);
        }
      } else {
        Get.snackbar(
          "Error".tr, // 🟢 Added .tr
          response.message.tr, // 🟢 Tr for server string if configured
          backgroundColor: isDark
              ? AppColors.error.withValues(alpha: 0.15)
              : Colors.red,
          colorText: isDark ? Colors.redAccent : Colors.white,
        );
      }
    } catch (e, stackTrace) {
      debugPrint("🔥 Error fetching job detail: $e");
      debugPrint("🔥 StackTrace: $stackTrace");
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Could not load job details.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red,
        colorText: isDark ? Colors.redAccent : Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String getCategoryName() {
    final catId = jobData.value?.categoryId;
    if (catId == null || catId.isEmpty) return '';

    final category = categoryCtrl.categories.firstWhereOrNull(
      (c) => c.id == catId,
    );
    return category?.name ?? '';
  }

  String getLocationName() {
    if (jobData.value == null) return '';
    final provId = jobData.value!.provinceId;
    final distId = jobData.value!.districtId;

    final provName =
        locationCtrl.provinces
            .firstWhereOrNull((p) => p.id == provId)
            ?.nameEn ??
        '';
    final distName =
        locationCtrl.districtsCache[provId]
            ?.firstWhereOrNull((d) => d.id == distId)
            ?.nameEn ??
        '';

    if (distName.isNotEmpty && provName.isNotEmpty) {
      return "$distName, $provName";
    }
    if (provName.isNotEmpty) return provName;
    return "Unknown Location".tr; // 🟢 Added .tr
  }

  String getEmploymentTypeName() {
    final typeId = jobData.value?.employmentTypeId;
    if (typeId == null || typeId.isEmpty) return 'N/A'.tr; // 🟢 Added .tr
    return masterCtrl.getMasterDataName('employment-types', typeId);
  }

  String getSkillName(String skillId) {
    return masterCtrl.getMasterDataName('skills', skillId);
  }

  Future<void> updateJobStatus(String newStatus) async {
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4f7df7),
            strokeWidth: 3,
          ),
        ),
        barrierDismissible: false,
      );

      final success = await _jobService.updateJobStatus(jobId, newStatus);

      Get.back();

      if (success) {
        jobData.value = jobData.value?.copyWith(status: newStatus);

        if (Get.isRegistered<MyJobViewController>()) {
          final listCtrl = Get.find<MyJobViewController>();
          final index = listCtrl.jobs.indexWhere((j) => j.id == jobId);
          if (index != -1) {
            listCtrl.jobs[index] = listCtrl.jobs[index].copyWith(
              status: newStatus,
            );
            listCtrl.jobs.refresh();

            listCtrl.fetchStatusSummary();
          }
        }

        Get.snackbar(
          'Status Updated'.tr, // 🟢 Added .tr
          'The job status has been changed to @status.'.trParams({
            'status': newStatus.tr,
          }), // 🟢 Added .trParams
          backgroundColor: isDark
              ? AppColors.success.withValues(alpha: 0.15)
              : Colors.green,
          colorText: isDark ? Colors.greenAccent : Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        "Update Failed".tr, // 🟢 Added .tr
        e.toString().tr,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red,
        colorText: isDark ? Colors.redAccent : Colors.white,
      );
    }
  }
}
