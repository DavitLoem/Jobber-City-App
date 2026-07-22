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
  // ── 7. Edit Job ──
  // ==========================================
  JobDataModel? editJobData;
  bool get isEditing => editJobData != null;

  final isPrefilling = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();

    if (Get.arguments != null && Get.arguments is JobDataModel) {
      editJobData = Get.arguments as JobDataModel;

      _prefillData();
    }
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

  Future<void> _prefillData() async {
    if (editJobData == null) return;
    final job = editJobData!;

    isPrefilling.value = true;

    // ================= 1. Basic Info =================
    titleCtrl.text = job.title;
    headcountCtrl.text = job.headcount.toString();

    selectedProvinceId.value = job.provinceId;
    selectedDistrictId.value = job.districtId;
    selectedCategoryId.value = job.categoryId;
    selectedJobLevelId.value = job.jobLevelId;
    selectedWorkTypeId.value = job.workTypeId;
    selectedEmploymentTypeId.value = job.employmentTypeId;

    // ក. ទាញយកឈ្មោះ Province និង District
    if (job.provinceId.isNotEmpty) {
      try {
        provinceCtrl.text = locationDataCtrl.provinces
            .firstWhere((p) => p.id == job.provinceId)
            .nameEn;

        // 🎯 ដំណោះស្រាយ District: ត្រូវរង់ចាំទាញយក District តាម Province ID សិន
        if (job.districtId.isNotEmpty) {
          final districts = await locationDataCtrl.getDistricts(job.provinceId);
          districtCtrl.text = districts
              .firstWhere((d) => d.id == job.districtId)
              .nameEn;
        }
      } catch (_) {}
    }

    // ខ. ទាញយកឈ្មោះ Category
    if (job.categoryId.isNotEmpty) {
      try {
        categoryTextCtrl.text = categoryDataCtrl.categories
            .firstWhere((c) => c.id == job.categoryId)
            .name;
      } catch (_) {
      } finally {
        isPrefilling.value = false;
      }
    }

    // គ. 🎯 ដំណោះស្រាយ Master Data (Job Level, Work Type, Employment Type, Education Level)
    // បង្កើតមុខងារតូចមួយដើម្បីរង់ចាំទាញយក និងរកឈ្មោះចេញពី MasterDataController
    Future<String> getMasterName(String endpoint, String id) async {
      if (id.isEmpty) return "";
      try {
        final list = await masterDataCtrl.getMasterData(endpoint: endpoint);
        return list.firstWhere((e) => e.id == id).name;
      } catch (_) {
        return "";
      }
    }

    // រង់ចាំយកឈ្មោះមកញាត់ចូល Controller នីមួយៗ
    jobLevelCtrl.text = await getMasterName('job-levels', job.jobLevelId);
    workTypeCtrl.text = await getMasterName('work-types', job.workTypeId);
    employmentTypeCtrl.text = await getMasterName(
      'employment-types',
      job.employmentTypeId,
    );
    selectedEducationLevelId.value = job.educationLevelId; // កុំភ្លេច Assign ID
    educationLevelCtrl.text = await getMasterName(
      'education-levels',
      job.educationLevelId,
    );

    // ================= 2. Salary =================
    minSalaryCtrl.text = job.minSalary > 0 ? job.minSalary.toString() : "";
    maxSalaryCtrl.text = job.maxSalary > 0 ? job.maxSalary.toString() : "";
    salaryPeriodCtrl.text = job.salaryPeriod.isNotEmpty
        ? job.salaryPeriod
        : "Monthly";
    isNegotiable.value = job.isNegotiable;

    // ================= 3. Details =================
    experienceCtrl.text = job.experience;

    selectedSkillIds.assignAll(job.requiredSkills);
    customSkillsList.assignAll(job.customSkills);

    if (job.requiredSkills.isNotEmpty) {
      try {
        final skillsList = await masterDataCtrl.getMasterData(
          endpoint: 'skills',
        );
        final List<String> skillNames = [];

        for (String skillId in job.requiredSkills) {
          try {
            final name = skillsList.firstWhere((s) => s.id == skillId).name;
            skillNames.add(name);
          } catch (_) {}
        }

        selectedSkillNames.assignAll(skillNames);
        // បង្ហាញឈ្មោះនៅលើ TextField ដោយប្រើសញ្ញាក្បៀស
        requiredSkillsTextCtrl.text = skillNames.join(', ');
      } catch (_) {}
    }

    // ប្រើ map ដើម្បីបន្ថែម '• '
    descriptionCtrl.text = job.description.isNotEmpty
        ? job.description.map((e) => '• $e').join('\n')
        : '';

    requirementsCtrl.text = job.requirements.isNotEmpty
        ? job.requirements.map((e) => '• $e').join('\n')
        : '';

    benefitsCtrl.text = job.benefits.isNotEmpty
        ? job.benefits.map((e) => '• $e').join('\n')
        : '';

    // ================= 4. Schedule =================
    if (job.workingDays.contains('-')) {
      final days = job.workingDays.split('-');
      startDayCtrl.text = days.first.trim();
      if (days.length > 1) endDayCtrl.text = days.last.trim();
    } else {
      startDayCtrl.text = job.workingDays;
    }

    if (job.workingHours.contains('-')) {
      final hours = job.workingHours.split('-');
      startTimeCtrl.text = hours.first.trim();
      if (hours.length > 1) endTimeCtrl.text = hours.last.trim();
    } else {
      startTimeCtrl.text = job.workingHours;
    }

    // 🎯 ដំណោះស្រាយ Closing Date: បន្ថែមការញាត់អត្ថបទចូល closingDateCtrl
    if (job.closingDate.isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(job.closingDate).toLocal();
        selectedClosingDate.value = parsedDate;
        // បំប្លែងថ្ងៃខែឆ្នាំទៅជាទម្រង់ YYYY-MM-DD សម្រាប់បង្ហាញលើ TextField (អ្នកអាចប្តូរទម្រង់តាមចិត្ត)
        closingDateCtrl.text =
            "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
      } catch (_) {}
    }

    specificScheduleList.assignAll(job.specificSchedule);
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

      // ── 🎯 ដំណោះស្រាយ Update ចេញកាតថ្មី ──
      if (isEditing) {
        // ប្រើ updateJob ប្រសិនបើជាការ Edit
        await _jobService.updateJob(editJobData!.id, requestData);
      } else {
        // ប្រើ createJob ប្រសិនបើជាការបង្កើតថ្មី
        await _jobService.createJob(requestData);
      }

      Get.back();

      // ប្តូរពាក្យ Success ទៅតាមសកម្មភាពជាក់ស្តែង
      Get.snackbar(
        'Success',
        isEditing ? 'Job updated successfully!' : 'Job posted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      if (Get.isRegistered<MyJobViewController>()) {
        Get.find<MyJobViewController>().fetchJobs(isRefresh: true);
      }
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
