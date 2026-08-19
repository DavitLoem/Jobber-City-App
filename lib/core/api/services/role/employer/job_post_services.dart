import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/employer_job_model.dart';
import 'package:jobber_city/models/role/employer/job_post_model.dart';

class JobServices {
  final ApiClient _apiClient = ApiClient();

  /// POST /api/employer/jobs/
  Future<Map<String, dynamic>> postJob(JobPostModel model) async {
    try {
      final response = await _apiClient.post(
        '/employer/jobs/',
        data: model.toJson(),
      );

      debugPrint('✅ Job posted successfully: $response');
      return response as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Job post error: $e');
      rethrow;
    }
  }

  /// GET /api/employer/jobs/
  /// Returns the list of jobs posted by the authenticated employer.
  Future<List<EmployerJobModel>> getEmployerJobs() async {
    try {
      final response = await _apiClient.get('/employer/jobs/');

      if (response != null) {
        final List<dynamic> list = _extractList(response);
        return list
            .whereType<Map<String, dynamic>>()
            .map((json) => EmployerJobModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching employer jobs: $e');
      rethrow;
    }
  }

  List<dynamic> _extractList(dynamic response) {
    if (response is List) {
      return response;
    } else if (response is Map) {
      final keys = ['results', 'data', 'jobs', 'items', 'records', 'list'];
      for (final key in keys) {
        final value = response[key];
        if (value is List) {
          return value;
        }
      }
    }
    return <dynamic>[];
  }
}
