import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final isDarkMode = false.obs;

  void changeTheme(bool value) {
    isDarkMode.value = value;

    Get.changeThemeMode(
      value ? ThemeMode.dark : ThemeMode.light,
    );
  }
}