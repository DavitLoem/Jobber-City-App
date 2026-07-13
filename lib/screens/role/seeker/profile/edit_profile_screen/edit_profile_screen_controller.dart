import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/api/services/location_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/category_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/district_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_profile_services.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/role/seeker/category_model.dart';
import 'package:jobber_city/models/role/seeker/district_model.dart';
import 'package:jobber_city/models/role/seeker/location_model.dart';
import 'package:jobber_city/models/role/seeker/seeker_profile_model.dart';

class EditProfileScreenViewController extends GetxController {
  // ── Services (original kept + new added) ──
  final _seekerServices = AuthServices();
  final _profileServices = SeekerProfileServices();
  final _locationServices = LocationServices();
  final _districtServices = DistrictServices();
  final _categoryServices = CategoryServices();
  final _storage = const FlutterSecureStorage();

  // ═══════════════════════════════════════════════
  // ORIGINAL controllers (kept exactly as-is)
  // ═══════════════════════════════════════════════
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();

  // ORIGINAL reactive vars (kept exactly as-is)
  var isLoading = true.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var position = ''.obs;
  var selectedCategoryNames = ''.obs;

  // ORIGINAL lists & IDs (kept exactly as-is)
  var provincesList = <LocationModel>[].obs;
  var categoriesList = <CategoryModel>[].obs;
  var selectedProvinceId = ''.obs;
  var selectedCategoryIds = <String>[].obs;

  // ═══════════════════════════════════════════════
  // ADDED — Reactive variables for full form
  // ═══════════════════════════════════════════════
  var phone = ''.obs;
  var currentPosition = ''.obs;
  var dateOfBirth = ''.obs;
  var nationality = ''.obs;
  var commune = ''.obs;
  var village = ''.obs;
  var street = ''.obs;
  var houseNo = ''.obs;
  var selectedGender = ''.obs;
  var selectedMaritalStatus = ''.obs;

  // ═══════════════════════════════════════════════
  // ADDED — Controllers (synced with reactive vars)
  // ═══════════════════════════════════════════════
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final dateOfBirthCtrl = TextEditingController();
  final nationalityCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final maritalStatusCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final currentPositionCtrl = TextEditingController();
  final provinceCtrl = TextEditingController();
  final districtCtrl = TextEditingController();
  final communeCtrl = TextEditingController();
  final villageCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final houseNoCtrl = TextEditingController();

  // ADDED — Extra lists & IDs
  var districtsList = <DistrictModel>[].obs;
  var selectedDistrictId = ''.obs;
  var isSaving = false.obs;
  var isFormValid = false.obs;

  // Profile image upload
  final profileImagePath = ''.obs;
  final profileImageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();

  final List<String> nationalities = [
    'Cambodian',
    'Vietnamese',
    'Chinese',
    'American',
    'French',
    'Japanese',
    'Korean',
    'Other',
  ];

  // ═══════════════════════════════════════════════
  // onInit — original kept exactly, no changes
  // ═══════════════════════════════════════════════
  @override
  void onInit() {
    super.onInit();

    // Add listeners to all controllers for validation
    _addValidationListeners();

    // Get category IDs from FlutterSecureStorage
    _storage.read(key: 'temp_category_ids').then((value) {
      if (value != null) {
        final List<dynamic> ids = jsonDecode(value);
        selectedCategoryIds.assignAll(ids.map((e) => e.toString()).toList());
        debugPrint("Set categoryIds from storage: $ids");
      }
    });

    // Get arguments from navigation
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      debugPrint("Navigation arguments: $args");

      if (args['province_id'] != null) {
        selectedProvinceId.value = args['province_id'].toString();
        debugPrint(
          "Set province_id from arguments: ${selectedProvinceId.value}",
        );
      }

      if (args['category_ids'] != null && args['category_ids'] is List) {
        selectedCategoryIds.assignAll(
          (args['category_ids'] as List).map((e) => e.toString()),
        );
        debugPrint("Set categoryIds from arguments: $selectedCategoryIds");
      }
    }

