import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/location_model.dart';

class LocationServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<LocationModel>> getProvinces({String? search}) async {
    try {
      String url = '/locations/provinces';

      if (search != null && search.isNotEmpty) {
        url += '?search=$search';
      }

      final response = await _apiClient.get(url);

      if (response != null && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => LocationModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Service Error fetching provinces: $e');
      rethrow;
    }
  }

  Future<List<LocationModel>> getDistricts(
    String provinceId, {
    String? search,
  }) async {
    try {
      String url = '/locations/provinces/$provinceId/districts';

      if (search != null && search.isNotEmpty) {
        url += '?search=$search';
      }

      final response = await _apiClient.get(url);

      if (response != null && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => LocationModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Service Error fetching districts: $e');
      rethrow;
    }
  }
}
