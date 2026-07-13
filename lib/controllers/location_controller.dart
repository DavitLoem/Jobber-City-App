import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/location_services.dart';

import '../models/location_model.dart';

class LocationController extends GetxController {
  final LocationServices _locationServices = LocationServices();

  final provinces = <LocationModel>[].obs;
  final districtsCache = <String, List<LocationModel>>{}.obs;
  final isLoadingProvinces = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProvinces();
  }

  Future<void> fetchProvinces() async {
    isLoadingProvinces.value = true;
    try {
      final res = await _locationServices.getProvinces();
      provinces.assignAll(res);
    } finally {
      isLoadingProvinces.value = false;
    }
  }

  Future<List<LocationModel>> getDistricts(String provinceId) async {
    // បើធ្លាប់ទាញខេត្តនេះរួចហើយ ទាញពី Cache មកឱ្យភ្លាមៗ (មិនបាច់រង់ចាំ API)
    if (districtsCache.containsKey(provinceId)) {
      return districtsCache[provinceId]!;
    }
    try {
      final dists = await _locationServices.getDistricts(provinceId);
      districtsCache[provinceId] = dists; // Save ចូល Cache ទុកប្រើថ្ងៃក្រោយ
      return dists;
    } catch (e) {
      return [];
    }
  }
}
