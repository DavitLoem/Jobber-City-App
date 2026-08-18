part of 'profile_screen_view.dart';

class ProfileScreenViewController extends GetxController {
  final _seekerServices = AuthServices();
  final _profileServices = SeekerProfileServices();

  var isLoading = true.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var position = ''.obs;
  var profileImageUrl = ''.obs;

  final profileData = Rxn<SeekerProfileModel>();
  final isProfileLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompleteProfile();
    fetchProfileRaw();
  }

  Future<void> fetchCompleteProfile() async {
    try {
      isProfileLoading.value = true;
      final response = await _profileServices.getSeekerProfile();

      if (response.success && response.data != null) {
        profileData.value = response.data; // Update UI ទាំងអស់ដែលស្តាប់អថេរនេះ
      }
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to fetch profile:'.tr + ' $e',
      ); // 🟢 Added .tr
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> checkTokenExpiry() async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      AppLogger.i("No Access Token");
      return;
    }

    try {
      final parts = token.split('.');
      if (parts.length != 3) return;

      String normalized = base64Url.normalize(parts[1]);
      String payload = utf8.decode(base64Url.decode(normalized));
      Map<String, dynamic> payloadMap = json.decode(payload);

      if (payloadMap.containsKey('exp')) {
        DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(
          payloadMap['exp'] * 1000,
        );
        DateTime now = DateTime.now();

        if (now.isAfter(expiryDate)) {
          AppLogger.e("Result: This Token has EXPIRED!");
        } else {
          Duration timeLeft = expiryDate.difference(now);
          AppLogger.i(
            "Result: This Token is still alive (${timeLeft.inMinutes} minutes and ${timeLeft.inSeconds % 60} seconds remaining)",
          );
        }
      }
    } catch (e) {
      debugPrint("Error decoding Token: $e");
    }
  }

  Future<void> goToEditProfile() async {
    final result = await Get.toNamed('/edit-profile');
    if (result is String && result.trim().isNotEmpty) {
      position.value = result.trim();
    }
    fetchProfileRaw();
  }

  void fetchProfileRaw() async {
    checkTokenExpiry();

    try {
      isLoading.value = true;
      AppLogger.i("Fetching Profile data...");

      final response = await _seekerServices.getRawProfile();

      var data = response['data'];
      firstName.value = data['first_name'] ?? 'NoName';
      lastName.value = data['last_name'] ?? '';
      email.value = data['email'] ?? '';

      // 🟢 ជួសជុលត្រង់នេះ៖ បន្ថែមការអាន key 'current_position' ឲ្យស៊ីគ្នានឹង API
      position.value =
          data['current_position'] ??
          data['position'] ??
          data['job_title'] ??
          '';

      profileImageUrl.value = data['profile_image_url'] ?? '';

      AppLogger.i(
        "Successfully fetched: ${firstName.value} ${lastName.value} ${email.value}",
      );
    } catch (e) {
      AppLogger.i("Failed to fetch Profile: $e");
      Get.snackbar("Error".tr, "Cannot fetch Profile".tr); // 🟢 Added .tr
    } finally {
      isLoading.value = false;
    }
  }
}
