part of 'post_job_screen_view.dart';

class DropdownItem {
  final String id;
  final String name;
  DropdownItem({required this.id, required this.name});
}

class PostJobScreenViewController extends GetxController {
  final JobServices _jobServices = JobServices();

  final isLoading = false.obs;

  final currentStep = 0.obs;
  final totalSteps = 4;
  final PageController pageController = PageController();

  final titleCtrl = TextEditingController();
  final provinceCtrl = TextEditingController();
  final districtCtrl = TextEditingController();

  final minSalaryCtrl = TextEditingController();
  final maxSalaryCtrl = TextEditingController();
  final headCountCtrl = TextEditingController(text: '1');
  final experienceCtrl = TextEditingController(text: '1-3 Years');

  final workingDaysCtrl = TextEditingController(text: 'Mon - Fri');
  final workingHoursCtrl = TextEditingController(text: '8:00 AM - 5:00 PM');
  final emailCtrl = TextEditingController();
  final telegramCtrl = TextEditingController();

  final descCtrl = TextEditingController();
  final reqCtrl = TextEditingController();
  final aboutCompanyCtrl = TextEditingController();
  final benefitInputCtrl = TextEditingController();
  final benefits = <String>[].obs;

  final skillNameCtrl = TextEditingController();
  final selectedSkillIds = <String>[].obs;
  final selectedSkillNames = <String>[].obs;

  final salaryPeriod = 'Monthly'.obs;
  final isNegotiable = true.obs;
  final closingDate = ''.obs;

  final categoryNameCtrl = TextEditingController();
  final jobLevelNameCtrl = TextEditingController();
  final workTypeNameCtrl = TextEditingController();
  final employmentTypeNameCtrl = TextEditingController();
  final educationLevelNameCtrl = TextEditingController();

  final categoryId = ''.obs;
  final jobLevelId = ''.obs;
  final workTypeId = ''.obs;
  final employmentTypeId = ''.obs;
  final educationLevelId = ''.obs;
  final provinceId = ''.obs;
  final districtId = ''.obs;

  final companyLogoUrl = ''.obs;

  final experienceOptions = <DropdownItem>[
    DropdownItem(id: 'no_exp', name: 'No Experience'.tr),
    DropdownItem(id: 'under_1', name: 'Under 1 Year'.tr),
    DropdownItem(id: '1_3', name: '1-3 Years'.tr),
    DropdownItem(id: '3_5', name: '3-5 Years'.tr),
    DropdownItem(id: '5_plus', name: '5+ Years'.tr),
  ];

  final workingDaysOptions = <DropdownItem>[
    DropdownItem(id: 'mon_fri', name: 'Mon - Fri'.tr),
    DropdownItem(id: 'mon_sat', name: 'Mon - Sat'.tr),
    DropdownItem(id: 'sun_thu', name: 'Sun - Thu'.tr),
    DropdownItem(id: 'all_days', name: 'All Days'.tr),
    DropdownItem(id: 'custom', name: 'Custom'.tr),
  ];

  final workingHoursOptions = <DropdownItem>[
    DropdownItem(id: '8:00 AM - 5:00 PM', name: '8:00 AM - 5:00 PM'),
    DropdownItem(id: '9:00 AM - 6:00 PM', name: '9:00 AM - 6:00 PM'),
    DropdownItem(id: '7:00 AM - 4:00 PM', name: '7:00 AM - 4:00 PM'),
    DropdownItem(id: '10:00 AM - 7:00 PM', name: '10:00 AM - 7:00 PM'),
    DropdownItem(id: 'flexible', name: 'Flexible'.tr),
    DropdownItem(id: 'shift_based', name: 'Shift Based'.tr),
  ];

  final salaryPeriodOptions = const ['Monthly', 'Weekly', 'Yearly'];

  @override
  Future<void> onInit() async {
    super.onInit();
    closingDate.value = DateTime.now()
        .add(const Duration(days: 30))
        .toIso8601String();
    await _prefillContactEmail();
  }

  Future<void> _prefillContactEmail() async {
    final args = Get.arguments;
    if (args != null && args is Map && args['email'] != null) {
      emailCtrl.text = args['email'].toString();
    }

    const storage = FlutterSecureStorage();
    final email = await storage.read(key: 'company_contact_email');
    if (email != null && email.isNotEmpty) {
      emailCtrl.text = email;
    }

    final tempEmail = await storage.read(key: 'temp_email');
    if (emailCtrl.text.isEmpty && tempEmail != null && tempEmail.isNotEmpty) {
      emailCtrl.text = tempEmail;
    }

    final logoUrl = await storage.read(key: 'company_logo_url');
    if (logoUrl != null && logoUrl.isNotEmpty) {
      companyLogoUrl.value = logoUrl;
    }
  }

