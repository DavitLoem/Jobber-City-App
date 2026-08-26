part of 'company_detail_view.dart';

class CompanyDetailViewController extends GetxController {
  final masterCtrl = Get.find<MasterDataController>();
  final locationCtrl = Get.find<LocationController>();

  final JobService _jobService = JobService();

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
      if (masterCtrl.masterDataCache['employment-types'] == null) {
        await masterCtrl.getMasterData(endpoint: 'employment-types');
      }

      final response = await _jobService.getJobs(
        page: _currentPage,
        limit: _limit,
        status: 'active',
      );

      if (response.success) {
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
    if (!scrollController.hasClients) return;
    if (isLoadingJobs.value || isLoadingMoreJobs.value) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
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
    if (industryId == null || industryId.isEmpty)
      return 'Unknown Industry'.tr; // 🟢 Added .tr
    try {
      final industries = masterCtrl.masterDataCache['industries'];
      if (industries != null) {
        final industry = industries.firstWhere((i) => i.id == industryId);
        return industry.name;
      }
    } catch (_) {}
    return 'Unknown Industry'.tr; // 🟢 Added .tr
  }

  String getLocationName(String? provId, String? distId) {
    if (provId == null || provId.isEmpty)
      return 'Unknown Location'.tr; // 🟢 Added .tr
    String location = '';

    try {
      final province = locationCtrl.provinces.firstWhere((p) => p.id == provId);
      location = province.nameEn;

      if (distId != null && locationCtrl.districtsCache.containsKey(provId)) {
        final district = locationCtrl.districtsCache[provId]!.firstWhere(
          (d) => d.id == distId,
        );
        location = "${district.nameEn}, $location";
      }
    } catch (_) {}

    return location.isEmpty ? 'Unknown Location'.tr : location; // 🟢 Added .tr
  }

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

    isLocationLoaded.value = true;
    activeJobs.refresh();
  }
}
