import 'package:jobber_city/routes/core/api/services/base_api_services.dart';
import 'package:dio/dio.dart';
import 'base_api_services.dart';

class AuthServices {
  static final BaseApiServices baseApi = BaseApiServices();

  Future<dynamic> register({
    required String role, // ត្រូវប្រាកដថាបញ្ជូន 'seeker' ឬ 'employer'
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    var response = await baseApi.post(
      endpoint: '/api/auth/register',
      data: {
        'role': role,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      },
    );

    return response;
  }

  // 🟢 FIXED: Match JSON format and keys with your FastAPI OpenAPI spec
  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    var response = await baseApi.post(
      endpoint: '/api/auth/login',
      data: {
        'email': email, // Changed from 'username' to 'email' to match API Docs
        'password': password, // Matches 'password'
      },
      // Removed formUrlEncodedContentType option so it defaults to application/json
    );

    return response;
  }

  Future<dynamic> verifyOtp({
    required String email,
    required String otp,
  }) async {
    var response = await baseApi.post(
      endpoint: '/api/auth/verify-otp',
      data: {
        'email': email,
        'otp_code': otp, // បញ្ជូនទៅតាមតម្រូវការរបស់ Backend API
      },
    );

    return response;
  }

  Future<dynamic> resendOtp({required String email}) async {
    var response = await baseApi.post(
      endpoint: '/api/auth/resend-otp',
      data: {'email': email},
    );

    return response;
  }

  Future<dynamic> forgotPassword({required String email}) async {
    var response = await baseApi.post(
      endpoint: '/api/auth/forgot-password',
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
    var response = await baseApi.post(
      endpoint: "/api/auth/reset-password",
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
