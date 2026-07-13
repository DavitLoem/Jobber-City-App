part of 'detail_post_screen_view.dart';

class DetailPostScreenViewController extends GetxController {
  var job = Rxn<EmployerJobModel>();

  var provinceName = ''.obs;
  var districtName = ''.obs;
  var categoryName = ''.obs;
  var jobLevelName = ''.obs;
  var workTypeName = ''.obs;
  var employmentTypeName = ''.obs;
  var educationLevelName = ''.obs;

  // 🟢 អថេរថ្មីសម្រាប់ផ្ទុកឈ្មោះ Skill ជា Array
  var skillNames = <String>[].obs;

  final LocationServices _locationServices = LocationServices();
  final DistrictServices _districtServices = DistrictServices();
  final MasterDataServices _masterDataServices = MasterDataServices();

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args is EmployerJobModel) {
      job.value = args;
    } else if (args is Map<String, dynamic>) {
      job.value = EmployerJobModel.fromJson(args);
    }
    await _resolveNames();
  }

  Future<void> _resolveNames() async {
    final currentJob = job.value;
    if (currentJob == null) return;

    try {
      // 1. ទាញយកឈ្មោះ ខេត្ត (Province)
      final provinceId = currentJob.provinceId.trim();
      if (provinceId.isNotEmpty) {
        final provinces = await _locationServices.getLocation();
        final province = provinces.firstWhereOrNull((p) => p.id == provinceId);
        if (province != null) {
          provinceName.value = province.nameEn.isNotEmpty
              ? province.nameEn
              : (province.nameKm?.toString() ?? '');
        }
      }

      // 2. ទាញយកឈ្មោះ ស្រុក (District)
      final districtId = currentJob.districtId.trim();
      if (provinceId.isNotEmpty && districtId.isNotEmpty) {
        final districts = await _districtServices.getDistricts(provinceId);
        final district = districts.firstWhereOrNull((d) => d.id == districtId);
        if (district != null) {
          districtName.value =
              district.nameEn ?? (district.nameKm?.toString() ?? '');
        }
      }

      // 3. ទាញយកឈ្មោះ Education Level
      final edLevelId = currentJob.educationLevelId.trim();
      if (edLevelId.isNotEmpty) {
        final edLevels = await _masterDataServices.getEducationLevels();
        final edLevel = edLevels.firstWhereOrNull(
          (item) => item.id == edLevelId,
        );
        educationLevelName.value = edLevel?.name ?? '';
      }

      // 4. ទាញយកឈ្មោះ Category
      final catId = currentJob.categoryId.trim();
      if (catId.isNotEmpty) {
        final categories = await _masterDataServices.getCategories();
        final category = categories.firstWhereOrNull(
          (item) => item.id == catId,
        );
        categoryName.value = category?.name ?? '';
      }

      // 5. ទាញយកឈ្មោះ Job Level
      final jlId = currentJob.jobLevelId.trim();
      if (jlId.isNotEmpty) {
        final jobLevels = await _masterDataServices.getJobLevels();
        final jobLevel = jobLevels.firstWhereOrNull((item) => item.id == jlId);
        jobLevelName.value = jobLevel?.name ?? '';
      }

      // 6. ទាញយកឈ្មោះ Work Type
      final wtId = currentJob.workTypeId.trim();
      if (wtId.isNotEmpty) {
        final workTypes = await _masterDataServices.getWorkTypes();
        final workType = workTypes.firstWhereOrNull((item) => item.id == wtId);
        workTypeName.value = workType?.name ?? '';
      }

      // 7. ទាញយកឈ្មោះ Employment Type
      final etId = currentJob.employmentTypeId.trim();
      if (etId.isNotEmpty) {
        final empTypes = await _masterDataServices.getEmploymentTypes();
        final empType = empTypes.firstWhereOrNull((item) => item.id == etId);
        employmentTypeName.value = empType?.name ?? '';
      }

      // 8. ដោះស្រាយបញ្ហា Skills
      final skillIds = currentJob.requiredSkills;
      if (skillIds.isNotEmpty) {
        final allSkills = await _masterDataServices.getSkills();
        final resolved = <String>[];
        for (final id in skillIds) {
          final match = allSkills.firstWhereOrNull((s) => s.id == id);
          resolved.add(match?.name ?? id);
        }
        skillNames.value = resolved;
      }
    } catch (e) {
      debugPrint("Error resolving names: $e");
    }
  }
}
