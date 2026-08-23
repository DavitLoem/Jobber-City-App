part of 'employer_profile_view.dart';

class EmployerProfileViewController extends GetxController {
  final CompanyProfileService _profileService = CompanyProfileService();

  // 🎯 ចាក់បញ្ចូល Controller ទាំង ២
  final masterDataCtrl = Get.find<MasterDataController>();
  final locationCtrl = Get.find<LocationController>();

  ThemeController get themeController => Get.find<ThemeController>();

  final isLoading = true.obs;
  final isFetching = false.obs; // សម្រាប់ Initial Data
  final companyProfile = Rxn<CompanyProfileModel>();
  final errorMessage = ''.obs;

  final industriesList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadAllData();
  }

  // 🎯 ហៅមុខងារទាំង ២ បន្តបន្ទាប់គ្នា
  Future<void> _loadAllData() async {
    isLoading.value = true;
    await fetchInitialData();
    await fetchMyProfile();
    isLoading.value = false; // បិទ Loading ពេលទាញចប់ទាំង ២
  }

  // 🎯 កូដរបស់អ្នកដែលបានសរសេរ
  Future<void> fetchInitialData() async {
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

  Future<void> fetchMyProfile() async {
    try {
      errorMessage.value = '';
      final response = await _profileService.getMyCompanyProfile();
      if (response.success && response.data != null) {
        companyProfile.value = response.data;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value =
          'Failed to load profile. Please try again.'.tr; // 🟢 Added .tr
      debugPrint('Error fetching profile: $e');
    }
  }

  // ==========================================
  // ── មុខងារទាញយកឈ្មោះពី ID (ដាក់ក្នុង Controller) ──
  // ==========================================
  String getIndustryName(String? id) {
    if (id == null || id.isEmpty) return 'Unknown Industry'.tr; // 🟢 Added .tr
    try {
      return industriesList.firstWhere((i) => i.id == id).name;
    } catch (_) {
      return 'Unknown Industry'.tr; // 🟢 Added .tr
    }
  }

  String getProvinceName(String? id) {
    if (id == null || id.isEmpty) return 'Unknown Location'.tr; // 🟢 Added .tr
    try {
      return locationCtrl.provinces.firstWhere((p) => p.id == id).nameEn;
    } catch (_) {
      return 'Unknown Location'.tr; // 🟢 Added .tr
    }
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
