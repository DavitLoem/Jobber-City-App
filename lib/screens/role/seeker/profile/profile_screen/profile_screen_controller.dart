part of 'profile_screen_view.dart';

class ProfileScreenViewController extends GetxController {
  final _seekerServices = AuthServices();

  var isLoading = true.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var position = ''.obs; // Job Title / Position
  var profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileRaw();
  }

  void fetchProfileRaw() async {
    try {
      isLoading.value = true;
      AppLogger.i("Fetching Profile data...");

      final response = await _seekerServices.getRawProfile();

      // Get "data" Object from JSON and extract the name
      final data = response?['data'];
      if (data == null) return;

      firstName.value = data['first_name'] ?? 'NoName';
      lastName.value = data['last_name'] ?? '';
      email.value = data['email'] ?? '';
      position.value = data['position'] ?? data['job_title'] ?? '';
      profileImageUrl.value = data['profile_image_url'] ?? '';

      AppLogger.i(
        "Successfully fetched: ${firstName.value} ${lastName.value} ${email.value}",
      );
    } catch (e) {
      AppLogger.e("Failed to fetch Profile: $e");
      Get.snackbar("Error", "Cannot fetch Profile");
    } finally {
      isLoading.value = false;
    }
  }
}
