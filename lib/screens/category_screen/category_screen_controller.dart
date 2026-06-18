part of 'category_screen_view.dart';

class CategoryScreenViewController extends GetxController {
  final CategoryServices _categoryServices = CategoryServices();

  var categoriesList = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var selectedCategoryIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      var data = await _categoryServices.getCategories();
      categoriesList.assignAll(data);
    } catch (e) {
      debugPrint('Controller caught error: $e');
      errorMessage.value = e.toString();

      Get.snackbar(
        'Error Loading Categories',
        e.toString(),
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelection(String id) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      if (selectedCategoryIds.length < 5) {
        selectedCategoryIds.add(id);
      } else {
        Get.snackbar('Notice', 'You can only select up to 5 categories only.');
      }
    }
  }

  void continueToNextScreen() {
    if (selectedCategoryIds.isEmpty) {
      Get.snackbar(
        'Selection Required',
        'Please select at least one field of expertise to continue.',
        snackPosition: SnackPosition.TOP,
      );
    } else {
      print('Selected Categories: ${selectedCategoryIds}');
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
