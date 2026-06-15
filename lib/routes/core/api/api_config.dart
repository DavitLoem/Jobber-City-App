import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  late Dio dio;

  ApiConfig() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2:8000",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 🟢 ADD DIO INTERCEPTOR
    dio.interceptors.add(
      InterceptorsWrapper(
        // 1. Attach Access Token before sending ANY request
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        // 2. Catch 401 errors and try to Refresh Token
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            bool refreshed = await _refreshToken();

            if (refreshed) {
              // If refresh succeeded, attach the NEW token and retry the failed request
              final prefs = await SharedPreferences.getInstance();
              final newToken = prefs.getString('access_token');
              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';

              try {
                // Retry the original request
                final cloneReq = await dio.fetch(e.requestOptions);
                return handler.resolve(cloneReq);
              } catch (e2) {
                return handler.next(e);
              }
            }
          }
          return handler.next(e); // Pass error if refresh fails
        },
      ),
    );
  }

  // 🟢 Refresh Token Logic
  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      if (refreshToken == null) return false;

      // Use a new Dio instance so we don't trigger the interceptor again
      var refreshDio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000"));

      // Update this endpoint to match your FastAPI refresh route
      var response = await refreshDio.post(
        "/api/auth/refresh",
        data: {"refresh_token": refreshToken},
      );

      if (response.statusCode == 200) {
        // Save the new tokens
        await prefs.setString('access_token', response.data['access_token']);
        if (response.data['refresh_token'] != null) {
          await prefs.setString(
            'refresh_token',
            response.data['refresh_token'],
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      // If refresh fails (e.g., refresh token expired), you should probably force logout
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return false;
    }
  }
}
