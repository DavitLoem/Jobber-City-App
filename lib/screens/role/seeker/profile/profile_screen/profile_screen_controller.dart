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

  Future<void> checkTokenExpiry() async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      AppLogger.i("No Access Token");
      return;
    }

    try {
      // Split Token into 3 parts and take the middle part (Payload) to read
      final parts = token.split('.');
      if (parts.length != 3) return;

      String normalized = base64Url.normalize(parts[1]);
      String payload = utf8.decode(base64Url.decode(normalized));
      Map<String, dynamic> payloadMap = json.decode(payload);

      if (payloadMap.containsKey('exp')) {
        // Convert time from Backend (seconds) to real time (milliseconds)
        DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(
          payloadMap['exp'] * 1000,
        );
        DateTime now = DateTime.now();

        AppLogger.i(
          "Your Token: ${token.substring(0, 15)}...",
        ); // Print only first 15 characters
        AppLogger.i("Current time: $now");
        AppLogger.i("Expire time: $expiryDate");

        if (now.isAfter(expiryDate)) {
          AppLogger.e("Result: This Token has EXPIRED!");
        } else {
          Duration timeLeft = expiryDate.difference(now);
          AppLogger.i(
            "Result: This Token is still alive (${timeLeft.inMinutes} minutes and ${timeLeft.inSeconds % 60} seconds remaining)",
          );
        }
        debugPrint("========================================");
      }
    } catch (e) {
      debugPrint("Error decoding Token: $e");
    }
  }

  void fetchProfileRaw() async {
    checkTokenExpiry();

    try {
      isLoading.value = true;
      AppLogger.i("Fetching Profile data...");

      final response = await _seekerServices.getRawProfile();

      // Get "data" Object from JSON and extract the name
      var data = response['data'];
      firstName.value = data['first_name'] ?? 'NoName';
      lastName.value = data['last_name'] ?? '';
      email.value = data['email'] ?? '';
      position.value = data['position'] ?? data['job_title'] ?? '';
      profileImageUrl.value = data['profile_image_url'] ?? '';

      AppLogger.i(
        "Successfully fetched: ${firstName.value} ${lastName.value} ${email.value}",
      );
    } catch (e) {
      AppLogger.i("Failed to fetch Profile: $e");
      Get.snackbar("Error", "Cannot fetch Profile");
    } finally {
      isLoading.value = false;
    }
  }
}
