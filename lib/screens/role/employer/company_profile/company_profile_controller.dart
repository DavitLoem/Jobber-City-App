part of 'company_profile_view.dart';

class CompanyProfileViewController extends GetxController {
  final CompanyServices _companyServices = CompanyServices();
  final IndustryServices _industryServices = IndustryServices();
  final DistrictServices _districtServices = DistrictServices();
  final LocationServices _locationServices = LocationServices();

  final isLoading = false.obs;
  final isFetching = true.obs;

  final industriesError = Rxn<String>();
  final locationsError = Rxn<String>();
  final isFetchingIndustries = false.obs;

  // Controllers
  final companyNameController = TextEditingController();
  final contactEmailController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final websiteUrlController = TextEditingController();
  final addressDetailController = TextEditingController();
  final industryCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final provinceCtrl = TextEditingController();
  final districtCtrl = TextEditingController();
  final companySizeCtrl = TextEditingController();

  // Image & IDs
  final companyLogoPath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  final selectedIndustryId = ''.obs;
  final selectedCompanySize = ''.obs;
  final selectedProvinceId = ''.obs;
  final selectedDistrictId = ''.obs;

  // Lists
  final industriesList = <IndustryModel>[].obs;
  final provincesList = <LocationModel>[].obs;
  final districtsList = <DistrictModel>[].obs;
  final companySizes = ["1-10", "11-50", "51-200", "201-500", "500+"].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  void fetchInitialData() async {
    isFetching.value = true;
    try {
      final inds = await _industryServices.getIndustries();
      industriesList.assignAll(inds);

      final provs = await _locationServices.getLocation();
      provincesList.assignAll(provs);
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> fetchDistricts(String provinceId) async {
    try {
      districtsList.clear();
      final dists = await _districtServices.getDistricts(provinceId);
      districtsList.assignAll(dists);
    } catch (e) {
      debugPrint("Error fetching districts: $e");
    }
  }

  Future<void> pickCompanyLogo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      companyLogoPath.value = pickedFile.path;
    }
  }

  Future<void> saveProfile() async {
    if (companyNameController.text.trim().isEmpty) {
      _notice('Company Name is required');
      return;
    }

    // 🟢 បញ្ឈប់ការ Save ប្រសិនបើមិនទាន់រើស Industry
    if (selectedIndustryId.value.isEmpty) {
      _notice('Please select an Industry!');
      return;
    }

    if (descriptionCtrl.text.trim().length < 10) {
      _notice('Company Description must have at least 10 characters!');
      return;
    }

    isLoading.value = true;
    try {
      final requestData = CompanyProfileModel(
        companyName: companyNameController.text.trim(),
        industryId:
            selectedIndustryId.value, // 🟢 បញ្ជូន ID របស់ Industry ទៅ API
        companySize: selectedCompanySize.value.isEmpty
            ? "1-10"
            : selectedCompanySize.value,
        description: descriptionCtrl.text.trim(),
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

      await _companyServices.companyProfile(requestData);

      if (companyLogoPath.value.isNotEmpty &&
          !companyLogoPath.value.startsWith('http')) {
        await _companyServices.companyLogoUpload(companyLogoPath.value);
      }

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed(AppRoutes.homeEmployer);
    } catch (e) {
      Get.snackbar(
        'Failed',
        _extractErrorMessage(e),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _notice(String message) {
    Get.snackbar(
      'Notice',
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  String _extractErrorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['errors'] is List && data['errors'].isNotEmpty) {
        final first = data['errors'][0];
        if (first is Map) {
          final field = first['field'];
          final message = first['message'];
          if (field != null && message != null) return '$field: $message';
          if (message != null) return message.toString();
        }
      }
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    }
    return e.toString();
  }

  @override
  void onClose() {
    companyNameController.dispose();
    contactEmailController.dispose();
    contactPhoneController.dispose();
    websiteUrlController.dispose();
    addressDetailController.dispose();
    industryCtrl.dispose();
    descriptionCtrl.dispose();
    provinceCtrl.dispose();
    districtCtrl.dispose();
    companySizeCtrl.dispose();
    super.onClose();
  }
}
