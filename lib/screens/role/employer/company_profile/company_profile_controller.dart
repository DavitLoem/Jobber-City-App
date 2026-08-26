part of 'company_profile_view.dart';

class CompanyProfileViewController extends GetxController {
  late final CompanyProfileService _companyProfileService;
  final LocationController locationCtrl = Get.find<LocationController>();
  final MasterDataController masterDataCtrl = Get.find<MasterDataController>();

  ThemeController get themeController => Get.find<ThemeController>();

  final isLoading = false.obs;
  final isFetching = true.obs;

  final industriesError = Rxn<String>();
  final locationsError = Rxn<String>();

  // Controllers
  final companyNameController = TextEditingController();
  final contactEmailController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final websiteUrlController = TextEditingController();
  final addressDetailController = TextEditingController();
  final industryCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final provinceCtrl = TextEditingController();
  final districtCtrl = TextEditingController();
  final companySizeCtrl = TextEditingController();

  // Image & IDs
  final companyLogoPath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  final selectedIndustryId = ''.obs;
  final selectedCompanySize = ''.obs;
  final selectedProvinceId = ''.obs;
  final selectedDistrictId = ''.obs;

  final industriesList = <MasterDataModel>[].obs;
  final districtsList = <LocationModel>[].obs;
  final companySizes = ["1-10", "11-50", "51-200", "201-500", "500+"].obs;

  @override
  void onInit() {
    super.onInit();
    _companyProfileService = CompanyProfileService();
    fetchInitialData();
  }

  void fetchInitialData() async {
    isFetching.value = true;
    try {
      final inds = await masterDataCtrl.getMasterData(endpoint: 'industries');
      industriesList.assignAll(inds);

      if (locationCtrl.provinces.isEmpty) {
        await locationCtrl.fetchProvinces();
      }
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> fetchDistricts(String provinceId) async {
    try {
      districtsList.clear();
      final dists = await locationCtrl.getDistricts(provinceId);
      districtsList.assignAll(dists);
    } catch (e) {
      debugPrint("Error fetching districts: $e");
    }
  }

  Future<void> pickCompanyLogo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      companyLogoPath.value = pickedFile.path;
    }
  }

  Future<void> saveProfile() async {
    // ── Validations ──
    if (companyNameController.text.trim().isEmpty) {
      _notice('Company Name is required'.tr); // 🟢 Added .tr
      return;
    }
    if (selectedIndustryId.value.isEmpty) {
      _notice('Please select an Industry!'.tr); // 🟢 Added .tr
      return;
    }
    if (descriptionCtrl.text.trim().length < 10) {
      _notice(
        'Company Description must have at least 10 characters!'.tr,
      ); // 🟢 Added .tr
      return;
    }

    isLoading.value = true;
    final isDark = Get.isDarkMode; // 🟢 Theme Check for SnackBar

    try {
      final requestData = CompanyProfileRequest(
        companyName: companyNameController.text.trim(),
        industryId: selectedIndustryId.value,
        companySize: selectedCompanySize.value.isEmpty
            ? "1-10"
            : selectedCompanySize.value,
        description: descriptionCtrl.text.trim(),
        contactEmail: contactEmailController.text.trim(),
        contactPhone: contactPhoneController.text.trim(),
        websiteUrl: websiteUrlController.text.trim(),
        provinceId: selectedProvinceId.value.isEmpty
            ? "1"
            : selectedProvinceId.value,
        districtId: selectedDistrictId.value.isEmpty
            ? "1"
            : selectedDistrictId.value,
        addressDetail: addressDetailController.text.trim(),
      );

      await _companyProfileService.createCompanyProfile(requestData);

      if (companyLogoPath.value.isNotEmpty &&
          !companyLogoPath.value.startsWith('http')) {
        File imageFile = File(companyLogoPath.value);
        await _companyProfileService.uploadCompanyLogo(imageFile);
      }

      String? token = await TokenStorage.getAccessToken();
      String? refresh = await TokenStorage.getRefreshToken();
      String? role = await TokenStorage.getUserRole();
      bool onb = await TokenStorage.getOnboardingStatus();

      await TokenStorage.saveTokens(
        accessToken: token ?? '',
        refreshToken: refresh ?? '',
        role: role ?? 'employer',
        onboardingCompleted: onb,
        isProfileCompleted: true,
      );

      final authCtrl = Get.find<AuthController>();
      authCtrl.isProfileCompleted.value = true;
      authCtrl.checkLoginStatus();

      Get.snackbar(
        'Success'.tr, // 🟢 Added .tr
        'Profile updated successfully!'.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.green,
        colorText: isDark ? Colors.greenAccent : Colors.white,
      );

      await Future.delayed(const Duration(milliseconds: 1000));

      Get.offAllNamed(AppRoutes.mainScreenEmployer);
    } catch (e) {
      Get.snackbar(
        'Failed'.tr, // 🟢 Added .tr
        _extractErrorMessage(e).tr,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.redAccent,
        colorText: isDark ? Colors.redAccent : Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _notice(String message) {
    final isDark = Get.isDarkMode; // 🟢 Theme Check
    Get.snackbar(
      'Notice'.tr, // 🟢 Added .tr
      message,
      backgroundColor: isDark
          ? Colors.orangeAccent.withValues(alpha: 0.15)
          : Colors.orangeAccent,
      colorText: isDark ? Colors.orangeAccent : Colors.white,
    );
  }

  String _extractErrorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['errors'] is List && data['errors'].isNotEmpty) {
        final first = data['errors'][0];
        if (first is Map) {
          final field = first['field'];
          final message = first['message'];
          if (field != null && message != null) return '$field: $message';
          if (message != null) return message.toString();
        }
      }
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    }
    return e.toString();
  }

  @override
  void onClose() {
    companyNameController.dispose();
    contactEmailController.dispose();
    contactPhoneController.dispose();
    websiteUrlController.dispose();
    addressDetailController.dispose();
    industryCtrl.dispose();
    descriptionCtrl.dispose();
    provinceCtrl.dispose();
    districtCtrl.dispose();
    companySizeCtrl.dispose();
    super.onClose();
  }

  void changeTheme(ThemeMode mode) {
    themeController.changeTheme(mode);
  }

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    Get.updateLocale(Locale(languageCode, countryCode));
    const storage = FlutterSecureStorage();
    await storage.write(key: 'app_lang', value: languageCode);
    await storage.write(key: 'app_country', value: countryCode);
  }
}
