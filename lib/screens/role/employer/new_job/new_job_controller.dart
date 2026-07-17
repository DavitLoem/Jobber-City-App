part of 'new_job_view.dart';

class NewJobViewController extends GetxController {
  // ==========================================
  // ── 1. Services & Global Data ──
  // ==========================================
  final JobService _jobService = JobService();
  final locationDataCtrl = Get.find<LocationController>();
  final categoryDataCtrl = Get.find<CategoryController>();
  final masterDataCtrl = Get.find<MasterDataController>();

  // ==========================================
  // ── 2. General State (ការគ្រប់គ្រងទូទៅ) ──
  // ==========================================
  final currentStep = 0.obs;
  final isLoading = false.obs;
  final PageController pageController = PageController();

  // ==========================================
  // ── 3. Step 1: Basic Info ──
  // ==========================================
  final titleCtrl = TextEditingController();
  final headcountCtrl = TextEditingController(text: "1");

  final provinceCtrl = TextEditingController();
  final selectedProvinceId = ''.obs;

  final districtCtrl = TextEditingController();
  final selectedDistrictId = ''.obs;

  final categoryTextCtrl = TextEditingController();
  final selectedCategoryId = ''.obs;

  final jobLevelCtrl = TextEditingController();
  final selectedJobLevelId = ''.obs;

  final workTypeCtrl = TextEditingController();
  final selectedWorkTypeId = ''.obs;

  final employmentTypeCtrl = TextEditingController();
  final selectedEmploymentTypeId = ''.obs;

  // ==========================================
  // ── 4. Step 2: Salary ──
  // ==========================================
  final minSalaryCtrl = TextEditingController();
  final maxSalaryCtrl = TextEditingController();
  final salaryPeriodCtrl = TextEditingController(text: "Monthly");
  final isNegotiable = true.obs;

  // ==========================================
  // ── 5. Step 3: Details ──
  // ==========================================
  final educationLevelCtrl = TextEditingController();
  final selectedEducationLevelId = ''.obs;

  final experienceCtrl = TextEditingController();

  final requiredSkillsTextCtrl = TextEditingController();
  final selectedSkillIds = <String>[].obs;
  final selectedSkillNames = <String>[].obs;

  final customSkillsCtrl = TextEditingController();
  final customSkillsList = <String>[].obs;

  final descriptionCtrl = TextEditingController();
  final requirementsCtrl = TextEditingController();
  final benefitsCtrl = TextEditingController();

  // ==========================================
  // ── 6. Step 4: Schedule ──
  // ==========================================
  final startDayCtrl = TextEditingController();
  final endDayCtrl = TextEditingController();
  final startTimeCtrl = TextEditingController();
  final endTimeCtrl = TextEditingController();

  final closingDateCtrl = TextEditingController();
  final selectedClosingDate = Rxn<DateTime>();
  final specificScheduleList = <SpecificSchedule>[].obs;

  // ==========================================
  // ── 7. Methods & Logics ──
  // ==========================================

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  void fetchInitialData() {
    if (categoryDataCtrl.categories.isEmpty) categoryDataCtrl.fetchCategories();
    if (locationDataCtrl.provinces.isEmpty) locationDataCtrl.fetchProvinces();

    masterDataCtrl.getMasterData(endpoint: 'skills');
    masterDataCtrl.getMasterData(endpoint: 'job-levels');
    masterDataCtrl.getMasterData(endpoint: 'employment-types');
    masterDataCtrl.getMasterData(endpoint: 'education-levels');
    masterDataCtrl.getMasterData(endpoint: 'work-types');
  }

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      submitJob();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void addCustomSkill() {
    final skill = customSkillsCtrl.text.trim();
    if (skill.isNotEmpty && !customSkillsList.contains(skill)) {
      customSkillsList.add(skill);
    }
    customSkillsCtrl.clear();
  }

