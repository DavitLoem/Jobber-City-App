import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/category_model.dart';

class CategoryServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.get('/categories/');

      if (response != null) {
        if (response is List) {
          return response.map((json) => CategoryModel.fromJson(json)).toList();
        } else if (response is Map && response['data'] is List) {
          return (response['data'] as List)
              .map((json) => CategoryModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Service Error fetching categories: $e');
      rethrow;
    }
  }
}
