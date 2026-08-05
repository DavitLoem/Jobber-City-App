part of 'cv_review_view.dart';

class CvReviewViewController extends GetxController {
  // 🎯 ១. អថេរសម្រាប់បង្ហាញ State Loading ពេលចុច Save
  final isLoading = false.obs;

  // 🎯 ២. TextControllers សម្រាប់គ្រប់គ្រងទិន្នន័យ Personal Info
  // (ងាយស្រួលភ្ជាប់ទៅកាន់ TextField នៅលើ UI)
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final bioCtrl = TextEditingController();

  final skillInputCtrl = TextEditingController(); // សម្រាប់វាយបញ្ចូលជំនាញថ្មី

  // 🎯 ៣. Observable Lists សម្រាប់បទពិសោធន៍ ការសិក្សា និងជំនាញ
  // (.obs ជួយឱ្យ UI ប្រែប្រួលភ្លាមៗពេលយើង លុប ឬ បន្ថែម)
  final skills = <String>[].obs;
  final experiences = <ExperienceModel>[].obs;
  final educations = <EducationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDataFromArguments();
  }

  // 🎯 ៤. មុខងារទាញយកទិន្នន័យដែលបោះមកពីអេក្រង់ Upload CV
  void _loadDataFromArguments() {
    // រំពឹងថាទិន្នន័យនឹងត្រូវបោះមកតាម Get.toNamed(..., arguments: parsedData)
    if (Get.arguments != null && Get.arguments is ParsedDataModel) {
      final ParsedDataModel data = Get.arguments;

      // បញ្ចូលទិន្នន័យទៅក្នុង TextController (បើមាន)
      if (data.personalInfo != null) {
        firstNameCtrl.text = data.personalInfo!.firstName ?? '';
        lastNameCtrl.text = data.personalInfo!.lastName ?? '';
        emailCtrl.text = data.personalInfo!.email ?? '';
        phoneCtrl.text = data.personalInfo!.phoneNumber ?? '';
        bioCtrl.text = data.personalInfo!.biography ?? '';
      }

      // បញ្ចូលទិន្នន័យទៅក្នុង Observable Lists
      skills.assignAll(data.skills);
      experiences.assignAll(data.experiences);
      educations.assignAll(data.educations);
    }
  }

  // ==========================================
  // ផ្នែកគ្រប់គ្រង ជំនាញ (Skills)
  // ==========================================
  void addSkill() {
    final newSkill = skillInputCtrl.text.trim();
    if (newSkill.isNotEmpty && !skills.contains(newSkill)) {
      skills.add(newSkill);
      skillInputCtrl.clear();
    }
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  // ==========================================
  // ផ្នែកគ្រប់គ្រង បទពិសោធន៍ (Experience)
  // ==========================================
  void removeExperience(int index) {
    experiences.removeAt(index);
  }

  void addOrUpdateExperience(ExperienceModel exp, {int? index}) {
    if (index != null) {
      experiences[index] = exp; // ករណីកែប្រែ (Edit)
    } else {
      experiences.add(exp); // ករណីថែមថ្មី (Add)
    }
  }

  // ==========================================
  // ផ្នែកគ្រប់គ្រង ប្រវត្តិសិក្សា (Education)
  // ==========================================
  void removeEducation(int index) {
    educations.removeAt(index);
  }

  void addOrUpdateEducation(EducationModel edu, {int? index}) {
    if (index != null) {
      educations[index] = edu; // ករណីកែប្រែ (Edit)
    } else {
      educations.add(edu); // ករណីថែមថ្មី (Add)
    }
  }

  // ==========================================
  // ផ្នែករក្សាទុកទិន្នន័យចុងក្រោយ (Save Data)
  // ==========================================
  Future<void> saveReviewedData() async {
    try {
      isLoading.value = true;

      // 🎯 TODO: នៅទីនេះ អ្នកនឹងត្រូវហៅ API Service ដើម្បីបញ្ជូនទិន្នន័យទៅ Backend
      // ឧទាហរណ៍៖
      // final coreProfileUpdate = SeekerCoreUpdateRequest(
      //    firstName: firstNameCtrl.text,
      //    skills: skills.toList(),
      //    ...
      // );
      // await profileService.updateCoreProfile(coreProfileUpdate);
      // await profileService.saveExperiences(experiences.toList());

      // សាកល្បង Delay សិន (លុបចោលពេលភ្ជាប់ API ពិត)
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Your profile has been updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // បន្ទាប់ពី Save ជោគជ័យ បញ្ជូនបេក្ខជនត្រឡប់ទៅអេក្រង់ Profile ដើមវិញ
      Get.back(); // ឬប្រើ Get.offAllNamed ទៅតាម Navigation Flow របស់អ្នក
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // កុំភ្លេច Dispose Controllers ពេលបិទអេក្រង់ ដើម្បីសន្សំ Memory
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    bioCtrl.dispose();
    skillInputCtrl.dispose();
    super.onClose();
  }
}
