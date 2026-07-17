import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/auth_model/auth_response_model.dart';
import 'package:jobber_city/models/auth_model/register_model.dart';
import 'package:jobber_city/models/auth_model/reset_password_request_model.dart';

class AuthServices {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> register(
    RegisterRequestModel requestModel,
  ) async {
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

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      // Parse the response into a model for type safety
      return AuthResponseModel.fromJson(response['data'] ?? response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponseModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      var response = await _apiClient.post(
        '/auth/verify-otp',
        data: {'email': email, 'otp_code': otp},
      );
      return AuthResponseModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> resendOtp({required String email}) async {
    try {
      var response = await _apiClient.post(
        '/auth/resend-otp',
        data: {'email': email},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> forgotPassword({required String email}) async {
    try {
      var response = await _apiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> resetPassword(ResetPasswordRequestModel data) async {
    try {
      var response = await _apiClient.post(
        '/auth/reset-password',
        data: data.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> logout() async {
    try {
      String? refreshToken = await TokenStorage.getRefreshToken();
      var response = await _apiClient.post(
        '/auth/logout',
        data: {'refresh_token': refreshToken ?? " "},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponseModel> loginWithGoogle(String role) async {
    try {
      final webClientId = dotenv.env['WEB_CLIENT_ID'];

      // ទាញយក Instance ជំនួសឱ្យការបង្កើត Object ថ្មី
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      // ធ្វើការ Initialize ដោយបញ្ចូល serverClientId នៅទីនេះ
      await googleSignIn.initialize(serverClientId: webClientId);

      await googleSignIn.signOut();

      // មុខងារនេះនឹងបង្ហាញ UI ឱ្យ User Login
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // ទាញយក idToken
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) throw Exception("ID Token is null");

      var response = await _apiClient.post(
        '/auth/google-login',
        data: {'id_token': idToken, 'role': role},
      );

      return AuthResponseModel.fromJson(response['data'] ?? response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getRawProfile() async {
    try {
      // បាញ់ API ទៅយកទិន្នន័យ (ApiClient នឹងញាត់ Token ចូលដោយស្វ័យប្រវត្តិ)
      var response = await _apiClient.get('/seeker/profile/');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
