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
  // ── 2. General State ──
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

    titleCtrl.text = job.title;
    headcountCtrl.text = job.headcount.toString();

    selectedProvinceId.value = job.provinceId;
    selectedDistrictId.value = job.districtId;
    selectedCategoryId.value = job.categoryId;
    selectedJobLevelId.value = job.jobLevelId;
    selectedWorkTypeId.value = job.workTypeId;
    selectedEmploymentTypeId.value = job.employmentTypeId;

    if (job.provinceId.isNotEmpty) {
      try {
        provinceCtrl.text = locationDataCtrl.provinces
            .firstWhere((p) => p.id == job.provinceId)
            .nameEn;

        if (job.districtId.isNotEmpty) {
          final districts = await locationDataCtrl.getDistricts(job.provinceId);
          districtCtrl.text = districts
              .firstWhere((d) => d.id == job.districtId)
              .nameEn;
        }
      } catch (_) {}
    }

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

    Future<String> getMasterName(String endpoint, String id) async {
      if (id.isEmpty) return "";
      try {
        final list = await masterDataCtrl.getMasterData(endpoint: endpoint);
        return list.firstWhere((e) => e.id == id).name;
      } catch (_) {
        return "";
      }
    }

    jobLevelCtrl.text = await getMasterName('job-levels', job.jobLevelId);
    workTypeCtrl.text = await getMasterName('work-types', job.workTypeId);
    employmentTypeCtrl.text = await getMasterName(
      'employment-types',
      job.employmentTypeId,
    );
    selectedEducationLevelId.value = job.educationLevelId;
    educationLevelCtrl.text = await getMasterName(
      'education-levels',
      job.educationLevelId,
    );

    minSalaryCtrl.text = job.minSalary > 0 ? job.minSalary.toString() : "";
    maxSalaryCtrl.text = job.maxSalary > 0 ? job.maxSalary.toString() : "";
    salaryPeriodCtrl.text = job.salaryPeriod.isNotEmpty
        ? job.salaryPeriod
        : "Monthly";
    isNegotiable.value = job.isNegotiable;

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
        requiredSkillsTextCtrl.text = skillNames.join(', ');
      } catch (_) {}
    }

    descriptionCtrl.text = job.description.isNotEmpty
        ? job.description.map((e) => '• $e').join('\n')
        : '';

    requirementsCtrl.text = job.requirements.isNotEmpty
        ? job.requirements.map((e) => '• $e').join('\n')
        : '';

    benefitsCtrl.text = job.benefits.isNotEmpty
        ? job.benefits.map((e) => '• $e').join('\n')
        : '';

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

    if (job.closingDate.isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(job.closingDate).toLocal();
        selectedClosingDate.value = parsedDate;
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
    final isDark = Get.isDarkMode; // 🟢 Check Theme

    if (!_validateInput(isDark)) return;

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

      if (isEditing) {
        await _jobService.updateJob(editJobData!.id, requestData);
        Get.back();

        if (Get.isRegistered<MyJobViewController>()) {
          final listCtrl = Get.find<MyJobViewController>();
          final index = listCtrl.jobs.indexWhere(
            (j) => j.id == editJobData!.id,
          );

          if (index != -1) {
            listCtrl.jobs[index] = listCtrl.jobs[index].copyWith(
              title: requestData.title,
              minSalary: requestData.minSalary,
              maxSalary: requestData.maxSalary,
              salaryPeriod: requestData.salaryPeriod,
              isNegotiable: requestData.isNegotiable,
              headcount: requestData.headcount,
              experience: requestData.experience,
              workingDays: requestData.workingDays,
              workingHours: requestData.workingHours,
              categoryId: requestData.categoryId,
              jobLevelId: requestData.jobLevelId,
              workTypeId: requestData.workTypeId,
              employmentTypeId: requestData.employmentTypeId,
              educationLevelId: requestData.educationLevelId,
              provinceId: requestData.provinceId,
              districtId: requestData.districtId,
              closingDate: requestData.closingDate,
            );
            listCtrl.jobs.refresh();
          }
        }

        if (Get.isRegistered<MyJobDetailViewController>()) {
          final detailCtrl = Get.find<MyJobDetailViewController>();
          if (detailCtrl.jobData.value != null &&
              detailCtrl.jobData.value!.id == editJobData!.id) {
            detailCtrl.jobData.value = detailCtrl.jobData.value!.copyWith(
              title: requestData.title,
              description: requestData.description,
              requirements: requestData.requirements,
              benefits: requestData.benefits,
              minSalary: requestData.minSalary,
              maxSalary: requestData.maxSalary,
              salaryPeriod: requestData.salaryPeriod,
              isNegotiable: requestData.isNegotiable,
              headcount: requestData.headcount,
              experience: requestData.experience,
              workingDays: requestData.workingDays,
              workingHours: requestData.workingHours,
              specificSchedule: requestData.specificSchedule,
              categoryId: requestData.categoryId,
              jobLevelId: requestData.jobLevelId,
              workTypeId: requestData.workTypeId,
              employmentTypeId: requestData.employmentTypeId,
              educationLevelId: requestData.educationLevelId,
              provinceId: requestData.provinceId,
              districtId: requestData.districtId,
              requiredSkills: requestData.requiredSkills,
              customSkills: requestData.customSkills,
              closingDate: requestData.closingDate,
            );
          }
        }
      } else {
        await _jobService.createJob(requestData);
        Get.back();

        if (Get.isRegistered<MyJobViewController>()) {
          final listCtrl = Get.find<MyJobViewController>();
          listCtrl.fetchJobs(isRefresh: true);
          listCtrl.fetchStatusSummary();
        }
      }

      Get.snackbar(
        'Success'.tr, // 🟢 Added .tr
        isEditing
            ? 'Job updated successfully!'.tr
            : 'Job posted successfully!'.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.green,
        colorText: isDark ? Colors.greenAccent : Colors.white,
      );
    } on ApiException catch (e) {
      Get.snackbar(
        "Failed".tr, // 🟢 Added .tr
        e.message.tr, // 🟢 Optional Backend Msg mapping
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red,
        colorText: isDark ? Colors.redAccent : Colors.white,
      );
    } catch (e) {
      debugPrint("System Error: $e");
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "An unexpected error occurred. Please try again.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red,
        colorText: isDark ? Colors.redAccent : Colors.white,
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

  bool _validateInput(bool isDark) {
    // 🟢 Pass Theme
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Missing Field".tr, // 🟢 Added .tr
        "Job Title is required.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange,
        colorText: isDark ? Colors.orangeAccent : Colors.white,
      );
      return false;
    }
    if (selectedProvinceId.value.isEmpty || selectedCategoryId.value.isEmpty) {
      Get.snackbar(
        "Missing Field".tr, // 🟢 Added .tr
        "Please complete all basic information.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange,
        colorText: isDark ? Colors.orangeAccent : Colors.white,
      );
      return false;
    }
    if (descriptionCtrl.text.trim().length < 10) {
      Get.snackbar(
        "Missing Field".tr, // 🟢 Added .tr
        "Description must be at least 10 characters.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange,
        colorText: isDark ? Colors.orangeAccent : Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    pageController.dispose();

    titleCtrl.dispose();
    headcountCtrl.dispose();
    provinceCtrl.dispose();
    districtCtrl.dispose();
    categoryTextCtrl.dispose();
    jobLevelCtrl.dispose();
    workTypeCtrl.dispose();
    employmentTypeCtrl.dispose();

    minSalaryCtrl.dispose();
    maxSalaryCtrl.dispose();
    salaryPeriodCtrl.dispose();

    educationLevelCtrl.dispose();
    experienceCtrl.dispose();
    requiredSkillsTextCtrl.dispose();
    customSkillsCtrl.dispose();
    descriptionCtrl.dispose();
    requirementsCtrl.dispose();
    benefitsCtrl.dispose();

    startDayCtrl.dispose();
    endDayCtrl.dispose();
    startTimeCtrl.dispose();
    endTimeCtrl.dispose();
    closingDateCtrl.dispose();

    super.onClose();
  }
}