    fetchInitialData();
    fetchProfileRaw();
  }

  void _addValidationListeners() {
    final controllers = [
      firstNameController,
      lastNameController,
      emailController,
      phoneCtrl,
      currentPositionCtrl,
      districtCtrl,
      genderCtrl,
      maritalStatusCtrl,
    ];
    for (var ctrl in controllers) {
      ctrl.addListener(_validateForm);
    }
    selectedGender.listen((_) => _validateForm());
    selectedMaritalStatus.listen((_) => _validateForm());
    selectedProvinceId.listen((_) => _validateForm());
    selectedDistrictId.listen((_) => _validateForm());
    selectedCategoryIds.listen((_) => _validateForm());
  }

  void _validateForm() {
    final isValid =
        firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        phoneCtrl.text.trim().isNotEmpty &&
        currentPositionCtrl.text.trim().isNotEmpty &&
        genderCtrl.text.trim().isNotEmpty &&
        maritalStatusCtrl.text.trim().isNotEmpty &&
        selectedProvinceId.value.isNotEmpty &&
        selectedDistrictId.value.isNotEmpty &&
        selectedCategoryIds.isNotEmpty;
    isFormValid.value = isValid;
  }

  // ═══════════════════════════════════════════════
  // fetchInitialData — original kept exactly
  // ═══════════════════════════════════════════════
  Future<void> fetchInitialData() async {
    try {
      //final provinces = await _locationServices.getLocation();
      //provincesList.assignAll(provinces);
      //debugPrint("Loaded ${provinces.length} provinces");

      final categories = await _categoryServices.getCategories();
      // categoriesList.assignAll(categories);
      debugPrint("Loaded ${categories.length} categories");

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
        // Also sync new ctrl
        currentPosition.value = categoryNames;
        currentPositionCtrl.text = categoryNames;
        debugPrint("Set position from categories: $categoryNames");
      } else {
        debugPrint(
          "No categories matched - selectedCategoryIds empty: ${selectedCategoryIds.isEmpty}, categoriesList empty: ${categoriesList.isEmpty}",
        );
      }

      if (selectedProvinceId.isNotEmpty && provincesList.isNotEmpty) {
        final province = provincesList.firstWhereOrNull(
          (p) => p.id.toString() == selectedProvinceId.value,
        );
        if (province != null) {
          provinceController.text = province.nameEn;
          provinceCtrl.text = province.nameEn; // sync new ctrl
          debugPrint("Set province name: ${province.nameEn}");
        }
      }
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
    }
  }

  // ═══════════════════════════════════════════════
  // ADDED — fetch districts when province selected
  // ═══════════════════════════════════════════════
  Future<void> fetchDistricts(String provinceId) async {
    try {
      districtsList.clear();
      districtCtrl.clear();
      selectedDistrictId.value = '';
      final dists = await _districtServices.getDistricts(provinceId);
      districtsList.assignAll(dists);
      debugPrint("Loaded ${dists.length} districts");
    } catch (e) {
      debugPrint("Error fetching districts: $e");
    }
  }

  // ═══════════════════════════════════════════════
  // Option providers (original kept + new added)
  // ═══════════════════════════════════════════════
  Future<List<LocationModel>> fetchProvinceOptions() async {
    try {
      if (provincesList.isNotEmpty) return provincesList;
      // return await _locationServices.getLocation();
      return [];
    } catch (e) {
      debugPrint("Error fetching province options: $e");
      return [];
    }
  }

  Future<List<DistrictModel>> fetchDistrictOptions() async {
    try {
      if (selectedProvinceId.value.isEmpty) return [];
      if (districtsList.isNotEmpty) return districtsList;
      return await _districtServices.getDistricts(selectedProvinceId.value);
    } catch (e) {
      debugPrint("Error fetching district options: $e");
      return [];
    }
  }

  Future<List<String>> fetchNationalityOptions() async => nationalities;

  // ═══════════════════════════════════════════════
  // Profile image upload methods
  // ═══════════════════════════════════════════════
  Future<void> pickProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImagePath.value = pickedFile.path;
      await uploadProfileImage(pickedFile.path);
    }
  }

  Future<void> uploadProfileImage(String filePath) async {
    try {
      isSaving.value = true;
      final response = await _profileServices.profileImage(filePath);
      debugPrint('Profile image upload response: $response');
      Get.snackbar('Success', 'Profile image uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload profile image: $e');
      debugPrint('Error uploading profile image: $e');
      debugPrint('Error type: ${e.runtimeType}');
    } finally {
      isSaving.value = false;
    }
  }

  // ═══════════════════════════════════════════════
  // checkTokenExpiry — original kept exactly
  // ═══════════════════════════════════════════════
  Future<void> checkTokenExpiry() async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      AppLogger.i("Don't have access token");
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
        AppLogger.i("Your Token: ${token.substring(0, 15)}...");
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

  // ═══════════════════════════════════════════════
  // fetchProfileRaw — original logic kept exactly,
  // extended to also populate new fields/ctrls
  // ═══════════════════════════════════════════════
  void fetchProfileRaw() async {
    checkTokenExpiry();
    try {
      isLoading.value = true;
      AppLogger.i("Fetching Profile data...");

      final response = await _seekerServices.getRawProfile();
      var data = response['data'];

      // ── Original fields (kept exactly) ──
      firstName.value = data['first_name'] ?? 'NoName';
      lastName.value = data['last_name'] ?? '';
      email.value = data['email'] ?? '';
      position.value = data['position'] ?? data['job_title'] ?? '';

      firstNameController.text = firstName.value;
      lastNameController.text = lastName.value;
      emailController.text = email.value;
      positionController.text = position.value;

      // ── Sync new Ctrl mirrors too ──
      firstNameCtrl.text = firstName.value;
      lastNameCtrl.text = lastName.value;
      emailCtrl.text = email.value;

      // ── New fields populated from API ──
      phone.value = data['phone_number'] ?? '';
      dateOfBirth.value = data['date_of_birth'] ?? '';
      nationality.value = data['nationality'] ?? '';
      selectedGender.value = data['gender'] ?? '';
      selectedMaritalStatus.value = data['marital_status'] ?? '';
      commune.value = data['commune'] ?? '';
      village.value = data['village'] ?? '';
      street.value = data['street'] ?? '';
      houseNo.value = data['house_no'] ?? '';
      currentPosition.value = position.value;

      phoneCtrl.text = phone.value;
      dateOfBirthCtrl.text = dateOfBirth.value;
      nationalityCtrl.text = nationality.value;
      genderCtrl.text = selectedGender.value;
      maritalStatusCtrl.text = selectedMaritalStatus.value;
      communeCtrl.text = commune.value;
      villageCtrl.text = village.value;
      streetCtrl.text = street.value;
      houseNoCtrl.text = houseNo.value;
      currentPositionCtrl.text = currentPosition.value;

      // Profile image URL from API
      profileImageUrl.value = data['profile_image_url'] ?? '';
      debugPrint('Profile image URL: ${profileImageUrl.value}');

      // Province + district
      final pId = data['province_id']?.toString() ?? '';
      final dId = data['district_id']?.toString() ?? '';
      if (pId.isNotEmpty) {
        selectedProvinceId.value = pId;
        await fetchDistricts(pId);
        final p = provincesList.firstWhereOrNull((e) => e.id.toString() == pId);
        if (p != null) {
          provinceController.text = p.nameEn;
          provinceCtrl.text = p.nameEn;
        }
        if (dId.isNotEmpty) {
          selectedDistrictId.value = dId;
          final d = districtsList.firstWhereOrNull(
            (e) => e.id.toString() == dId,
          );
          if (d != null) districtCtrl.text = d.nameEn;
        }
      }

      // Categories from API (override storage/args)
      final apiCategoryIds = data['expertise_category_ids'];
      if (apiCategoryIds != null &&
          apiCategoryIds is List &&
          apiCategoryIds.isNotEmpty) {
        selectedCategoryIds.assignAll(apiCategoryIds.map((e) => e.toString()));
        _syncCategoryDisplay();
      }

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

  void _syncCategoryDisplay() {
    if (categoriesList.isEmpty || selectedCategoryIds.isEmpty) return;
    final names = categoriesList
        .where((c) => selectedCategoryIds.contains(c.id))
        .map((c) => c.name)
        .join(', ');
    if (names.isNotEmpty) {
      position.value = names;
      positionController.text = names;
      currentPosition.value = names;
      currentPositionCtrl.text = names;
    }
  }

  // ═══════════════════════════════════════════════
  // ADDED — Save profile
  // ═══════════════════════════════════════════════
  Future<void> updateProfile() async {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty) {
      Get.snackbar("Notice", "First Name and Last Name are required!");
      return;
    }
    isSaving.value = true;
    try {
      final requestModel = SeekerProflieModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        dateOfBirth:
            DateTime.tryParse(dateOfBirthCtrl.text.trim()) ?? DateTime.now(),
        nationality: nationalityCtrl.text.trim(),
        gender: genderCtrl.text.trim(),
        maritalStatus: maritalStatusCtrl.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneCtrl.text.trim(),
        currentPosition: currentPositionCtrl.text.trim(),
        provinceId: selectedProvinceId.value.isEmpty
            ? '1'
            : selectedProvinceId.value,
        districtId: selectedDistrictId.value.isEmpty
            ? '1'
            : selectedDistrictId.value,
        commune: communeCtrl.text.trim(),
        village: villageCtrl.text.trim(),
        street: streetCtrl.text.trim(),
        houseNo: houseNoCtrl.text.trim(),
        biography: '',
        expectedSalaryMin: 0,
        expectedSalaryMax: 0,
        jobTypePreferences: [],
        expertiseCategoryIds: selectedCategoryIds.toList(),
        skills: [],
        portfolioUrl: '',
        linkedinUrl: '',
      );
      await _profileServices.updateSeekerProfile(requestModel);
      await _storage.delete(key: 'temp_category_ids');

      Get.back();

      // Small pause for the route transition to settle, then show message
      await Future.delayed(const Duration(milliseconds: 300));
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  // ADDED — Date picker
  void selectDate() {
    showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        final f =
            "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
        dateOfBirthCtrl.text = f;
        dateOfBirth.value = f;
      }
    });
  }

  // ═══════════════════════════════════════════════
  // ADDED — Dispose all controllers
  // ═══════════════════════════════════════════════
  @override
  void onClose() {
    // Original
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    positionController.dispose();
    provinceController.dispose();
    // New
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    dateOfBirthCtrl.dispose();
    nationalityCtrl.dispose();
    genderCtrl.dispose();
    maritalStatusCtrl.dispose();
    phoneCtrl.dispose();
    currentPositionCtrl.dispose();
    provinceCtrl.dispose();
    districtCtrl.dispose();
    communeCtrl.dispose();
    villageCtrl.dispose();
    streetCtrl.dispose();
    houseNoCtrl.dispose();
    super.onClose();
  }
}
