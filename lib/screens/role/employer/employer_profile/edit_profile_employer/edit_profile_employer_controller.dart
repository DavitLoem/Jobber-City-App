part of 'edit_profile_employer_view.dart';

class EditProfileEmployerViewController extends GetxController {
  // ── 1. Services ──
  final CompanyProfileService _profileService = CompanyProfileService();

  final masterCtrl = Get.find<MasterDataController>();
  final locationCtrl = Get.find<LocationController>();

  // ── 2. Text Controllers សម្រាប់ Input Fields ──
  final companyNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  // ── 3. Variables សម្រាប់ Dropdowns / Selections ──
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
    // ឆែកបើគ្មាន Industry ត្រូវទាញយកមកសិន
    if (masterCtrl.masterDataCache['industries'] == null) {
      await masterCtrl.getMasterData(endpoint: 'industries');
    }
    // ឆែកបើគ្មានខេត្ត ត្រូវទាញយកមកសិន
    if (locationCtrl.provinces.isEmpty) {
      await locationCtrl.fetchProvinces();
    }

    _prefillData();
  }

  // មុខងារទាញទិន្នន័យចាស់ពី EmployerProfileViewController មកញាត់ចូលក្នុង Form
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
    selectedDistrictId.value = ''; // លុបតម្លៃស្រុកចោលសិនពេលប្តូរខេត្តថ្មី
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

      if (image != null) {
        logoImage.value = File(image.path);
        isUploadingLogo.value = true;
        final success = await _profileService.uploadCompanyLogo(
          logoImage.value!,
        );

        if (success) {
          Get.snackbar(
            'Success',
            'Company logo updated successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // ប្រាប់ EmployerProfileViewController ឱ្យទាញយក Data ថ្មីដើម្បីអាប់ដេត UI ខាងក្រៅ
          if (Get.isRegistered<EmployerProfileViewController>()) {
            Get.find<EmployerProfileViewController>().fetchMyProfile();
          }
        } else {
          Get.snackbar(
            'Failed',
            'Could not upload logo. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Error',
        'An error occurred while uploading the image.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingLogo.value = false;
    }
  }

  // មុខងារសម្រាប់ Update ទិន្នន័យទៅកាន់ API
  Future<void> updateProfile() async {
    // ត្រួតពិនិត្យភាពត្រឹមត្រូវបឋម (Validation)
    if (companyNameCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Field',
        'Company Name is required.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      // រៀបចំទិន្នន័យសម្រាប់បញ្ជូនទៅ (ផ្អែកលើ Request Body របស់ API)
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
        Get.back(); // បិទអេក្រង់ Edit រួចត្រឡប់ទៅ Profile វិញ
        Get.snackbar(
          'Success',
          'Company profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ប្រាប់ឱ្យ EmployerProfileViewController ទាញយកទិន្នន័យថ្មីម្តងទៀត ដើម្បី Update UI
        if (Get.isRegistered<EmployerProfileViewController>()) {
          Get.find<EmployerProfileViewController>().fetchMyProfile();
        }
      } else {
        Get.snackbar(
          'Failed',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Update Profile Error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
