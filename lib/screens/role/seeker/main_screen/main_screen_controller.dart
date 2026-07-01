import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreenController extends GetxController {
  // អថេរសម្រាប់កំណត់ទីតាំង Tab (ចាប់ផ្តើមពីលេខ 0 គឺ Home)
  var currentIndex = 0.obs;

  // Store arguments to pass to child screens
  Map<String, dynamic>? _arguments;

  @override
  void onInit() {
    super.onInit();
    try {
      // Get arguments from navigation
      _arguments = Get.arguments;
      debugPrint("MainScreenController received arguments: $_arguments");
    } catch (e) {
      debugPrint("Error in MainScreenController onInit: $e");
    }
  }

  Map<String, dynamic>? getArguments() => _arguments;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
