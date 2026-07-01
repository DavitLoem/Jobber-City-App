import 'package:flutter/foundation.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/district_model.dart';

class DistrictServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<DistrictModel>> getDistricts(String provinceId) async {
    try {
      final response = await _apiClient.get(
        '/locations/provinces/$provinceId/districts',
      );

      if (response != null && response is Map && response['data'] != null) {
        return (response['data'] as List)
            .map((json) => DistrictModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching districts: $e');
      return [];
    }
  }
}
