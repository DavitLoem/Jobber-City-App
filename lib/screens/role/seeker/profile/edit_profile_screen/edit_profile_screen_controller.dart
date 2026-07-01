import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/api/services/role/location_services.dart';
import 'package:jobber_city/core/api/services/role/category_services.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/role/location_model.dart';
import 'package:jobber_city/models/role/category_model.dart';

class EditProfileScreenViewController extends GetxController {
  final _seekerServices = AuthServices();
  final _locationServices = LocationServices();
  final _categoryServices = CategoryServices();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();

  var isLoading = true.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var position = ''.obs;

  var provincesList = <LocationModel>[].obs;
  var categoriesList = <CategoryModel>[].obs;
  var selectedProvinceId = ''.obs;
  var selectedCategoryIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Get arguments from navigation
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      debugPrint("Navigation arguments: $args");

      // Get province_id from arguments
      if (args['province_id'] != null) {
        selectedProvinceId.value = args['province_id'].toString();
        debugPrint(
          "Set province_id from arguments: ${selectedProvinceId.value}",
        );
      }

      // Get category_ids from arguments
      if (args['category_ids'] != null && args['category_ids'] is List) {
        selectedCategoryIds.assignAll(
          (args['category_ids'] as List).map((e) => e.toString()),
        );
        debugPrint("Set categoryIds from arguments: ${selectedCategoryIds}");
      }
    }

    fetchInitialData();
    fetchProfileRaw();
  }

  Future<void> fetchInitialData() async {
    try {
      // Fetch provinces
      final provinces = await _locationServices.getLocation();
      provincesList.assignAll(provinces);
      debugPrint("Loaded ${provinces.length} provinces");

      // Fetch categories
      final categories = await _categoryServices.getCategories();
      categoriesList.assignAll(categories);
      debugPrint("Loaded ${categories.length} categories");

      // Map category IDs to names for position display
      debugPrint("selectedCategoryIds: $selectedCategoryIds");
      debugPrint("categoriesList count: ${categoriesList.length}");
      if (categoriesList.isNotEmpty) {
        debugPrint(
          "First few category IDs from API: ${categoriesList.take(3).map((c) => c.id).toList()}",
        );
      }

      if (selectedCategoryIds.isNotEmpty && categoriesList.isNotEmpty) {
        final matchedCategories = categoriesList
            .where((cat) => selectedCategoryIds.contains(cat.id))
            .toList();
        debugPrint(
          "Matched categories: ${matchedCategories.map((c) => '${c.id}: ${c.name}').toList()}",
        );

        final categoryNames = matchedCategories
            .map((cat) => cat.name)
            .join(', ');
        position.value = categoryNames;
        positionController.text = categoryNames;
        debugPrint("Set position from categories: $categoryNames");
      } else {
        debugPrint(
          "No categories matched - selectedCategoryIds empty: ${selectedCategoryIds.isEmpty}, categoriesList empty: ${categoriesList.isEmpty}",
        );
      }

      // Set province name from ID
      if (selectedProvinceId.isNotEmpty && provincesList.isNotEmpty) {
        final province = provincesList.firstWhereOrNull(
          (p) => p.id.toString() == selectedProvinceId.value,
        );
        if (province != null) {
          provinceController.text = province.nameEn;
          debugPrint("Set province name: ${province.nameEn}");
        }
      }
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
    }
  }

  Future<List<LocationModel>> fetchProvinceOptions() async {
    try {
      if (provincesList.isNotEmpty) {
        return provincesList;
      }
      return await _locationServices.getLocation();
    } catch (e) {
      debugPrint("Error fetching province options: $e");
      return [];
    }
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
      email.value = data['email'] ?? '';
      position.value = data['position'] ?? data['job_title'] ?? '';

      // Update controllers with the data
      firstNameController.text = firstName.value;
      lastNameController.text = lastName.value;
      emailController.text = email.value;
      positionController.text = position.value;

      AppLogger.i(
        "✅ ទាញយកជោគជ័យ: ${firstName.value} ${lastName.value} ${email.value}",
      );
    } catch (e) {
      AppLogger.i("❌ បរាជ័យក្នុងការទាញយក Profile: $e");
      Get.snackbar("Error", "មិនអាចទាញយក Profile បានទេ");
    } finally {
      isLoading.value = false;
    }
  }
}
