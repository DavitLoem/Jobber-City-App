import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_feed_service.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';
import 'package:jobber_city/screens/role/seeker/search_button/widgets/job_filter_bottom_sheet.dart';

class SearchButtonViewController extends GetxController {
  final JobFeedService _jobFeedService = JobFeedService();
  final TextEditingController searchController = TextEditingController();

  // ── ផ្នែកគ្រប់គ្រង State របស់ Search UI ──
  var searchQuery = ''.obs;
  var isSearching = false.obs;
  var isLoadingMore = false.obs;
  var searchResults = <JobFeedModel>[].obs;

  int _currentPage = 1;
  var hasMoreData = true.obs;

  var recentSearches = <String>[
    'UI/UX Designer',
    'Flutter Developer',
  ].obs; // Usually user-generated, translation not always needed
  var popularSearches = <String>[
    'Remote'.tr,
    'Part-time'.tr,
    'Marketing'.tr,
  ].obs; // 🟢 Added .tr

  // ── 🟢 ផ្នែកគ្រប់គ្រង State របស់ Filter ទាំង ៦ ──
  var selectedCategoryId = RxnString();
  var selectedIndustryId = RxnString();
  var minSalary = RxnDouble();
  var maxSalary = RxnDouble();
  var selectedJobLevelId = RxnString();
  var selectedEmploymentTypeId = RxnString();
  var selectedProvinceId = RxnString();

  var activeFiltersCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // 🎯 ១. ចុះឈ្មោះ Controllers ទាក់ទងនឹង Master Data ដើម្បីឱ្យវាចាប់ផ្តើមហៅ API ទាញទិន្នន័យទុក
    Get.put(CategoryController());
    Get.put(LocationController());
    final mdCtrl = Get.put(MasterDataController());

