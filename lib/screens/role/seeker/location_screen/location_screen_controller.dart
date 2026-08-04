part of 'location_screen_view.dart';

class LocationScreenController extends GetxController {
  final LocationServices _locationServices = LocationServices();

  var isProvinceLoading = false.obs;
  var provincesList = <LocationModel>[].obs;
  var selectedProvinceId = ''.obs;
  var provinceError = ''.obs;

  var isDistrictLoading = false.obs;
  var districtsList = <LocationModel>[].obs;
  var selectedDistrictId = ''.obs;
  var districtError = ''.obs;

  var isGettingCurrentLocation = false.obs;
  var currentLocationError = ''.obs;

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
      provinceError.value = '';
      var data = await _locationServices.getProvinces(search: query);

      // sortOrder
      data.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      provincesList.assignAll(data);

      if (data.isEmpty) {
        provinceError.value = 'No provinces found';
      }
    } catch (e) {
      debugPrint('Error fetching provinces: $e');
      provinceError.value =
          'Failed to load provinces. Please check your connection.';
      provincesList.clear();
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
      districtError.value = '';
      var data = await _locationServices.getDistricts(
        provinceId,
        search: query,
      );

      data.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      districtsList.assignAll(data);

      if (data.isEmpty) {
        districtError.value = 'No districts found';
      }
    } catch (e) {
      debugPrint('Error fetching districts: $e');
      districtError.value =
          'Failed to load districts. Please check your connection.';
      districtsList.clear();
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
        AppRoutes.expertise,
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

  // GPS/Current Location functionality
  Future<void> getCurrentLocation() async {
    try {
      isGettingCurrentLocation.value = true;
      currentLocationError.value = '';

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentLocationError.value =
            'Location services are disabled. Please enable them.';
        return;
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentLocationError.value = 'Location permissions are denied.';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        currentLocationError.value =
            'Location permissions are permanently denied.';
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // For now, just show success message
      // In a real implementation, you would reverse geocode the coordinates
      // to get the province/district and auto-select them
      Get.snackbar(
        'Location Found',
        'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
        snackPosition: SnackPosition.BOTTOM,
      );

      debugPrint(
        'Current location: ${position.latitude}, ${position.longitude}',
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      currentLocationError.value =
          'Failed to get current location. Please try again.';
    } finally {
      isGettingCurrentLocation.value = false;
    }
  }
}
