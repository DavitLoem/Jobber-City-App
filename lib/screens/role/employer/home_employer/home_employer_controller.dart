part of 'home_employer_view.dart';

class HomeEmployerViewController extends GetxController {
  final CompanyProfileService _profileService = CompanyProfileService();
  final EmployerDashboardService _dashboardService = EmployerDashboardService();

  final isLoading = true.obs;
  final isDashboardLoading = true.obs;

  final companyProfile = Rxn<CompanyProfileModel>();
  final dashboardData = Rxn<EmployerDashboardResponse>();

  // ── Filter State ──
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

  // 🎯 Function to fetch Company data
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

  // 🎯 Function to fetch actual Dashboard data
  Future<void> fetchDashboardOverview() async {
    try {
      isDashboardLoading.value = true;
      final response = await _dashboardService.getDashboardOverview(
        filter: filterValue.value,
      );

      // 🟢 Update only when data is returned
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

  // ── Filter Control Functions (Update calls API when changed) ──

  void prevMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month - 1,
    );
    _updateMonthLabel();
    fetchDashboardOverview(); // 🟢 Fetch new data
  }

  void nextMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + 1,
    );
    _updateMonthLabel();
    fetchDashboardOverview(); // 🟢 Fetch new data
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

    // Convert to "YYYY-MM" to pass to Backend
    final monthStr = selectedDate.value.month.toString().padLeft(2, '0');
    filterValue.value = "${selectedDate.value.year}-$monthStr";
  }

  void setQuickFilter(String label) {
    filterLabel.value = label;
    isMonthFilter.value = false;

    // Convert Label to Key for Python API
    if (label == "Today")
      filterValue.value = "today";
    else if (label == "This Week")
      filterValue.value = "this_week";
    else if (label == "This Month")
      filterValue.value = "this_month";
    else
      filterValue.value = label; // For Custom Range "YYYY-MM-DD,YYYY-MM-DD"

    fetchDashboardOverview(); // 🟢 Fetch new data
  }

  void setMonthFilter(DateTime date) {
    selectedDate.value = date;
    isMonthFilter.value = true;
    _updateMonthLabel();
    fetchDashboardOverview(); // 🟢 Fetch new data
  }
}
