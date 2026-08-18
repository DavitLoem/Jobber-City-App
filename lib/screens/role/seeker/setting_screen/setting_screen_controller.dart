part of 'setting_screen_view.dart';

class SettingScreenViewController extends GetxController {
  final authController = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();
  final authServices = AuthServices();

  final isLoading = false.obs;
  final completionPercentage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileCompletion();
  }

  Future<void> fetchProfileCompletion() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      completionPercentage.value = 75;
    } catch (e) {
      AppLogger.e('Error fetching profile completion: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTheme(ThemeMode mode) {
    themeController.changeTheme(mode);
  }

  // 🟢 New function to change and save the language
  Future<void> changeLanguage(Locale locale) async {
    Get.updateLocale(locale); // Instantly update UI
    const storage = FlutterSecureStorage();
    await storage.write(
      key: 'app_lang',
      value: locale.languageCode,
    ); // Save to storage
    await storage.write(
      key: 'app_country',
      value: locale.countryCode ?? '',
    ); // Save to storage
  }

  void logout() {
    authController.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
