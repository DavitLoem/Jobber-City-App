part of 'category_screen_view.dart';

class CategoryScreenViewController extends GetxController {
  final CategoryServices _categoryServices = CategoryServices();
  final OnboardingServices _onboardingServices = OnboardingServices();

  var categoriesList = <CategoryModel>[].obs;
  var isLoading = false.obs;

  var provinceId = ''.obs;
  var districtId = ''.obs;

  var selectedCategoryIds = <String>[].obs;

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    _extractArguments();
    fetchCategories();
  }

  void _extractArguments() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      provinceId.value = args['province_id']?.toString() ?? '';
      districtId.value = args['district_id']?.toString() ?? '';
    }
  }

  void fetchCategories({String? query}) async {
    try {
      isLoading.value = true;
      var data = await _categoryServices.getCategories(search: query);
      categoriesList.assignAll(data);
    } catch (e) {
      debugPrint('Error Loading Categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterCategories(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchCategories(query: query);
    });
  }

  void toggleSelection(String id) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      if (selectedCategoryIds.length < 5) {
        selectedCategoryIds.add(id);
      } else {
        final isDark = Get.isDarkMode; // 🟢 Get the current theme mode
        Get.snackbar(
          'Notice'.tr, // 🟢 Added .tr
          'You can only select up to 5 categories.'.tr, // 🟢 Added .tr
          backgroundColor: isDark
              ? Colors.orangeAccent.withValues(alpha: 0.15)
              : AppColors.warningBackground, // 🟢 Dynamic BG
          colorText: isDark
              ? Colors.orangeAccent
              : AppColors.warning, // 🟢 Dynamic Text
        );
      }
    }
  }

  Future<void> continueToNextScreen() async {
    final isDark = Get.isDarkMode;

    if (selectedCategoryIds.isEmpty) {
      Get.snackbar(
        'Action Required'.tr, // 🟢 Added .tr
        'Please select at least one expertise.'.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : AppColors.warningBackground,
        colorText: isDark ? Colors.orangeAccent : AppColors.warning,
      );
      return;
    }

    try {
      isSubmitting.value = true;
      await _onboardingServices.completeOnboarding(
        provinceId: provinceId.value,
        districtId: districtId.value,
        categoryIds: selectedCategoryIds.toList(),
      );

      // 🎯 អាប់ដេត Token Storage ថាគាត់បានបំពេញ Onboarding រួចរាល់
      await TokenStorage.saveTokens(
        accessToken: (await TokenStorage.getAccessToken()) ?? '',
        refreshToken: (await TokenStorage.getRefreshToken()) ?? '',
        role: 'seeker',
        onboardingCompleted: true,
        isProfileCompleted: false,
      );

      // ប្រាប់ AuthController ឱ្យអាន State ថ្មី
      await Get.find<AuthController>().checkLoginStatus();

      Get.offAllNamed(AppRoutes.mainScreenSeeker);
    } catch (e) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Failed to complete setup. Please try again.'.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      debugPrint("Onboarding Submit Error: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
