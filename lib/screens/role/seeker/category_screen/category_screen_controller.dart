part of 'category_screen_view.dart';

class CategoryScreenViewController extends GetxController {
  final CategoryServices _categoryServices = CategoryServices();

  var categoriesList = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var provinceId = ''.obs;

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
      debugPrint('Error Loading Categories: $e');
      errorMessage.value = e.toString();
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
        'Action Required',
        'Please select at least one field of expertise to continue.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // 🟢 ០. ចាប់យក arguments ដែលបានបញ្ជូនមកដល់ Category Screen នេះ
    //    (ឧ. email, firstName, lastName, province_id ដែលមកពីអេក្រង់មុនៗ)
    final Map<String, dynamic> incomingArgs = {};
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      incomingArgs.addAll(Get.arguments as Map<String, dynamic>);
    }

    // 🟢 ១. ចាប់យក province_id ពី Location (ប្រសិនបើមាន)
    provinceId.value =
        incomingArgs['province_id']?.toString() ??
        Get.arguments?.toString() ??
        '';
    debugPrint("Final Route Check - Province ID: $provinceId");

    // 🟢 ២. អាន Role ពី GetStorage ត្រង់ៗ (សាមញ្ញបំផុត)
    final String userRole =
        GetStorage().read('role')?.toString().toLowerCase() ?? 'seeker';
    debugPrint("Final Route Check - Role: $userRole");

    // 🟢 ៣. រក្សាទុក categories ដែលបានរើសទៅក្នុង GetStorage ផងដែរ ដើម្បីឲ្យ
    //    Edit Profile Screen អាចទាញវាមកបំពេញដោយស្វ័យប្រវត្តិ
    //    ទោះបីជា Get.arguments ត្រូវបាត់បង់ពេលឆ្លងកាត់ច្រើនអេក្រង់ក៏ដោយ
    GetStorage().write('temp_category_ids', selectedCategoryIds.toList());

    // 🟢 ៤. បំបែកផ្លូវ
    if (userRole == 'employer') {
      // បើជា Employer បញ្ជូនទៅ Company Profile ជាមួយទិន្នន័យ ID ដែលបានរើស
      Get.offAllNamed(
        AppRoutes.companyProfile,
        arguments: {
          'industry_id': selectedCategoryIds.first,
          'province_id': provinceId,
        },
      );
    } else {
      // បើជា Seeker ឱ្យទៅ Home - pass arguments through, including the
      // selected category_ids so any screen further down the chain
      // (e.g. Edit Profile) can auto-fill from them.
      incomingArgs['category_ids'] = selectedCategoryIds.toList();
      incomingArgs['province_id'] = provinceId.value;
      Get.offAllNamed(AppRoutes.mainScreen, arguments: incomingArgs);
    }
  }
}
