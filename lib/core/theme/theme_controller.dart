import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeController extends GetxController {
  final themeMode = ThemeMode.system.obs;

  // Initialize secure storage
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    // Load saved theme from storage asynchronously
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    try {
      // Read the value from secure storage
      final savedTheme = await _storage.read(key: 'theme_mode');

      if (savedTheme == 'light') {
        themeMode.value = ThemeMode.light;
      } else if (savedTheme == 'dark') {
        themeMode.value = ThemeMode.dark;
      } else {
        themeMode.value = ThemeMode.system;
      }

      // Apply the loaded theme mode
      Get.changeThemeMode(themeMode.value);
    } catch (e) {
      // If storage fails, default to system theme
      themeMode.value = ThemeMode.system;
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  // Change the theme and save it to storage
  void changeTheme(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    // Save the new value to secure storage in the background
    if (mode == ThemeMode.light) {
      _storage.write(key: 'theme_mode', value: 'light');
    } else if (mode == ThemeMode.dark) {
      _storage.write(key: 'theme_mode', value: 'dark');
    } else {
      _storage.write(key: 'theme_mode', value: 'system');
    }
  }
}
