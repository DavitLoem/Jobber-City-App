part of 'location_screen_view.dart';

class LocationScreenController extends GetxController {
  final LocationServices _locationServices = LocationServices();

  var isLoading = false.obs;
  var locationList = <LocationModel>[].obs;
  var filteredList = <LocationModel>[].obs;
  var selectedLocationId = ''.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  void fetchLocations() async {
    try {
      isLoading.value = true;
      var data = await _locationServices.getLocation();
      locationList.assignAll(data);
      filteredList.assignAll(data);
    } catch (e) {
      debugPrint('Error fetching locations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterLocations(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(locationList);
    } else {
      var lowerCaseQuery = query.toLowerCase();
      filteredList.assignAll(
        locationList.where((location) {
          return location.nameEn.toLowerCase().contains(lowerCaseQuery) ||
              (location.nameKm != null &&
                  location.nameKm.toString().contains(query));
        }).toList(),
      );
    }
  }

  void continueToNextScreen() {
    if (selectedLocationId.value.isEmpty) {
      Get.snackbar(
        'Action Required',
        'Please select your city to continue.',
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.toNamed(AppRoutes.category);
    }
  }
}
