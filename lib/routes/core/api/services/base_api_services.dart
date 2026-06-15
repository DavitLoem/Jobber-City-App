import 'package:dio/dio.dart';
import 'package:jobber_city/routes/core/api/api_config.dart';

class BaseApiServices {
  static final ApiConfig apiConfig = ApiConfig();

  // 🟢 Add "Options? options" to the parameters
  Future<dynamic> post({
    required String endpoint,
    required dynamic data,
    Options? options,
  }) async {
    try {
      final response = await apiConfig.dio.post(
        endpoint,
        data: data,
        options: options, // Pass it here
      );
      return response.data;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      rethrow;
    }
  }
}
