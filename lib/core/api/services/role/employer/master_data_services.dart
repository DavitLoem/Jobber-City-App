import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/master_data_item.dart';

class MasterDataServices {
  final ApiClient _apiClient = ApiClient();

  List<MasterDataItem> _parse(dynamic response) {
    if (response == null) return [];
    final List<dynamic> list;
    if (response is List) {
      list = response;
    } else if (response is Map) {
      final keys = [
        'data',
        'results',
        'items',
        'records',
        'list',
        'education_levels',
        'job_levels',
        'work_types',
        'employment_types',
        'categories',
      ];
      List<dynamic>? found;
      for (final key in keys) {
        final value = response[key];
        if (value is List) {
          found = value;
          break;
        }
      }
      if (found != null) {
        list = found;
      } else {
        return [];
      }
    } else {
      return [];
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => MasterDataItem.fromJson(e))
        .toList();
  }

  // ១. ទាញយក Categories
  Future<List<MasterDataItem>> getCategories() async {
    try {
      final response = await _apiClient.get('/categories/');
      return _parse(response);
    } catch (e) {
      debugPrint('❌ Error fetching categories: $e');
      rethrow;
    }
  }

  // ២. ទាញយក Job Levels
  Future<List<MasterDataItem>> getJobLevels() async {
    try {
      final response = await _apiClient.get('/master-data/job-levels');
      return _parse(response);
    } catch (e) {
      debugPrint('❌ Error fetching job levels: $e');
      rethrow;
    }
  }

  // ៣. ទាញយក Work Types
  Future<List<MasterDataItem>> getWorkTypes() async {
    try {
      final response = await _apiClient.get('/master-data/work-types');
      return _parse(response);
    } catch (e) {
      debugPrint('❌ Error fetching work types: $e');
      rethrow;
    }
  }

  // ៤. ទាញយក Employment Types
  Future<List<MasterDataItem>> getEmploymentTypes() async {
    try {
      final response = await _apiClient.get('/master-data/employment-types');
      return _parse(response);
    } catch (e) {
      debugPrint('❌ Error fetching employment types: $e');
      rethrow;
    }
  }

  // ៥. ទាញយក Education Levels
  Future<List<MasterDataItem>> getEducationLevels() async {
    try {
      final response = await _apiClient.get('/master-data/education-levels');
      return _parse(response);
    } catch (e) {
      debugPrint('❌ Error fetching education levels: $e');
      rethrow;
    }
  }

  // ៦. ទាញយក Skills
  Future<List<MasterDataItem>> getSkills() async {
    try {
      final response = await _apiClient.get('/master-data/skills');
      return _parse(response);
    } catch (e) {
      debugPrint('❌ Error fetching skills: $e');
      rethrow;
    }
  }
}