  Future<void> selectClosingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) closingDate.value = picked.toIso8601String();
  }

  void addBenefit() {
    final text = benefitInputCtrl.text.trim();
    if (text.isEmpty) return;
    benefits.add(text);
    benefitInputCtrl.clear();
  }

  void removeBenefit(int index) => benefits.removeAt(index);

  void addSkill(String id, String name) {
    if (id.isEmpty || selectedSkillIds.contains(id)) return;
    selectedSkillIds.add(id);
    selectedSkillNames.add(name);
  }

  void removeSkill(int index) {
    selectedSkillIds.removeAt(index);
    selectedSkillNames.removeAt(index);
  }

  List<String> _splitText(String text) {
    if (text.trim().isEmpty) return [];
    return text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  bool _validateStep(int step) {
    switch (step) {
      case 0:
        if (titleCtrl.text.trim().isEmpty ||
            provinceId.value.isEmpty ||
            districtId.value.isEmpty) {
          Get.snackbar(
            'Notice'.tr,
            'Please fill Job Title, Province, and District.'.tr,
            backgroundColor: AppColors.warning,
            colorText: Colors.white,
          );
          return false;
        }
        return true;
      case 1:
        if (minSalaryCtrl.text.trim().isEmpty ||
            maxSalaryCtrl.text.trim().isEmpty ||
            headCountCtrl.text.trim().isEmpty) {
          Get.snackbar(
            'Notice'.tr,
            'Please fill Salary Range and Number of Vacancies.'.tr,
            backgroundColor: AppColors.warning,
            colorText: Colors.white,
          );
          return false;
        }
        return true;
      case 2:
        if (descCtrl.text.trim().isEmpty || reqCtrl.text.trim().isEmpty) {
          Get.snackbar(
            'Notice'.tr,
            'Please fill Job Description and Minimum Qualifications.'.tr,
            backgroundColor: AppColors.warning,
            colorText: Colors.white,
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void goToStep(int step) {
    currentStep.value = step;
    pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void nextStep() {
    if (!_validateStep(currentStep.value)) return;
    if (currentStep.value == totalSteps - 1) {
      submitJob();
      return;
    }
    goToStep(currentStep.value + 1);
  }

  void previousStep() {
    if (currentStep.value == 0) return;
    goToStep(currentStep.value - 1);
  }

  Future<void> submitJob() async {
    if (workingDaysCtrl.text.trim().isEmpty ||
        workingHoursCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Notice'.tr,
        'Please fill Working Days and Working Hours!'.tr,
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedSkillIds.isEmpty) {
      Get.snackbar(
        'Notice'.tr,
        'Please select at least one required skill.'.tr,
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final realBenefits = benefits
          .where((b) => b.toLowerCase() != 'not specified')
          .toList();
      final benefitsList = realBenefits.isNotEmpty
          ? realBenefits
          : ['Not specified'.tr];
      final skillsList = selectedSkillIds.toList();

      final requestData = JobPostModel(
        title: titleCtrl.text.trim(),
        description: _splitText(descCtrl.text),
        requirements: _splitText(reqCtrl.text),
        benefits: benefitsList,
        requiredSkills: skillsList,

        minSalary: int.tryParse(minSalaryCtrl.text) ?? 0,
        maxSalary: int.tryParse(maxSalaryCtrl.text) ?? 0,
        headcount: int.tryParse(headCountCtrl.text) ?? 1,

        salaryPeriod: salaryPeriod.value,
        isNegotiable: isNegotiable.value,
        experience: experienceCtrl.text.trim(),
        workingDays: workingDaysCtrl.text.trim(),
        workingHours: workingHoursCtrl.text.trim(),

        specificSchedule: [
          SpecificSchedule(
            day: workingDaysCtrl.text.trim(),
            hours: workingHoursCtrl.text.trim(),
          ),
        ],

        categoryId: categoryId.value,
        jobLevelId: jobLevelId.value,
        workTypeId: workTypeId.value,
        employmentTypeId: employmentTypeId.value,
        educationLevelId: educationLevelId.value,
        provinceId: provinceId.value,
        districtId: districtId.value,
        closingDate: closingDate.value,
      );

      await _jobServices.postJob(requestData);

      Get.snackbar(
        'Success'.tr,
        'Job Posted Successfully!'.tr,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to post job: @error'.trParams({'error': e.toString()}),
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    titleCtrl.dispose();
    provinceCtrl.dispose();
    districtCtrl.dispose();
    minSalaryCtrl.dispose();
    maxSalaryCtrl.dispose();
    headCountCtrl.dispose();
    experienceCtrl.dispose();
    workingDaysCtrl.dispose();
    workingHoursCtrl.dispose();
    emailCtrl.dispose();
    telegramCtrl.dispose();
    descCtrl.dispose();
    reqCtrl.dispose();
    aboutCompanyCtrl.dispose();
    benefitInputCtrl.dispose();
    skillNameCtrl.dispose();
    categoryNameCtrl.dispose();
    jobLevelNameCtrl.dispose();
    workTypeNameCtrl.dispose();
    employmentTypeNameCtrl.dispose();
    educationLevelNameCtrl.dispose();
    super.onClose();
  }
}
