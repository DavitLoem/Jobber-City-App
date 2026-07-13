import 'package:flutter/material.dart';
import 'package:jobber_city/models/master_data_model.dart';

import '../network/api_client.dart';

class MasterDataService {
  final ApiClient _apiClient = ApiClient();

  Future<MasterDataResponse> fetchMasterData({
    required String endpoint,
    String? searchQuery,
  }) async {
    try {
      // 🎯 ១. ដកពាក្យ /api/ ចេញ បើ ApiClient របស់អ្នកមានវារួចហើយ
      String url = '/master-data/$endpoint';

      if (searchQuery != null && searchQuery.isNotEmpty) {
        url += '?search=$searchQuery';
      }

      final response = await _apiClient.get(url);

      // 🎯 ២. ដោយសារ response នេះជា Map ស្រាប់ យើងមិនបាច់ដាក់ response.data ទេ!
      if (response != null) {
        return MasterDataResponse.fromJson(response);
      } else {
        throw Exception("Master Data Response is null");
      }
    } catch (e) {
      // ដាក់ debugPrint ដើម្បីឱ្យងាយស្រួលមើលឃើញក្នុង Console
      debugPrint('🔥 Service Error Master Data ($endpoint): $e');
      rethrow;
    }
  }
}
