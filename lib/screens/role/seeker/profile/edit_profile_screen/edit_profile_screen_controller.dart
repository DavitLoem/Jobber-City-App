// ── ហ្វាល់ edit_profile_screen_controller.dart ──
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/api/services/category_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_profile_services.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/category_model.dart';
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/models/role/seeker/seeker_profile_model.dart';

// 🟢 បញ្ចូល LocationController
import 'package:jobber_city/controllers/location_controller.dart';

class EditProfileScreenViewController extends GetxController {
  final _seekerServices = AuthServices();
  final _profileServices = SeekerProfileServices();
  final _categoryServices = CategoryServices();
  final _storage = const FlutterSecureStorage();

  // 🟢 ប្រើប្រាស់ LocationController ដើម្បីទាញយកខេត្ត និងស្រុក[cite: 39, 41]
  final locationController = Get.put(LocationController());

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
  var selectedCategoryNames = ''.obs;

  var categoriesList = <CategoryModel>[].obs;
  var selectedProvinceId = ''.obs;
  var selectedCategoryIds = <String>[].obs;

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

  var selectedDistrictId = ''.obs;
  var isSaving = false.obs;
  var isFormValid = false.obs;

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

  @override
  void onInit() {
    super.onInit();
    _addValidationListeners();

    _storage.read(key: 'temp_category_ids').then((value) {
      if (value != null) {
        final List<dynamic> ids = jsonDecode(value);
        selectedCategoryIds.assignAll(ids.map((e) => e.toString()).toList());
      }
    });

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args['province_id'] != null) {
        selectedProvinceId.value = args['province_id'].toString();
      }
      if (args['category_ids'] != null && args['category_ids'] is List) {
        selectedCategoryIds.assignAll(
          (args['category_ids'] as List).map((e) => e.toString()),
        );
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

  Future<void> fetchInitialData() async {
    try {
      final categories = await _categoryServices.getCategories();

      if (selectedCategoryIds.isNotEmpty && categoriesList.isNotEmpty) {
        final matchedCategories = categoriesList
            .where((cat) => selectedCategoryIds.contains(cat.id))
            .toList();
        final categoryNames = matchedCategories
            .map((cat) => cat.name)
            .join(', ');
        position.value = categoryNames;
        positionController.text = categoryNames;
        currentPosition.value = categoryNames;
        currentPositionCtrl.text = categoryNames;
      }

      if (selectedProvinceId.isNotEmpty) {
        if (locationController.provinces.isEmpty) {
          await locationController.fetchProvinces();
        }
        final province = locationController.provinces.firstWhereOrNull(
          (p) => p.id.toString() == selectedProvinceId.value,
        );
        if (province != null) {
          provinceController.text = province.nameEn;
          provinceCtrl.text = province.nameEn;
        }
      }
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
    }
  }

  // 🟢 ប្រើ locationController សម្រាប់ទាញយកទិន្នន័យ[cite: 39, 41]
  Future<List<LocationModel>> fetchProvinceOptions() async {
    if (locationController.provinces.isEmpty) {
      await locationController.fetchProvinces();
    }
    return locationController.provinces;
  }

  // 🟢 ប្រើ locationController សម្រាប់ទាញយកទិន្នន័យ[cite: 39, 41]
  Future<List<LocationModel>> fetchDistrictOptions() async {
    if (selectedProvinceId.value.isEmpty) return [];
    return await locationController.getDistricts(selectedProvinceId.value);
  }

  Future<List<String>> fetchNationalityOptions() async => nationalities;

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
      Get.snackbar('Success', 'Profile image uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload profile image: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> checkTokenExpiry() async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) return;
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
        }
      }
    } catch (e) {
      debugPrint("Error decoding Token: $e");
    }
  }

  void fetchProfileRaw() async {
    checkTokenExpiry();
    try {
      isLoading.value = true;
      final response = await _seekerServices.getRawProfile();
      var data = response['data'];

      firstName.value = data['first_name'] ?? 'NoName';
      lastName.value = data['last_name'] ?? '';
      email.value = data['email'] ?? '';

      // 🟢 ជួសជុលត្រង់នេះ៖ បន្ថែមការអាន key 'current_position' ពី API
      position.value =
          data['current_position'] ??
          data['position'] ??
          data['job_title'] ??
          '';

      firstNameController.text = firstName.value;
      lastNameController.text = lastName.value;
      emailController.text = email.value;
      positionController.text = position.value;

      firstNameCtrl.text = firstName.value;
      lastNameCtrl.text = lastName.value;
      emailCtrl.text = email.value;

      phone.value = data['phone_number'] ?? '';
      dateOfBirth.value = data['date_of_birth'] ?? '';
      nationality.value = data['nationality'] ?? '';
      selectedGender.value = data['gender'] ?? '';
      selectedMaritalStatus.value = data['marital_status'] ?? '';
      commune.value = data['commune'] ?? '';
      village.value = data['village'] ?? '';
      street.value = data['street'] ?? '';
      houseNo.value = data['house_no'] ?? '';

      // 🟢 ជួសជុលត្រង់នេះ៖ ប្រើប្រាស់តម្លៃដែលអានបានពី 'current_position' ខាងលើ
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

      // 🟢 Update ចូលក្នុង TextField ឲ្យវាបង្ហាញអក្សរ
      currentPositionCtrl.text = currentPosition.value;

      profileImageUrl.value = data['profile_image_url'] ?? '';

      final pId = data['province_id']?.toString() ?? '';
      final dId = data['district_id']?.toString() ?? '';

      if (pId.isNotEmpty) {
        selectedProvinceId.value = pId;
        if (locationController.provinces.isEmpty) {
          await locationController.fetchProvinces();
        }
        final p = locationController.provinces.firstWhereOrNull(
          (e) => e.id.toString() == pId,
        );
        if (p != null) {
          provinceController.text = p.nameEn;
          provinceCtrl.text = p.nameEn;
        }

        if (dId.isNotEmpty) {
          selectedDistrictId.value = dId;
          final dists = await locationController.getDistricts(pId);
          final d = dists.firstWhereOrNull((e) => e.id.toString() == dId);
          if (d != null) districtCtrl.text = d.nameEn;
        }
      }

      final apiCategoryIds = data['expertise_category_ids'];
      if (apiCategoryIds != null &&
          apiCategoryIds is List &&
          apiCategoryIds.isNotEmpty) {
        selectedCategoryIds.assignAll(apiCategoryIds.map((e) => e.toString()));
        // ប្រសិនបើអ្នកមិនចង់ឲ្យ Categories លុបពីលើ Current Position ដែលវាយបញ្ចូលទេ
        // អាចផ្អាកការហៅ _syncCategoryDisplay() សិន ឬ កែប្រែវាកុំឲ្យ Overwrite currentPositionCtrl។
        _syncCategoryDisplay();
      }
    } catch (e) {
      Get.snackbar("Error", "Cannot fetch Profile");
    } finally {
      isLoading.value = false;
    }
  }

  // 🟢 ជួសជុលបន្ថែម៖ កុំឲ្យវាទាញ Category Name មកលុបពីលើ Current Position ដែលអ្នកបានវាយបញ្ចូល
  void _syncCategoryDisplay() {
    if (categoriesList.isEmpty || selectedCategoryIds.isEmpty) return;
    final names = categoriesList
        .where((c) => selectedCategoryIds.contains(c.id))
        .map((c) => c.name)
        .join(', ');

    // កែប្រែ៖ Update តែ position ធម្មតា កុំ Update currentPositionCtrl បើវាមានទិន្នន័យពី API រួចហើយ
    if (names.isNotEmpty) {
      // បើ currentPosition ទទេ ទើបយើងយក Category មកបង្ហាញជំនួស
      if (currentPositionCtrl.text.isEmpty) {
        currentPosition.value = names;
        currentPositionCtrl.text = names;
      }
    }
  }

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

      // 🟢 បញ្ជូនទិន្នន័យត្រឡប់ទៅកាន់ទំព័រ Profile ដើម្បី Update Badge Position[cite: 45, 46]
      Get.back(result: currentPositionCtrl.text.trim());

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

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    positionController.dispose();
    provinceController.dispose();
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
