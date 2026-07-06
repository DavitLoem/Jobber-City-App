import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/industry_model.dart';

class IndustryServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<IndustryModel>> getIndustries() async {
    try {
      // 🟢 កែពាក្យ master-date ទៅជា master-data រួចថែមសញ្ញា / នៅខាងចុង
      final response = await _apiClient.get('/master-data/industries/');

      // ចាប់យកទិន្នន័យ (ទោះបី API បោះមកជាទម្រង់ { "data": [...] } ឬ [...] ផ្ទាល់ក៏ដោយ)
      dynamic data = response;
      if (response != null && response is Map && response.containsKey('data')) {
        data = response['data'];
      }

      if (data != null && data is List) {
        return data.map((e) => IndustryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Service Error fetching industries: $e');
      rethrow;
    }
  }
}
