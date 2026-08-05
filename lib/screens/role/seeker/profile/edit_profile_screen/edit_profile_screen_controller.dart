import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/models/location_model.dart';

import '../../../../../core/api/services/role/seeker/seeker_profile_services.dart';
import '../../../../../models/role/seeker/seeker_profile_model.dart';

class EditProfileScreenViewController extends GetxController {
  final _profileService = SeekerProfileServices();
  final locationController = Get.put(LocationController());

  // ── ១. បង្រួម TextEditingController មកប្រើតែមួយឈុត ──
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final portfolioCtrl = TextEditingController();
  final linkedinCtrl = TextEditingController();
  final currentPositionCtrl = TextEditingController();
  final dateOfBirthCtrl = TextEditingController();
  final nationalityCtrl = TextEditingController();

  // Address Controllers
  final provinceCtrl = TextEditingController();
  final districtCtrl = TextEditingController();
  final communeCtrl = TextEditingController();
  final villageCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final houseNoCtrl = TextEditingController();

  // ── ២. State Variables សម្រាប់ Dropdowns និង UI ──
  var isLoading = true.obs;
  var isSaving = false.obs;
  var isFormValid = false.obs;

  var selectedGender = ''.obs;
  var selectedMaritalStatus = ''.obs;
  var selectedProvinceId = ''.obs;
  var selectedDistrictId = ''.obs;

  // ទុក Array សិន ព្រោះ Payload ទាមទារជា Array
  var selectedCategoryIds = <String>[].obs;

  final profileImageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();

  final List<String> nationalities = [
    'Cambodian',
    'Vietnamese',
    'Chinese',
    'American',
    'French',
    'Japanese',
    'Korean',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    _addValidationListeners();
    fetchProfileData();
  }

  // ── ៣. មុខងារទាញយកទិន្នន័យពី API ──
  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;

      // ទាញយកទិន្នន័យ Profile តាមរយៈ Service ថ្មី
      final response = await _profileService.getSeekerProfile();
      final data = response.data;

