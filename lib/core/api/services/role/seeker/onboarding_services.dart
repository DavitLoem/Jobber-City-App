import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';

class OnboardingServices {
  final ApiClient _apiClient = ApiClient();

  Future<void> completeOnboarding({
    required String provinceId,
    required String districtId,
    required List<String> categoryIds,
  }) async {
    try {
      final Map<String, dynamic> payload = {
        "province_id": provinceId,
        "district_id": districtId,
        "expertise_category_ids": categoryIds,
        "onboarding_completed": true,
      };

      await _apiClient.put('/seeker/profile/onboarding', data: payload);
    } catch (e) {
      debugPrint('Service Error complete onboarding: $e');
      rethrow;
    }
  }
}
