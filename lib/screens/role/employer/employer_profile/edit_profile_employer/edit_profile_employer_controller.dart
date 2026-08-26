part of 'edit_profile_employer_view.dart';

class EditProfileEmployerViewController extends GetxController {
  final CompanyProfileService _profileService = CompanyProfileService();

  final masterCtrl = Get.find<MasterDataController>();
  final locationCtrl = Get.find<LocationController>();

  final companyNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final selectedIndustryId = ''.obs;
  final selectedCompanySize = ''.obs;
  final selectedProvinceId = ''.obs;
  final selectedDistrictId = ''.obs;

  final isLoading = false.obs;

  final companySizeList = ["1-10", "11-50", "51-200", "201-500", "500+"].obs;
  final districtsList = <LocationModel>[].obs;

  final logoImage = Rxn<File>();
  final isUploadingLogo = false.obs;
  final ImagePicker _picker = ImagePicker();
  final existingLogoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (masterCtrl.masterDataCache['industries'] == null) {
      await masterCtrl.getMasterData(endpoint: 'industries');
    }
    if (locationCtrl.provinces.isEmpty) {
      await locationCtrl.fetchProvinces();
    }

    _prefillData();
  }

  void _prefillData() {
    if (Get.isRegistered<EmployerProfileViewController>()) {
      final existingProfile =
          Get.find<EmployerProfileViewController>().companyProfile.value;

      if (existingProfile != null) {
        companyNameCtrl.text = existingProfile.companyName;
        emailCtrl.text = existingProfile.contactEmail;
        phoneCtrl.text = existingProfile.contactPhone;
        websiteCtrl.text = existingProfile.websiteUrl ?? '';
        descCtrl.text = existingProfile.description;
        addressCtrl.text = existingProfile.addressDetail;

        existingLogoUrl.value = existingProfile.logoUrl ?? '';

        selectedIndustryId.value = existingProfile.industryId;
        selectedCompanySize.value = existingProfile.companySize;
        selectedProvinceId.value = existingProfile.provinceId;
        selectedDistrictId.value = existingProfile.districtId;

        if (selectedProvinceId.value.isNotEmpty) {
          _fetchDistricts(selectedProvinceId.value);
        }
      }
    }
  }

  void onProvinceChanged(String? provId) {
    if (provId == null) return;
    selectedProvinceId.value = provId;
    selectedDistrictId.value = '';
    _fetchDistricts(provId);
  }

  Future<void> _fetchDistricts(String provId) async {
    final dists = await locationCtrl.getDistricts(provId);
    districtsList.assignAll(dists);
  }

  Future<void> pickAndUploadLogo() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      final isDark = Get.isDarkMode; // 🟢 Theme Check

      if (image != null) {
        logoImage.value = File(image.path);
        isUploadingLogo.value = true;
        final success = await _profileService.uploadCompanyLogo(
          logoImage.value!,
        );

        if (success) {
          Get.snackbar(
            'Success'.tr, // 🟢 Added .tr
            'Company logo updated successfully!'.tr, // 🟢 Added .tr
            backgroundColor: isDark
                ? AppColors.success.withValues(alpha: 0.15)
                : Colors.green,
            colorText: isDark ? Colors.greenAccent : Colors.white,
          );

          if (Get.isRegistered<EmployerProfileViewController>()) {
            Get.find<EmployerProfileViewController>().fetchMyProfile();
          }
        } else {
          Get.snackbar(
            'Failed'.tr, // 🟢 Added .tr
            'Could not upload logo. Please try again.'.tr, // 🟢 Added .tr
            backgroundColor: isDark
                ? AppColors.error.withValues(alpha: 0.15)
                : Colors.red,
            colorText: isDark ? Colors.redAccent : Colors.white,
          );
        }
      }
    } catch (e) {
      final isDark = Get.isDarkMode; // 🟢 Theme Check
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'An error occurred while uploading the image.'.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red,
        colorText: isDark ? Colors.redAccent : Colors.white,
      );
    } finally {
      isUploadingLogo.value = false;
    }
  }

  Future<void> updateProfile() async {
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    if (companyNameCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Field'.tr, // 🟢 Added .tr
        'Company Name is required.'.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange,
        colorText: isDark ? Colors.orangeAccent : Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final requestData = CompanyProfileRequest(
        companyName: companyNameCtrl.text.trim(),
        industryId: selectedIndustryId.value,
        companySize: selectedCompanySize.value,
        description: descCtrl.text.trim(),
        contactEmail: emailCtrl.text.trim(),
        contactPhone: phoneCtrl.text.trim(),
        websiteUrl: websiteCtrl.text.trim(),
        provinceId: selectedProvinceId.value,
        districtId: selectedDistrictId.value,
        addressDetail: addressCtrl.text.trim(),
      );

      final response = await _profileService.updateCompanyProfile(requestData);

      if (response.success) {
        Get.back();
        Get.snackbar(
          'Success'.tr, // 🟢 Added .tr
          'Company profile updated successfully!'.tr, // 🟢 Added .tr
          backgroundColor: isDark
              ? AppColors.success.withValues(alpha: 0.15)
              : Colors.green,
          colorText: isDark ? Colors.greenAccent : Colors.white,
        );

        if (Get.isRegistered<EmployerProfileViewController>()) {
          Get.find<EmployerProfileViewController>().fetchMyProfile();
        }
      } else {
        Get.snackbar(
          'Failed'.tr, // 🟢 Added .tr
          response
              .message
              .tr, // 🟢 Translate remote message if it exists in local dictionary
          backgroundColor: isDark
              ? AppColors.error.withValues(alpha: 0.15)
              : Colors.red,
          colorText: isDark ? Colors.redAccent : Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Update Profile Error: $e');
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'An unexpected error occurred. Please try again.'.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red,
        colorText: isDark ? Colors.redAccent : Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    companyNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    websiteCtrl.dispose();
    descCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