    // 🎯 ២. ទាញយកទិន្នន័យ Master Data ជាក់លាក់មកទុកក្នុង Cache មុននឹងគាត់ចុចបើក Filter
    mdCtrl.getMasterData(endpoint: 'industries');
    mdCtrl.getMasterData(endpoint: 'job-levels');
    mdCtrl.getMasterData(endpoint: 'employment-types');

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    debounce(searchQuery, (String query) {
      if (query.trim().isNotEmpty || activeFiltersCount.value > 0) {
        performSearch(isRefresh: true);
      } else {
        searchResults.clear();
        isSearching.value = false;
      }
    }, time: const Duration(milliseconds: 800));
  }

  /// 🎯 មុខងារសម្រាប់រាប់ចំនួន Filter ដែលកំពុងប្រើ ដើម្បីបង្ហាញចំណុចក្រហម (Badge) លើ UI
  void _calculateActiveFiltersCount() {
    int count = 0;
    if (selectedCategoryId.value != null) count++;
    if (selectedIndustryId.value != null) count++;
    if (minSalary.value != null || maxSalary.value != null) count++;
    if (selectedJobLevelId.value != null) count++;
    if (selectedEmploymentTypeId.value != null) count++;
    if (selectedProvinceId.value != null) count++;
    activeFiltersCount.value = count;
  }

  /// 🎯 មុខងារ Search ចម្បង (បាញ់ Parameters ទាំងអស់ទៅកាន់ API)
  Future<void> performSearch({bool isRefresh = false}) async {
    // មិនអាច Search បានទេ បើគ្មានទាំងអក្សរ និងគ្មានទាំង Filter
    if (searchQuery.value.trim().isEmpty && activeFiltersCount.value == 0) {
      return;
    }

    if (isRefresh) {
      _currentPage = 1;
      hasMoreData.value = true;
      isSearching.value = true;
      searchResults.clear();

      // កត់ត្រាប្រវត្តិស្វែងរក តែនៅពេលមានវាយអក្សរប៉ុណ្ណោះ
      if (searchQuery.value.trim().isNotEmpty) {
        saveRecentSearch(searchQuery.value);
      }
    } else {
      if (isLoadingMore.value || !hasMoreData.value) return;
      isLoadingMore.value = true;
    }

    try {
      var data = await _jobFeedService.searchJobs(
        keyword: searchQuery.value.trim().isEmpty
            ? null
            : searchQuery.value.trim(),
        page: _currentPage,
        limit: 10,
        categoryId: selectedCategoryId.value,
        industryId: selectedIndustryId.value,
        minSalary: minSalary.value,
        maxSalary: maxSalary.value,
        jobLevelId: selectedJobLevelId.value,
        employmentTypeId: selectedEmploymentTypeId.value,
        provinceId: selectedProvinceId.value,
      );

      searchResults.addAll(data);

      if (data.length < 10) {
        hasMoreData.value = false;
      } else {
        _currentPage++;
      }
    } catch (e) {
      debugPrint('Error searching jobs: $e');
    } finally {
      isSearching.value = false;
      isLoadingMore.value = false;
    }
  }

  /// 🎯 មុខងារសម្រាប់ BottomSheet ហៅនៅពេលចុច "Apply Filter"
  void applyFilters({
    String? categoryId,
    String? industryId,
    double? minSal,
    double? maxSal,
    String? jobLevelId,
    String? empTypeId,
    String? provId,
  }) {
    selectedCategoryId.value = categoryId;
    selectedIndustryId.value = industryId;
    minSalary.value = minSal;
    maxSalary.value = maxSal;
    selectedJobLevelId.value = jobLevelId;
    selectedEmploymentTypeId.value = empTypeId;
    selectedProvinceId.value = provId;

    _calculateActiveFiltersCount();
    performSearch(isRefresh: true); // ហៅ API ទាញយកទិន្នន័យថ្មីភ្លាមៗ
  }

  /// 🎯 មុខងារសម្រាប់ BottomSheet ហៅនៅពេលចុច "Reset"
  void resetFilters() {
    selectedCategoryId.value = null;
    selectedIndustryId.value = null;
    minSalary.value = null;
    maxSalary.value = null;
    selectedJobLevelId.value = null;
    selectedEmploymentTypeId.value = null;
    selectedProvinceId.value = null;

    _calculateActiveFiltersCount();

    // ប្រសិនបើពេល Clear Filter ទៅ អត់មាន Keyword ទៀត ត្រូវលុបបញ្ជីចោល
    if (searchQuery.value.trim().isEmpty) {
      searchResults.clear();
      isSearching.value = false;
    } else {
      performSearch(isRefresh: true);
    }
  }

  /// 🎯 មុខងារសម្រាប់លុប Filter ណាមួយចោល ពេលគាត់ចុចសញ្ញា (X) លើ Chip
  void removeFilter(String filterType) {
    switch (filterType) {
      case 'category':
        selectedCategoryId.value = null;
        break;
      case 'industry':
        selectedIndustryId.value = null;
        break;
      case 'salary':
        minSalary.value = null;
        maxSalary.value = null;
        break;
      case 'jobLevel':
        selectedJobLevelId.value = null;
        break;
      case 'employmentType':
        selectedEmploymentTypeId.value = null;
        break;
      case 'province':
        selectedProvinceId.value = null;
        break;
    }

    _calculateActiveFiltersCount();

    // បើលុប Filter អស់ ហើយអត់មាន Keyword ទៀត គឺត្រូវលុបបញ្ជីចោល
    if (searchQuery.value.trim().isEmpty && activeFiltersCount.value == 0) {
      searchResults.clear();
      isSearching.value = false;
    } else {
      performSearch(isRefresh: true);
    }
  }

  void saveRecentSearch(String keyword) {
    if (keyword.trim().isEmpty) return;
    if (!recentSearches.contains(keyword)) {
      recentSearches.insert(0, keyword);
      if (recentSearches.length > 5) recentSearches.removeLast();
    }
  }

  void selectSearchQuery(String query) {
    searchController.text = query;
    performSearch(isRefresh: true);
  }

  void clearSearch() {
    searchController.clear();
    // បើមាន Filter ជាប់ មិនត្រូវលុបលទ្ធផលចោលទេ ត្រូវ Search ម្ដងទៀតដោយគ្មាន Keyword
    if (activeFiltersCount.value > 0) {
      performSearch(isRefresh: true);
    } else {
      searchResults.clear();
      isSearching.value = false;
    }
  }

  void clearAllRecentSearches() {
    recentSearches.clear();
  }

  void openFilterModal() {
    Get.bottomSheet(
      const JobFilterBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
