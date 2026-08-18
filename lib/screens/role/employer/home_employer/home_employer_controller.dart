part of 'home_employer_view.dart';

class HomeEmployerViewController extends GetxController {
  // 🎯 ហៅ Service សម្រាប់ទាញយក Profile
  final CompanyProfileService _profileService = CompanyProfileService();

  final isLoading = true.obs;
  final companyProfile = Rxn<CompanyProfileModel>();

  // ── State សម្រាប់ Filter ──
  final filterLabel = 'This Month'.obs;
  final isMonthFilter = false.obs; // ដើម្បីកំណត់ថាត្រូវបង្ហាញព្រួញ < > ដែរឬទេ
  final selectedDate = DateTime.now().obs;

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

  void prevMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month - 1,
    );
    _updateMonthLabel();
  }

  // មុខងារដូរខែទៅមុខ
  void nextMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + 1,
    );
    _updateMonthLabel();
  }

  void _updateMonthLabel() {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    filterLabel.value =
        "${months[selectedDate.value.month - 1]} ${selectedDate.value.year}";
    // ទីនេះអ្នកអាចហៅ API ដូចជា: fetchDashboardOverview();
  }

  void setQuickFilter(String label) {
    filterLabel.value = label;
    isMonthFilter.value = false;
    // ហៅ API: fetchDashboardOverview();
  }

  void setMonthFilter(DateTime date) {
    selectedDate.value = date;
    isMonthFilter.value = true;
    _updateMonthLabel();
  }
}