      if (data != null) {
        // បញ្ចូលទិន្នន័យទៅក្នុង Controllers
        firstNameCtrl.text = data.firstName;
        lastNameCtrl.text = data.lastName;
        emailCtrl.text = data.email;

        phoneCtrl.text = data.phoneNumber;
        portfolioCtrl.text = data.portfolioUrl;
        linkedinCtrl.text = data.linkedinUrl;
        currentPositionCtrl.text = data.currentPosition;
        dateOfBirthCtrl.text = data.dateOfBirth;
        nationalityCtrl.text = data.nationality;

        communeCtrl.text = data.commune;
        villageCtrl.text = data.village;
        streetCtrl.text = data.street;
        houseNoCtrl.text = data.houseNo;

        selectedGender.value = data.gender;
        selectedMaritalStatus.value = data.maritalStatus;
        profileImageUrl.value = data.profileImageUrl;

        // 🎯 ចាត់ចែង Location (ខេត្ត/ស្រុក សម្រាប់ទីលំនៅបច្ចុប្បន្ន)
        if (data.addressProvinceId.isNotEmpty) {
          selectedProvinceId.value = data.addressProvinceId;
          await locationController.fetchProvinces();

          // ស្វែងរកឈ្មោះខេត្តយកមកបង្ហាញលើប្រអប់ Text
          try {
            final matchedProvince = locationController.provinces.firstWhere(
              (p) => p.id.toString() == data.addressProvinceId,
            );
            provinceCtrl.text = matchedProvince.nameEn; // បង្ហាញឈ្មោះខេត្ត
          } catch (e) {
            debugPrint("Province not found in list: $e");
          }

          if (data.addressDistrictId.isNotEmpty) {
            selectedDistrictId.value = data.addressDistrictId;

            // 🎯 ចាប់យក List ស្រុកដែល return មកពីមុខងារ getDistricts
            final fetchedDistricts = await locationController.getDistricts(
              data.addressProvinceId,
            );

            // ស្វែងរកឈ្មោះស្រុកយកមកបង្ហាញលើប្រអប់ Text
            try {
              final matchedDistrict = fetchedDistricts.firstWhere(
                (d) => d.id.toString() == data.addressDistrictId,
              );
              districtCtrl.text = matchedDistrict.nameEn; // បង្ហាញឈ្មោះស្រុក
            } catch (e) {
              debugPrint("District not found in list: $e");
            }
          }
        }

        // ចាត់ចែង Expertise Category
        if (data.expertiseCategoryIds.isNotEmpty) {
          selectedCategoryIds.assignAll(data.expertiseCategoryIds);
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Cannot fetch Profile: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── ៤. មុខងារបញ្ជូនទិន្នន័យទៅ Update ──
  Future<void> updateProfile() async {
    if (!isFormValid.value) {
      Get.snackbar("Notice", "Please fill in all required fields!");
      return;
    }

    isSaving.value = true;
    try {
      // វេចខ្ចប់ទិន្នន័យដោយប្រើ Request Model ថ្មី
      final requestData = SeekerCoreUpdateRequest(
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        dateOfBirth: dateOfBirthCtrl.text.trim(),
        gender: selectedGender.value,
        maritalStatus: selectedMaritalStatus.value,
        nationality: nationalityCtrl.text.trim(),
        currentPosition: currentPositionCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phoneNumber: phoneCtrl.text.trim(),

        addressProvinceId: selectedProvinceId.value,
        addressDistrictId: selectedDistrictId.value,
        commune: communeCtrl.text.trim(),
        village: villageCtrl.text.trim(),
        street: streetCtrl.text.trim(),
        houseNo: houseNoCtrl.text.trim(),
        biography: '', // បើមាន UI អាចថែម Controller ទីនេះ
        expectedSalaryMin: 0,
        expectedSalaryMax: 0,
        jobTypePreferences: [], // ដាក់ Default សិនបើអត់ទាន់មាន UI
        expertiseCategoryIds: selectedCategoryIds.toList(),
        skills: [],
        portfolioUrl: portfolioCtrl.text.trim(),
        linkedinUrl: linkedinCtrl.text.trim(),
        onboardingCompleted: true, // កំណត់ True ដើម្បីបញ្ចប់វគ្គ Onboarding
      );

      final success = await _profileService.updateCoreProfile(requestData);

      if (success) {
        Get.back(result: currentPositionCtrl.text.trim());
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Update failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<List<LocationModel>> fetchProvinceOptions() async {
    if (locationController.provinces.isEmpty) {
      await locationController.fetchProvinces();
    }
    return locationController.provinces;
  }

  // មុខងារទាញយកបញ្ជីស្រុក ផ្អែកលើខេត្តដែលបានជ្រើសរើស
  Future<List<LocationModel>> fetchDistrictOptions() async {
    if (selectedProvinceId.value.isEmpty) return [];
    return await locationController.getDistricts(selectedProvinceId.value);
  }

  // ── មុខងារជ្រើសរើស និង Upload រូបភាព (Profile Image) ──
  Future<void> pickProfileImage() async {
    // ១. ជ្រើសរើសរូបភាពពី Gallery
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        isSaving.value = true;

        Get.snackbar(
          'Uploading...',
          'Please wait while your profile picture is being updated.',
          showProgressIndicator: true,
          snackPosition: SnackPosition.TOP,
        );

        final response = await _profileService.profileImage(pickedFile.path);

        // ទាញយក URL ថ្មីពី Response របស់ API ដើម្បី Update UI
        if (response['success'] == true && response['data'] != null) {
          final newImageUrl = response['data']['profile_image_url'] ?? '';

          if (newImageUrl.isNotEmpty) {
            // Update អថេរ ដើម្បីឱ្យ Obx នៅលើ Header ប្តូររូបភាពភ្លាមៗ
            profileImageUrl.value = newImageUrl;
          }
        }

        Get.closeAllSnackbars();
        Get.snackbar(
          'Success',
          'Profile picture updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } catch (e) {
        Get.closeAllSnackbars();
        Get.snackbar(
          'Upload Failed',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        isSaving.value = false;
      }
    }
  }

  // ── ៥. Validation & Helpers ──
  void _addValidationListeners() {
    final controllers = [
      firstNameCtrl,
      lastNameCtrl,
      emailCtrl,
      phoneCtrl,
      currentPositionCtrl,
      dateOfBirthCtrl,
    ];
    for (var ctrl in controllers) {
      ctrl.addListener(_validateForm);
    }
    selectedGender.listen((_) => _validateForm());
    selectedMaritalStatus.listen((_) => _validateForm());
    selectedProvinceId.listen((_) => _validateForm());
    selectedDistrictId.listen((_) => _validateForm());
  }

  void _validateForm() {
    isFormValid.value =
        firstNameCtrl.text.trim().isNotEmpty &&
        lastNameCtrl.text.trim().isNotEmpty &&
        emailCtrl.text.trim().isNotEmpty &&
        phoneCtrl.text.trim().isNotEmpty &&
        selectedGender.value.isNotEmpty &&
        selectedProvinceId.value.isNotEmpty &&
        selectedDistrictId.value.isNotEmpty;
  }

  void selectDate() {
    showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        // 🎯 កែទម្រង់ទៅជា YYYY-MM-DD សម្រាប់ API
        final formattedDate =
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        dateOfBirthCtrl.text = formattedDate;
      }
    });
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    currentPositionCtrl.dispose();
    dateOfBirthCtrl.dispose();
    nationalityCtrl.dispose();
    provinceCtrl.dispose();
    districtCtrl.dispose();
    communeCtrl.dispose();
    villageCtrl.dispose();
    streetCtrl.dispose();
    houseNoCtrl.dispose();
    super.onClose();
  }
}
