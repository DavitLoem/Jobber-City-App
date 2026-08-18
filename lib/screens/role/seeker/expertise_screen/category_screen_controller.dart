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
        Get.snackbar(
          'Notice'.tr, // 🟢 Added .tr
          'You can only select up to 5 categories.'.tr, // 🟢 Added .tr
          backgroundColor: AppColors.warning,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> continueToNextScreen() async {
    if (selectedCategoryIds.isEmpty) {
      Get.snackbar(
        'Action Required'.tr, // 🟢 Added .tr
        'Please select at least one expertise.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
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

      await TokenStorage.saveTokens(
        accessToken: (await TokenStorage.getAccessToken()) ?? '',
        refreshToken: (await TokenStorage.getRefreshToken()) ?? '',
        role: 'seeker',
        onboardingCompleted: true,
        isProfileCompleted: false,
      );

      await Get.find<AuthController>().checkLoginStatus();

      Get.offAllNamed(AppRoutes.mainScreenSeeker);
    } catch (e) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Failed to complete setup. Please try again.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.error,
        colorText: Colors.white,
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
