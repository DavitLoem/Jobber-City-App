part of 'location_screen_view.dart';

class LocationScreenController extends GetxController {
  final LocationServices _locationServices = LocationServices();

  var isProvinceLoading = false.obs;
  var provincesList = <LocationModel>[].obs;
  var selectedProvinceId = ''.obs;

  var isDistrictLoading = false.obs;
  var districtsList = <LocationModel>[].obs;
  var selectedDistrictId = ''.obs;

  final TextEditingController searchController = TextEditingController();
  final PageController pageController = PageController();
  final currentPage = 0.obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchProvinces();
  }

  // ១. មុខងារទាញយកខេត្ត
  void fetchProvinces({String? query}) async {
    try {
      isProvinceLoading.value = true;
      var data = await _locationServices.getProvinces(search: query);

      // sortOrder
      data.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      provincesList.assignAll(data);
    } catch (e) {
      debugPrint('Error fetching provinces: $e');
    } finally {
      isProvinceLoading.value = false;
    }
  }

  void onProvinceSelected(String provinceId) {
    if (selectedProvinceId.value != provinceId) {
      selectedProvinceId.value = provinceId;
      selectedDistrictId.value = '';
      districtsList.clear();
      searchController.clear();
      fetchDistricts(provinceId);
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void fetchDistricts(String provinceId, {String? query}) async {
    try {
      isDistrictLoading.value = true;
      var data = await _locationServices.getDistricts(
        provinceId,
        search: query,
      );

      data.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      districtsList.assignAll(data);
    } catch (e) {
      debugPrint('Error fetching districts: $e');
    } finally {
      isDistrictLoading.value = false;
    }
  }

  void onDistrictSelected(String districtId) {
    selectedDistrictId.value = districtId;
  }

  void filterLocations(String query) {
    // បើគាត់កំពុងវាយអក្សរជាប់ៗគ្នា យើងលុប Timer ចាស់ចោល
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // បង្កើត Timer ថ្មី រង់ចាំ ៥០០ មិល្លីវិនាទី បន្ទាប់ពីគាត់ឈប់វាយអក្សរ ទើបបាញ់ API
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (selectedProvinceId.value.isEmpty) {
        fetchProvinces(query: query);
      } else {
        fetchDistricts(selectedProvinceId.value, query: query);
      }
    });
  }

  void continueToNextScreen() {
    if (currentPage.value == 0) {
      if (selectedProvinceId.value.isNotEmpty) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      if (selectedDistrictId.value.isEmpty) {
        Get.snackbar('Action Required', 'Please select a district.');
        return;
      }

      Get.toNamed(
        AppRoutes.category,
        arguments: {
          'province_id': selectedProvinceId.value,
          'district_id': selectedDistrictId.value,
        },
      );
    }
  }

  void goBack() {
    if (currentPage.value == 1) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
