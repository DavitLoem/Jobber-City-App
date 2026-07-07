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
        Get.snackbar('Notice', 'You can only select up to 5 categories.');
      }
    }
  }

  Future<void> continueToNextScreen() async {
    if (selectedCategoryIds.isEmpty) {
      Get.snackbar('Action Required', 'Please select at least one expertise.');
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
        onboardingCompleted: true, // កំណត់ទៅជា true
      );

      // ប្រាប់ AuthController ឱ្យអាន State ថ្មី
      await Get.find<AuthController>().checkLoginStatus();

      Get.offAllNamed(AppRoutes.mainScreenSeeker);
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete setup. Please try again.');
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
