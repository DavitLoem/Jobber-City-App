import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'interceptors/dio_client.dart';

class ApiClient {
  // ទាញយក Single Instance របស់ DioClient មកប្រើ
  final Dio _dio = DioClient().dio;

  // --- GET ---
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- POST ---
  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PUT ---
  Future<dynamic> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PATCH ---
  Future<dynamic> patch(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.patch(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- DELETE ---
  Future<dynamic> delete(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ប្រព័ន្ធចាប់ Error រួម (Centralized Error Handler)
  // ==========================================
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException(
            "Internet connection is slow or disconnected. Please try again.",
          );

        case DioExceptionType.connectionError:
          return ApiException(
            "No internet connection. Please check your WiFi or mobile data.",
          );

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final data = error.response?.data;

          String serverMessage = "Server error (code: $statusCode)";

          // 🎯 បង្កើតអថេរសម្រាប់ត្រៀមចាប់យកកូដពី Backend
          String? serverErrorCode;
          String? serverExistingRole;

          if (data is Map<String, dynamic>) {
            // ១. ឆែកមើលទម្រង់ថ្មី (key: 'errors')
            if (data['errors'] != null && data['errors'] is List) {
              serverMessage = (data['errors'] as List)
                  .map((e) => e['message'].toString())
                  .join('\n');
            }
            // ២. ឆែកមើលទម្រង់ចាស់ (key: 'detail')
            else if (data['detail'] != null) {
              var detailData = data['detail'];
              if (detailData is String) {
                serverMessage = detailData;
              } else if (detailData is List) {
                serverMessage = detailData
                    .map((e) => e['msg'].toString())
                    .join('\n');
              }
              // 🎯 ៣. ទម្រង់ថ្មី (Map) សម្រាប់ចាប់យក Role Mismatch
              else if (detailData is Map<String, dynamic>) {
                serverMessage =
                    detailData['message']?.toString() ?? "Server error";
                serverErrorCode = detailData['error_code']?.toString();
                serverExistingRole = detailData['existing_role']?.toString();
              }
            }
            // ៤. ឆែកមើល key 'message' ខាងក្រៅ
            else if (data['message'] != null) {
              serverMessage = data['message'].toString();
            }
          }

          if (statusCode == 404) {
            bool hasServerMessage =
                data != null &&
                (data['detail'] != null ||
                    data['message'] != null ||
                    data['errors'] != null);

            return ApiException(
              hasServerMessage
                  ? serverMessage
                  : "We couldn't find the requested information.",
              statusCode: statusCode,
            );
          } else if (statusCode == 500) {
            return ApiException(
              "Server is currently experiencing issues (500). Please wait a moment.",
              statusCode: statusCode,
            );
          }

          // 🎯 បញ្ជូនទិន្នន័យទាំងអស់ចូលទៅ ApiException
          return ApiException(
            serverMessage,
            statusCode: statusCode,
            errorCode: serverErrorCode,
            existingRole: serverExistingRole,
          );

        case DioExceptionType.cancel:
          return ApiException("Operation was cancelled.");

        default:
          return ApiException("An unknown error occurred.");
      }
    } else {
      // ករណី Error កើតចេញពីកូដ Flutter ផ្ទាល់ (មិនមែនមកពី API)
      return ApiException("System error: ${error.toString()}");
    }
  }
}
