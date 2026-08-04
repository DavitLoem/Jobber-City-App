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
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      debugPrint("⚠️ [AuthInterceptor] Warning: Token is missing or empty!");
    }

    return handler.next(options);
  }

  // ២. ដំណើរការនៅពេលមាន Error ត្រឡប់ពី Server មកវិញ
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isAuthRoute =
        err.requestOptions.path.contains('/auth/login') ||
        err.requestOptions.path.contains('/auth/register');

    if (err.response?.statusCode != 401 || isAuthRoute) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;
    final refreshToken = await TokenStorage.getRefreshToken();

    // 🎯 ចំណុចកែប្រែទី១៖
    // បើគ្មាន Refresh Token ទេ មានន័យថាអ្នកប្រើមិនទាន់ Login តាំងពីដំបូងមកម្ល៉េះ។
    // ដូច្នេះ យើងមិនបាច់ហៅ _performLogout() ដើម្បីបង្ខំឱ្យលោតទៅ /login ទេ។
    // យើងគ្រាន់តែបោះ Error ទៅកាន់ Controller វិញ (អម្បាញ់មិញយើងបានដាក់ try-catch ការពារក្នុង Controller រួចហើយ)។
    if (refreshToken == null) {
      _isRefreshing = false;
      return handler.next(err);
    }

    try {
      final refreshDio = Dio();
      final response = await refreshDio.post(
        '${ApiConfig.baseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final responseData = response.data['data'] ?? response.data;

      final newAccessToken = responseData['access_token'];
      final newRefreshToken = responseData['refresh_token'];

      final oldRole = await TokenStorage.getUserRole() ?? 'seeker';
      final oldOnboardingStatus = await TokenStorage.getOnboardingStatus();
      final oldProfileStatus = await TokenStorage.getProfileCompletedStatus();

      await TokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken ?? refreshToken,
        role: responseData['role'] ?? oldRole,
        onboardingCompleted:
            responseData['onboarding_completed'] ?? oldOnboardingStatus,
        isProfileCompleted:
            responseData['is_profile_completed'] ?? oldProfileStatus,
      );

      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final cloneRequest = await dio.fetch(err.requestOptions);

      _isRefreshing = false;
      return handler.resolve(cloneRequest);
    } catch (e) {
      debugPrint("❌ Error calling refresh token API: $e");

      _isRefreshing = false;
      _performLogout();
      return handler.next(err);
    }
  }

  // 🎯 ចំណុចកែប្រែទី២៖
  // ការពារបន្ថែម កុំឱ្យលោតទៅទំព័រ Login ជាន់គ្នា បើកំពុងនៅទំព័រ Login ស្រាប់
  void _performLogout() async {
    await TokenStorage.clearTokens();

    // បើមិនទាន់នៅទំព័រ Login ទេ ទើបបញ្ជាឱ្យលោតទៅ
    if (Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed(AppRoutes.login);
      debugPrint("Session Expired. Logged out automatically.");
    }
  }
}
