import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/employer_dashboard_model.dart';

class EmployerDashboardService {
  final ApiClient _apiClient = ApiClient();

  Future<EmployerDashboardResponse?> getDashboardOverview({
    String filter = 'this_month',
  }) async {
    try {
      // ហៅ API (សូមប្រាកដថា Path ត្រូវនឹង Base URL របស់អ្នក)
      final response = await _apiClient.get(
        '/employer/dashboard/overview',
        queryParameters: {'filter': filter},
      );

      // ឆែកមើលបើ response មិន null ហើយមានផ្ទុក key "data"
      if (response != null && response['data'] != null) {
        // ទាញយក Map 'data' ចេញពី JSON ដើម យកមកបំប្លែងជា Object
        final dataMap = response['data'] as Map<String, dynamic>;
        return EmployerDashboardResponse.fromJson(dataMap);
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error fetching dashboard overview: $e');
      rethrow;
    }
  }
}
