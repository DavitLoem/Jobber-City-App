part of 'company_profile_view.dart';

class CompanyProfileViewController extends GetxController {
  final CompanyServices _companyServices = CompanyServices();
  final CategoryServices _categoryServices = CategoryServices();
  final DistrictServices _districtServices = DistrictServices();
  final LocationServices _locationServices = LocationServices();

  final isLoading = false.obs;

  // Controllers
  final companyNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactEmailController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final websiteUrlController = TextEditingController();
  final addressDetailController = TextEditingController();

  // 🟢 ១. អថេរសម្រាប់ផ្ទុករូបភាព Logo
  final companyLogoPath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // Rx Variables
  final selectedIndustryId = ''.obs;
  final selectedCompanySize = ''.obs;
  final selectedProvinceId = ''.obs;
  final selectedDistrictId = ''.obs;

  // Lists
  final industriesList = <CategoryModel>[].obs;
  final provincesList = <LocationModel>[].obs;
  final districtsList = <DistrictModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  void fetchInitialData() async {
    try {
      var cats = await _categoryServices.getCategories();
      industriesList.assignAll(cats);

      var provData = await _locationServices.getLocation();
      provincesList.assignAll(provData);

      Future.delayed(
        const Duration(milliseconds: 300),
        _checkAndSetInitialData,
      );
    } catch (e) {
      debugPrint("Init Error: $e");
    }
  }

  void onProvinceChanged(String? provinceId) {
    if (provinceId == null) return;
    selectedProvinceId.value = provinceId;
    selectedDistrictId.value = '';
    districtsList.clear();
    fetchDistricts(provinceId);
  }

  void fetchDistricts(String provinceId) async {
    try {
      var distData = await _districtServices.getDistricts(provinceId);
      districtsList.assignAll(distData);
    } catch (e) {
      debugPrint("Error districts: $e");
    }
  }

  void _checkAndSetInitialData() {
    if (Get.arguments != null) {
      if (Get.arguments is Map) {
        final args = Get.arguments as Map<String, dynamic>;
        if (args['email'] != null)
          contactEmailController.text = args['email'].toString();
        if (args['industry_id'] != null)
          selectedIndustryId.value = args['industry_id'].toString();
        if (args['province_id'] != null)
          onProvinceChanged(args['province_id'].toString());
      } else if (Get.arguments is String) {
        contactEmailController.text = Get.arguments.toString();
      }
    }
  }

  // 🟢 ២. មុខងារសម្រាប់ជ្រើសរើសរូបភាព
  Future<void> pickCompanyLogo() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // បង្រួមទំហំរូបភាពបន្តិចដើម្បីកុំឱ្យធ្ងន់ពេក
      );
      if (image != null) {
        companyLogoPath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not pick image: $e');
    }
  }

  Future<void> submitCompanyProfile() async {
    if (companyNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Company Name is required');
      return;
    }

    isLoading.value = true;
    try {
      final requestData = CompanyProfileModel(
        companyName: companyNameController.text.trim(),
        industryId: selectedIndustryId.value.isEmpty
            ? "1"
            : selectedIndustryId.value,
        companySize: selectedCompanySize.value.isEmpty
            ? "1-10"
            : selectedCompanySize.value,
        description: descriptionController.text.trim(),
        contactEmail: contactEmailController.text.trim(),
        contactPhone: contactPhoneController.text.trim(),
        websiteUrl: websiteUrlController.text.trim(),
        provinceId: selectedProvinceId.value.isEmpty
            ? "1"
            : selectedProvinceId.value,
        districtId: selectedDistrictId.value.isEmpty
            ? "1"
            : selectedDistrictId.value,
        addressDetail: addressDetailController.text.trim(),
      );

      // ៣.១ បញ្ជូនទិន្នន័យ Profile ទៅកាន់ Server
      await _companyServices.companyProfile(requestData);

      // 🟢 ៣.២ បញ្ជូនរូបភាព Logo ទៅកាន់ Server (ប្រសិនបើមានរើសរូបភាព)
      if (companyLogoPath.value.isNotEmpty &&
          !companyLogoPath.value.startsWith('http')) {
        await _companyServices.companyLogoUpload(companyLogoPath.value);
      }

      Get.snackbar('Success', 'Profile updated successfully!');
      Get.offAllNamed(AppRoutes.homeEmployer);
    } catch (e) {
      Get.snackbar('Failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    descriptionController.dispose();
    contactEmailController.dispose();
    contactPhoneController.dispose();
    websiteUrlController.dispose();
    addressDetailController.dispose();
    super.onClose();
  }
}
