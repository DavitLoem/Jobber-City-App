part of 'setting_screen_view.dart';

class SettingScreenViewController extends GetxController {
  final _seekerServices = AuthServices();

  var isLoading = true.obs;
  var completionPercentage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileCompletion();
  }

  void fetchProfileCompletion() async {
    try {
      isLoading.value = true;
      final response = await _seekerServices.getRawProfile();

      if (response != null && response['data'] != null) {
        var data = response['data'];

        // 🟢 ប្រសិនបើ API មានបោះភាគរយមកស្រាប់ ប្រើប្រាស់វា
        if (data['profile_completion'] != null) {
          completionPercentage.value =
              int.tryParse(data['profile_completion'].toString()) ?? 0;
        } else {
          // 🟢 បើគ្មានទេ យើងធ្វើការគណនាដោយស្វ័យប្រវត្តិ
          int filledFields = 0;
          int totalFields = 8; // ចំនួនវាលសំខាន់ៗដែលចង់រាប់

          if ((data['first_name'] ?? '').toString().isNotEmpty) filledFields++;
          if ((data['last_name'] ?? '').toString().isNotEmpty) filledFields++;
          if ((data['email'] ?? '').toString().isNotEmpty) filledFields++;
          if ((data['phone_number'] ?? '').toString().isNotEmpty)
            filledFields++;
          if ((data['current_position'] ?? data['position'] ?? '')
              .toString()
              .isNotEmpty)
            filledFields++;
          if ((data['province_id']?.toString() ?? '').isNotEmpty)
            filledFields++;
          if ((data['date_of_birth'] ?? '').toString().isNotEmpty)
            filledFields++;
          if ((data['profile_image_url'] ?? '').toString().isNotEmpty)
            filledFields++;

          completionPercentage.value = ((filledFields / totalFields) * 100)
              .toInt();
        }
      }
    } catch (e) {
      AppLogger.e("Error fetching profile completion: $e");
      completionPercentage.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    // 🟢 ហៅមុខងារ Logout ពី AuthController
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().logout();
    } else {
      Get.snackbar("Error", "Cannot perform logout at this moment.");
    }
  }
}
