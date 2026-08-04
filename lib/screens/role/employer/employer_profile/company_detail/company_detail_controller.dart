part of 'company_detail_view.dart';

class CompanyDetailViewController extends GetxController {
  // ── Controllers ផ្សេងៗដែលត្រូវប្រើ ──
  final masterCtrl = Get.find<MasterDataController>();
  final locationCtrl = Get.find<LocationController>();

  final JobService _jobService = JobService();

  // យើងអាចយក Profile ពី EmployerProfileViewController មកប្រើតែម្តង
  CompanyProfileModel? get companyProfile {
    if (Get.isRegistered<EmployerProfileViewController>()) {
      return Get.find<EmployerProfileViewController>().companyProfile.value;
    }
    return null;
  }

  final isLocationLoaded = false.obs;

  final activeJobs = <JobDataModel>[].obs;
  final isLoadingJobs = false.obs;
  final isLoadingMoreJobs = false.obs;

  int _currentPage = 1;
  final int _limit = 5;
  bool _hasMoreData = true;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(_scrollListener);
  }

  @override
  onReady() {
    super.onReady();
    _fetchActiveJobs(isRefresh: true);
  }

  // មុខងារទាញយកការងារសកម្ម
  Future<void> _fetchActiveJobs({bool isRefresh = false}) async {
    if (companyProfile == null) return;

    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      isLoadingJobs.value = true;
      activeJobs.clear();
    } else {
      if (isLoadingMoreJobs.value || !_hasMoreData) return;
      isLoadingMoreJobs.value = true;
    }

    try {
      // ធានាថា Master Data មានក្នុង Cache សិន
      if (masterCtrl.masterDataCache['employment-types'] == null) {
        await masterCtrl.getMasterData(endpoint: 'employment-types');
      }

      // ហៅ API ទាញយកការងារ
      final response = await _jobService.getJobs(
        page: _currentPage,
        limit: _limit,
        status: 'active',
      );

      if (response.success) {
        // លុបការ Filter (.where) ចោល ព្រោះ API គួរតែទាញមកតែ Active ស្រាប់
        final fetchedActiveJobs = response.data;

        if (isRefresh) {
          activeJobs.assignAll(fetchedActiveJobs);
        } else {
          activeJobs.addAll(fetchedActiveJobs);
        }

        if (response.data.length < _limit) {
          _hasMoreData = false;
        } else {
          _currentPage++;
        }
        await _fetchDistrictsForLoadedData();
      }
    } catch (e) {
      debugPrint("Error fetching active jobs: $e");
    } finally {
      isLoadingJobs.value = false;
      isLoadingMoreJobs.value = false;
    }
  }

  void _scrollListener() {
    // 🎯 ១. ការពារកុំឱ្យវាដើរ បើមិនទាន់ភ្ជាប់ជាមួយ UI ពេញលេញ
    if (!scrollController.hasClients) return;

    // 🎯 ២. ការពារកុំឱ្យវាហៅ API ផ្ទួនៗគ្នាពេលកំពុង Load ស្រាប់
    if (isLoadingJobs.value || isLoadingMoreJobs.value) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      // ប្រសិនបើអូសជិតដល់បាត (សល់ 200 pixels) ទើបហៅទិន្នន័យបន្ថែម
      _fetchActiveJobs(isRefresh: false);
    }
  }

  // ── Helper Methods សម្រាប់បំប្លែង ID ទៅជាឈ្មោះ ──

  String getEmploymentTypeName(String? typeId) {
    if (typeId == null || typeId.isEmpty) return '';

    try {
      final types = masterCtrl.masterDataCache['employment-types'];
      if (types != null) {
        final type = types.firstWhere((t) => t.id == typeId);
        return type.name;
      }
    } catch (_) {}

    return '';
  }

  String getIndustryName(String? industryId) {
    if (industryId == null || industryId.isEmpty) return 'Unknown Industry';
    try {
      final industries = masterCtrl.masterDataCache['industries'];
      if (industries != null) {
        final industry = industries.firstWhere((i) => i.id == industryId);
        return industry.name; // ឈ្មោះ Field តាម Model របស់អ្នក
      }
    } catch (_) {}
    return 'Unknown Industry';
  }

  String getLocationName(String? provId, String? distId) {
    if (provId == null || provId.isEmpty) return 'Unknown Location';
    String location = '';

    try {
      // យកឈ្មោះខេត្ត
      final province = locationCtrl.provinces.firstWhere((p) => p.id == provId);
      location = province.nameEn; // ឈ្មោះ Field តាម Model របស់អ្នក

      // បើមាន Cache ស្រុក អាចយកមកបង្ហាញបន្ថែមបាន
      if (distId != null && locationCtrl.districtsCache.containsKey(provId)) {
        final district = locationCtrl.districtsCache[provId]!.firstWhere(
          (d) => d.id == distId,
        );
        location = "${district.nameEn}, $location";
      }
    } catch (_) {}

    return location.isEmpty ? 'Unknown Location' : location;
  }

  // 🎯 មុខងារថ្មីសម្រាប់ទាញយក District មកញាត់ចូលក្នុង Cache
  Future<void> _fetchDistrictsForLoadedData() async {
    final Set<String> provinceIdsToFetch = {};

    if (companyProfile?.provinceId != null &&
        companyProfile!.provinceId.isNotEmpty) {
      provinceIdsToFetch.add(companyProfile!.provinceId);
    }

    for (var job in activeJobs) {
      if (job.provinceId.isNotEmpty) {
        provinceIdsToFetch.add(job.provinceId);
      }
    }

    for (var provId in provinceIdsToFetch) {
      await locationCtrl.getDistricts(provId);
    }

    // 🎯 ២. ពេលទាញចប់ បើកកុងតាក់នេះ ដើម្បីប្រាប់ UI ឱ្យគូរឡើងវិញ
    isLocationLoaded.value = true;
    activeJobs.refresh();
  }
}