  Future<void> submitJob() async {
    if (!_validateInput()) return;

    isLoading.value = true;
    try {
      final requestData = JobRequestModel(
        title: titleCtrl.text.trim(),
        description: _textToList(descriptionCtrl.text),
        requirements: _textToList(requirementsCtrl.text),
        benefits: _textToList(benefitsCtrl.text),
        requiredSkills: selectedSkillIds.toList(),
        customSkills: customSkillsList.toList(),

        minSalary: num.tryParse(minSalaryCtrl.text) ?? 0,
        maxSalary: num.tryParse(maxSalaryCtrl.text) ?? 0,
        salaryPeriod: salaryPeriodCtrl.text,
        isNegotiable: isNegotiable.value,
        headcount: int.tryParse(headcountCtrl.text) ?? 1,
        experience: experienceCtrl.text.trim(),
        workingDays: "${startDayCtrl.text.trim()} - ${endDayCtrl.text.trim()}",
        workingHours:
            "${startTimeCtrl.text.trim()} - ${endTimeCtrl.text.trim()}",
        specificSchedule: specificScheduleList,

        categoryId: selectedCategoryId.value,
        jobLevelId: selectedJobLevelId.value,
        workTypeId: selectedWorkTypeId.value,
        employmentTypeId: selectedEmploymentTypeId.value,
        educationLevelId: selectedEducationLevelId.value,
        provinceId: selectedProvinceId.value,
        districtId: selectedDistrictId.value,

        closingDate:
            selectedClosingDate.value?.toUtc().toIso8601String() ??
            DateTime.now()
                .add(const Duration(days: 30))
                .toUtc()
                .toIso8601String(),
      );

      await _jobService.createJob(requestData);

      Get.snackbar(
        'Success',
        'Job posted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // (យក Comment ចេញនៅថ្ងៃក្រោយ ពេលអ្នកមាន MyJobController)
      // if (Get.isRegistered<MyJobController>()) {
      //   Get.find<MyJobController>().fetchMyJobs();
      // }
      // await Future.delayed(const Duration(seconds: 1));
      // Get.back();
    } on ApiException catch (e) {
      Get.snackbar(
        "Failed",
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("System Error: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<String> _textToList(String text, {String separator = '\n'}) {
    if (text.trim().isEmpty) return [];
    return text
        .split(separator)
        .map((e) {
          String cleanText = e.trim();
          if (cleanText.startsWith('• ')) {
            cleanText = cleanText.substring(2);
          } else if (cleanText.startsWith('- ')) {
            cleanText = cleanText.substring(2);
          } else if (cleanText.startsWith('•') || cleanText.startsWith('-')) {
            cleanText = cleanText.substring(1);
          }
          return cleanText.trim();
        })
        .where((e) => e.isNotEmpty)
        .toList();
  }

  bool _validateInput() {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Missing Field",
        "Job Title is required.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }
    if (selectedProvinceId.value.isEmpty || selectedCategoryId.value.isEmpty) {
      Get.snackbar(
        "Missing Field",
        "Please complete all basic information.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }
    if (descriptionCtrl.text.trim().length < 10) {
      Get.snackbar(
        "Missing Field",
        "Description must be at least 10 characters.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    // ── Dispose តាមលំដាប់ ──
    pageController.dispose();

    // Step 1
    titleCtrl.dispose();
    headcountCtrl.dispose();
    provinceCtrl.dispose();
    districtCtrl.dispose();
    categoryTextCtrl.dispose();
    jobLevelCtrl.dispose();
    workTypeCtrl.dispose();
    employmentTypeCtrl.dispose();

    // Step 2
    minSalaryCtrl.dispose();
    maxSalaryCtrl.dispose();
    salaryPeriodCtrl.dispose();

    // Step 3
    educationLevelCtrl.dispose();
    experienceCtrl.dispose();
    requiredSkillsTextCtrl.dispose();
    customSkillsCtrl.dispose();
    descriptionCtrl.dispose();
    requirementsCtrl.dispose();
    benefitsCtrl.dispose();

    // Step 4
    startDayCtrl.dispose();
    endDayCtrl.dispose();
    startTimeCtrl.dispose();
    endTimeCtrl.dispose();
    closingDateCtrl.dispose();

    super.onClose();
  }
}
