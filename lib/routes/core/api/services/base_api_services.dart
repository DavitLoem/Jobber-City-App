import 'package:dio/dio.dart';
import 'package:jobber_city/routes/core/api/api_config.dart';

class BaseApiServices {
  static final ApiConfig apiConfig = ApiConfig();

  Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await apiConfig.dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      rethrow;
    }
  }
}
