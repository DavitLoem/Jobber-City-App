part of 'home_seeker_view.dart';

class HomeSeekerViewController extends GetxController {
  final _seekerServices = AuthServices();

  var isLoading = true.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileRaw();
  }

  Future<void> checkTokenExpiry() async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      AppLogger.i("📭 មិនមាន Access Token ទេ");
      return;
    }

    try {
      // វះកាត់ Token ជា ៣ ចំណែក រួចយកចំណែកកណ្តាល (Payload) មកអាន
      final parts = token.split('.');
      if (parts.length != 3) return;

      String normalized = base64Url.normalize(parts[1]);
      String payload = utf8.decode(base64Url.decode(normalized));
      Map<String, dynamic> payloadMap = json.decode(payload);

      if (payloadMap.containsKey('exp')) {
        // បំប្លែងម៉ោងពី Backend (វិនាទី) មកជាម៉ោងពិត (មិល្លីវិនាទី)
        DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(
          payloadMap['exp'] * 1000,
        );
        DateTime now = DateTime.now();

        AppLogger.i(
          "🔑 Token របស់អ្នក: ${token.substring(0, 15)}...",
        ); // ព្រីនត្រឹម 15 តួ
        AppLogger.i("⏰ ម៉ោងបច្ចុប្បន្ន: $now");
        AppLogger.i("🕒 ម៉ោង Expire:   $expiryDate");

        if (now.isAfter(expiryDate)) {
          AppLogger.e("🔴 លទ្ធផល: Token នេះបាន EXPIRED បាត់ទៅហើយ!");
        } else {
          Duration timeLeft = expiryDate.difference(now);
          AppLogger.i(
            "🟢 លទ្ធផល: Token នេះនៅរស់ (សល់ ${timeLeft.inMinutes} នាទី និង ${timeLeft.inSeconds % 60} វិនាទីទៀត)",
          );
        }
        debugPrint("========================================");
      }
    } catch (e) {
      debugPrint("❌ Error ពេល Decode Token: $e");
    }
  }

  void fetchProfileRaw() async {
    checkTokenExpiry();

    try {
      isLoading.value = true;
      AppLogger.i("⏳ កំពុងទាញយកទិន្នន័យ Profile...");

      final response = await _seekerServices.getRawProfile();

      // ទាញយក Object "data" ពី JSON រួចចាប់យកឈ្មោះ
      var data = response['data'];
      firstName.value = data['first_name'] ?? 'NoName';
      lastName.value = data['last_name'] ?? '';

      AppLogger.i("✅ ទាញយកជោគជ័យ: ${firstName.value} ${lastName.value}");
    } catch (e) {
      AppLogger.i("❌ បរាជ័យក្នុងការទាញយក Profile: $e");
      Get.snackbar("Error", "មិនអាចទាញយក Profile បានទេ");
    } finally {
      isLoading.value = false;
    }
  }
}
