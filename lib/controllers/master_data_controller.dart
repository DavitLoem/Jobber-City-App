import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/master_data_service.dart';
import 'package:jobber_city/models/master_data_model.dart';

class MasterDataController extends GetxController {
  final MasterDataService _service = MasterDataService();

  // ── Cache ──
  // ផ្ទុកទិន្នន័យរួម ឧ. { 'industries': [...], 'skills': [...] }
  final masterDataCache = <String, List<MasterDataModel>>{}.obs;

  // ── Loading States ──
  // ផ្ទុក Loading ដាច់ដោយឡែក ឧ. { 'industries': false, 'skills': true }
  final loadingStates = <String, bool>{}.obs;

  // មុខងារសម្រាប់ឆែកមើល Loading នៅលើ UI
  bool isLoading(String endpoint) => loadingStates[endpoint] ?? false;

  // ── Core Function ──
  Future<List<MasterDataModel>> getMasterData({
    required String endpoint,
    String? search,
  }) async {
    // ១. ឆែកមើលថាតើជាការ Search ឬទាញទិន្នន័យធម្មតា?
    final isSearch = search != null && search.trim().isNotEmpty;

    // ២. បើទាញធម្មតា ហើយមានក្នុង Cache ស្រាប់ យកពី Cache មកប្រើភ្លាមៗ!
    if (!isSearch && masterDataCache.containsKey(endpoint)) {
      return masterDataCache[endpoint]!;
    }

    // ៣. បើអត់មាន (ឬកំពុង Search) ចាប់ផ្តើមហៅ API
    loadingStates[endpoint] = true;

    try {
      final res = await _service.fetchMasterData(
        endpoint: endpoint,
        searchQuery: search,
      );

      // ៤. យកទៅទុកក្នុង Cache តែក្នុងករណីគ្មាន Search ប៉ុណ្ណោះ
      if (!isSearch) {
        masterDataCache[endpoint] = res.data;
      }

      return res.data;
    } catch (e) {
      return [];
    } finally {
      loadingStates[endpoint] = false;
    }
  }

  String getMasterDataName(String cacheKey, String id) {
    if (id.isEmpty) return '';

    try {
      // ១. ចាប់យកបញ្ជីទិន្នន័យផ្អែកលើ Key (ឧ. 'skills', 'employment-types')
      final dataList = masterDataCache[cacheKey];

      if (dataList != null) {
        // ២. ស្វែងរកធាតុដែលមាន ID ត្រូវគ្នា
        // ចំណាំ៖ សូមប្តូរ element.id និង element.name ទៅតាម Field ពិតរបស់ Master Data Model
        final item = dataList.firstWhereOrNull((element) => element.id == id);

        // ៣. បើរកឃើញបោះឈ្មោះឱ្យ បើរកមិនឃើញបោះ ID សិន
        return item?.name ?? id;
      }
    } catch (_) {
      debugPrint("🔥 Error getting name for $cacheKey with ID $id");
    }

    // Fallback ប្រសិនបើមានបញ្ហា ឬរកមិនឃើញ Cache
    return id;
  }
}
