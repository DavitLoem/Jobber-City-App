part of 'my_job_detail_view.dart';

class MyJobDetailViewController extends GetxController {
  final JobService _jobService = JobService();

  final companyProfile = Rxn<CompanyProfileModel>();

  final masterCtrl = Get.find<MasterDataController>();
  final locationCtrl = Get.find<LocationController>();
  final categoryCtrl = Get.find<CategoryController>();

  // State Variables
  final isLoading = false.obs;
  // សូមដូរ `JobDataModel` ទៅតាមឈ្មោះ Model ពិតប្រាកដរបស់អ្នក
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

    // ឆែកមើលបើអត់មាន ID ឱ្យវាលោតសារ និងថយក្រោយ
    if (Get.arguments == null || Get.arguments is! String) {
      Get.snackbar(
        "Error",
        "Job ID is missing",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    } else {
      _fetchJobDetail();
    }
  }

  // 🎯 ១. មុខងារទាញយកទិន្នន័យការងារ
  Future<void> _fetchJobDetail() async {
    isLoading.value = true;
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

        // ទាញយក District ទុកមុន ដើម្បីឱ្យវាបង្ហាញឈ្មោះស្រុកបាន
        if (jobData.value?.provinceId != null) {
          await locationCtrl.getDistricts(jobData.value!.provinceId);
        }
      } else {
        Get.snackbar(
          "Error",
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      debugPrint("🔥 Error fetching job detail: $e");
      debugPrint("🔥 StackTrace: $stackTrace");
      Get.snackbar(
        "Error",
        "Could not load job details.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String getCategoryName() {
    final catId = jobData.value?.categoryId;
    if (catId == null || catId.isEmpty) return '';

    // រកមើលឈ្មោះ Category ក្នុង List របស់ CategoryController
    final category = categoryCtrl.categories.firstWhereOrNull(
      (c) => c.id == catId,
    );
    return category?.name ?? '';
  }

  // 🎯 ២. មុខងារបំប្លែង ID ទៅជាឈ្មោះ (Helper Functions)

  String getLocationName() {
    if (jobData.value == null) return '';
    final provId = jobData.value!.provinceId;
    final distId = jobData.value!.districtId;

    // ដូរ nameEn ទៅតាម Field ពិតក្នុង LocationModel របស់អ្នក
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
    return "Unknown Location";
  }

  String getEmploymentTypeName() {
    final typeId = jobData.value?.employmentTypeId;
    if (typeId == null || typeId.isEmpty) return 'N/A';
    // 🎯 ហៅប្រើ Generic Method ពី MasterDataController
    return masterCtrl.getMasterDataName('employment-types', typeId);
  }

  String getSkillName(String skillId) {
    return masterCtrl.getMasterDataName('skills', skillId);
  }

  // 🎯 ៣. មុខងារគ្រប់គ្រងការងារ (Actions)

  Future<void> updateJobStatus(String newStatus) async {
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
        // ១. Update UI ក្នុង Detail Screen
        jobData.value = jobData.value?.copyWith(status: newStatus);

        // 🎯 ២. Update UI ក្នុង List Screen ខាងក្រៅ (MyJobViewController)
        if (Get.isRegistered<MyJobViewController>()) {
          final listCtrl = Get.find<MyJobViewController>();
          // ស្វែងរកទីតាំង (Index) នៃការងារនេះក្នុងបញ្ជី
          final index = listCtrl.jobs.indexWhere((j) => j.id == jobId);
          if (index != -1) {
            // Update តែ Item នេះប៉ុណ្ណោះ រួចប្រាប់ Obx ឱ្យគូរឡើងវិញ
            listCtrl.jobs[index] = listCtrl.jobs[index].copyWith(
              status: newStatus,
            );
            listCtrl.jobs.refresh();

            // 🟢 [បន្ថែមថ្មី]: ធ្វើបច្ចុប្បន្នភាពតួលេខនៅលើ Tab (All, Active, Paused...)
            listCtrl.fetchStatusSummary();
          }
        }

        Get.snackbar(
          'Status Updated',
          'The job status has been changed to $newStatus.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        "Update Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
