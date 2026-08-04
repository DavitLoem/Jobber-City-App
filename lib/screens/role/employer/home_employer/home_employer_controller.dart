part of 'home_employer_view.dart';

class HomeEmployerViewController extends GetxController {
  // 🎯 ហៅ Service សម្រាប់ទាញយក Profile
  final CompanyProfileService _profileService = CompanyProfileService();

  final isLoading = true.obs;
  final companyProfile = Rxn<CompanyProfileModel>();

  @override
  void onInit() {
    super.onInit();
    fetchCompanyProfile();
  }

  // 🎯 អនុគមន៍ទាញយកទិន្នន័យ Company
  Future<void> fetchCompanyProfile() async {
    try {
      isLoading.value = true;
      final response = await _profileService.getMyCompanyProfile();
      if (response.success && response.data != null) {
        companyProfile.value = response.data;
      }
    } catch (e) {
      debugPrint('Error fetching company profile in Home: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
