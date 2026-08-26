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
        provinceError.value = 'No provinces found'.tr; // 🟢 Added .tr
      }
    } catch (e) {
      debugPrint('Error fetching provinces: $e');
      provinceError.value =
          'Failed to load provinces. Please check your connection.'
              .tr; // 🟢 Added .tr
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
        districtError.value = 'No districts found'.tr; // 🟢 Added .tr
      }
    } catch (e) {
      debugPrint('Error fetching districts: $e');
      districtError.value =
          'Failed to load districts. Please check your connection.'
              .tr; // 🟢 Added .tr
      districtsList.clear();
    } finally {
      isDistrictLoading.value = false;
    }
  }

  void onDistrictSelected(String districtId) {
    selectedDistrictId.value = districtId;
  }

  void filterLocations(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

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
        final isDark = Get.isDarkMode; // 🟢 Dark Mode Check
        Get.snackbar(
          'Action Required'.tr, // 🟢 Added .tr
          'Please select a district.'.tr, // 🟢 Added .tr
          backgroundColor: isDark
              ? Colors.orangeAccent.withValues(alpha: 0.15)
              : AppColors.warningBackground,
          colorText: isDark ? Colors.orangeAccent : AppColors.warning,
        );
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

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentLocationError.value =
            'Location services are disabled. Please enable them.'
                .tr; // 🟢 Added .tr
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentLocationError.value =
              'Location permissions are denied.'.tr; // 🟢 Added .tr
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        currentLocationError.value =
            'Location permissions are permanently denied.'.tr; // 🟢 Added .tr
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final isDark = Get.isDarkMode; // 🟢 Dark Mode Check
      Get.snackbar(
        'Location Found'.tr, // 🟢 Added .tr
        'Lat: @lat, Lng: @lng'.trParams({
          // 🟢 Added .trParams
          'lat': position.latitude.toStringAsFixed(4),
          'lng': position.longitude.toStringAsFixed(4),
        }),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.successBackground,
        colorText: isDark ? Colors.greenAccent : AppColors.success,
      );

      debugPrint(
        'Current location: ${position.latitude}, ${position.longitude}',
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      currentLocationError.value =
          'Failed to get current location. Please try again.'
              .tr; // 🟢 Added .tr
    } finally {
      isGettingCurrentLocation.value = false;
    }
  }
}
