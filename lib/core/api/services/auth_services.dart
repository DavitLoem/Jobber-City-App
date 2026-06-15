import 'package:jobber_city/core/api/network/api_client.dart';

import '../../../models/auth_model/register_request_model.dart';

class AuthServices {
final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> register(RegisterRequestModel requestModel) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: requestModel.toJson(),
      );

      return response ?? {};
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    var response = await _apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    return response;
  }

  Future<dynamic> verifyOtp({
    required String email,
    required String otp,
  }) async {
    var response = await _apiClient.post(
      '/auth/verify-otp',
      data: {
        'email': email,
        'otp_code': otp, // បញ្ជូនទៅតាមតម្រូវការរបស់ Backend API
      },
    );

    return response;
  }

  Future<dynamic> resendOtp({required String email}) async {
    var response = await _apiClient.post(
      '/auth/resend-otp',
      data: {'email': email},
    );

    return response;
  }

  Future<dynamic> forgotPassword({required String email}) async {
    var response = await _apiClient.post(
      '/auth/forgot-password',
      data: {'email': email},
    );

    return response;
  }

  Future<dynamic> resetPassword({
    required String email,
    required String otp,
    required String newpassword,
    required String confirmpassword,
  }) async {
    var response = await _apiClient.post(
      '/auth/reset-password',
      data: {
        "email": email,
        "otp_code": otp,
        "new_password": newpassword,
        "confirm_password": confirmpassword,
      },
    );
    return response;
  }
}
