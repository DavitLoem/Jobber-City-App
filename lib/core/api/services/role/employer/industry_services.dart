import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/industry_model.dart';

class IndustryServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<IndustryModel>> getIndustries() async {
    try {
      // ✅ Fixed: was /master-date/industries (typo), now /master-data/industries/
      final response = await _apiClient.get('/master-data/industries');

      dynamic data = response;
      if (response != null && response is Map && response.containsKey('data')) {
        data = response['data'];
      }

      if (data != null && data is List) {
        return data.map((e) => IndustryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('IndustryServices Error: $e');
      rethrow;
    }
  }
}
