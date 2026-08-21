part of 'home_employer_view.dart';

class HomeEmployerViewController extends GetxController {
  final CompanyProfileService _profileService = CompanyProfileService();
  final EmployerDashboardService _dashboardService = EmployerDashboardService();

  final isLoading = true.obs;
  final isDashboardLoading = true.obs;

  final companyProfile = Rxn<CompanyProfileModel>();
  final dashboardData = Rxn<EmployerDashboardResponse>();

  // ── State សម្រាប់ Filter ──
  final filterLabel = 'This Month'.obs;
  final filterValue = 'this_month'.obs;
  final isMonthFilter = false.obs;
  final selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompanyProfile();
    fetchDashboardOverview();
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

  // 🎯 អនុគមន៍ទាញយកទិន្នន័យ Dashboard ពិតប្រាកដ
  Future<void> fetchDashboardOverview() async {
    try {
      isDashboardLoading.value = true;
      final response = await _dashboardService.getDashboardOverview(
        filter: filterValue.value,
      );

      // 🟢 Update តែពេលណាដែលមានទិន្នន័យត្រលប់មកវិញប៉ុណ្ណោះ
      if (response != null) {
        dashboardData.value = response;
      }
    } catch (e) {
      debugPrint('Error fetching dashboard: $e');
      Get.snackbar(
        "Error",
        "Could not load dashboard data.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDashboardLoading.value = false;
    }
  }

  // ── អនុគមន៍បញ្ជា Filter (Update ឱ្យហៅ API ពេលដូរ) ──

  void prevMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month - 1,
    );
    _updateMonthLabel();
    fetchDashboardOverview(); // 🟢 ទាញទិន្នន័យថ្មី
  }

  void nextMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + 1,
    );
    _updateMonthLabel();
    fetchDashboardOverview(); // 🟢 ទាញទិន្នន័យថ្មី
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

    // បំប្លែងទៅជា "YYYY-MM" សម្រាប់បោះទៅ Backend
    final monthStr = selectedDate.value.month.toString().padLeft(2, '0');
    filterValue.value = "${selectedDate.value.year}-$monthStr";
  }

  void setQuickFilter(String label) {
    filterLabel.value = label;
    isMonthFilter.value = false;

    // បំប្លែង Label ទៅជា Key សម្រាប់ API របស់ Python
    if (label == "Today")
      filterValue.value = "today";
    else if (label == "This Week")
      filterValue.value = "this_week";
    else if (label == "This Month")
      filterValue.value = "this_month";
    else
      filterValue.value = label; // សម្រាប់ Custom Range "YYYY-MM-DD,YYYY-MM-DD"

    fetchDashboardOverview(); // 🟢 ទាញទិន្នន័យថ្មី
  }

  void setMonthFilter(DateTime date) {
    selectedDate.value = date;
    isMonthFilter.value = true;
    _updateMonthLabel();
    fetchDashboardOverview(); // 🟢 ទាញទិន្នន័យថ្មី
  }
}
