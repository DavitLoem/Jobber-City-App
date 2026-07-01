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
    // បង្កើតលក្ខខណ្ឌឆែកមើលថាតើកំពុងបាញ់ API Login ឬ Register ដែរឬទេ?
    final isAuthRoute =
        err.requestOptions.path.contains('/auth/login') ||
        err.requestOptions.path.contains('/auth/register');

    // បើ Error មិនមែន 401 (Unauthorized) ទេ, បោះ Error ទៅធម្មតា
    if (err.response?.statusCode != 401 || isAuthRoute) {
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
      final refreshDio = Dio();
      final response = await refreshDio.post(
        '${ApiConfig.baseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      // ១. ឆែកមើលក្រែងលោ Backend ខ្ចប់ទិន្នន័យក្នុង key "data"
      // (បើអត់មាន key "data" ទេ យើងយក response.data ធម្មតា)
      final responseData = response.data['data'] ?? response.data;

      final newAccessToken = responseData['access_token'];
      final newRefreshToken = responseData['refresh_token'];

      // ២. ទាញយក Role ចាស់មកប្រើវិញ ការពារកុំឱ្យ Error ដោយសារ API មិនបោះ Role ថ្មីមក
      final oldRole = await TokenStorage.getUserRole() ?? 'seeker';

      // ៣. រក្សាទុក Token ថ្មី
      await TokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken:
            newRefreshToken ??
            refreshToken, // បើ API អត់បោះ Refresh ថ្មីមកទេ ប្រើអាចាស់សិន
        role: responseData['role'] ?? oldRole,
      );

      // ៤. ធ្វើបច្ចុប្បន្នភាព Request ចាស់ដែលបាន Fail នោះ ជាមួយនឹង Token ថ្មី
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      // ៥. បាញ់ Request ចាស់នោះម្តងទៀត (Retry)
      final cloneRequest = await dio.fetch(err.requestOptions);

      _isRefreshing = false;
      return handler.resolve(cloneRequest);
    } catch (e) {
      // 6. Most important point: print this error to know exactly why refresh failed
      debugPrint("❌ Error calling refresh token API: $e");

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
