import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/config/api_config.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/routes/app_routes.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;

  AuthInterceptor(this.dio);

  // ១. ដំណើរការមុនពេល Request ត្រូវបានបញ្ជូនទៅកាន់ Server
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await TokenStorage.getAccessToken();

    // បើមាន Token, ភ្ជាប់វាទៅក្នុង Header ជានិច្ច
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options); // អនុញ្ញាតឱ្យ Request បន្តដំណើរទៅមុខ
  }

  // ២. ដំណើរការនៅពេលមាន Error ត្រឡប់ពី Server មកវិញ
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // បើ Error មិនមែន 401 (Unauthorized) ទេ, បោះ Error ទៅធម្មតា
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // បើកំពុង Refresh រួចហើយ, បដិសេធ Request ថ្មីៗសិន ការពារកុំឱ្យជាន់គ្នា
    if (_isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;
    final refreshToken = await TokenStorage.getRefreshToken();

    // បើគ្មាន Refresh Token ទេ មានន័យថាអ្នកប្រើមិនទាន់ Login ឬ Logout រួចហើយ
    if (refreshToken == null) {
      _isRefreshing = false;
      _performLogout();
      return handler.next(err);
    }

    try {
      // ប្រើប្រាស់ Dio ថ្មីមួយទៀត (មិនមែន dio ចាស់) ដើម្បីហៅ API Refresh Token
      // ការពារកុំឱ្យវាចូលមកក្នុង Interceptor នេះម្តងទៀត (Infinite Loop)
      final refreshDio = Dio();
      final response = await refreshDio.post(
        '${ApiConfig.baseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      // ទាញយក Token ថ្មី ហើយរក្សាទុក
      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await TokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        role: response.data['role'],
      );

      // ធ្វើបច្ចុប្បន្នភាព Request ចាស់ដែលបាន Fail នោះ ជាមួយនឹង Token ថ្មី
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      // បាញ់ Request ចាស់នោះម្តងទៀត (Retry)
      final cloneRequest = await dio.fetch(err.requestOptions);

      _isRefreshing = false;
      return handler.resolve(
        cloneRequest,
      ); // បញ្ជូនលទ្ធផលជោគជ័យត្រឡប់ទៅ UI វិញ (អ្នកប្រើមិនដឹងខ្លួនថាមាន Error ទេ)
    } catch (e) {
      // ប្រសិនបើការហៅ Refresh Token ទទួលបរាជ័យ (ឧទាហរណ៍: Refresh Token ក៏ផុតកំណត់ដែរ)
      _isRefreshing = false;
      _performLogout();
      return handler.next(err);
    }
  }

  void _performLogout() async {
    await TokenStorage.clearTokens();
    Get.offAllNamed(AppRoutes.login);
    debugPrint("Session Expired. Logged out automatically.");
  }
}
