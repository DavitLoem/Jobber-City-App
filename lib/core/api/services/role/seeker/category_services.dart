import 'package:flutter/foundation.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/category_model.dart';

class CategoryServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<CategoryModel>> getCategories({String? search}) async {
    try {
      String url = '/categories/';

      if (search != null && search.isNotEmpty) {
        url += '?search=$search';
      }

      final response = await _apiClient.get(url);

      if (response != null && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Service Error fetching categories: $e');
      rethrow;
    }
  }
}
