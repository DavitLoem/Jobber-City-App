import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  // បង្កើត instance នៃ FlutterSecureStorage
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserRole = 'user_role';
  static const String _profileCompletedKey = 'profile_completed_status';
  static const String _onboardingKey = 'onboarding_status';
  static const _keyUserId = 'user_id';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String role,
    required bool isProfileCompleted,
    required bool onboardingCompleted,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keyUserRole, value: role);
    await _storage.write(
      key: _profileCompletedKey,
      value: isProfileCompleted.toString(),
    );
    await _storage.write(
      key: _onboardingKey,
      value: onboardingCompleted.toString(),
    );
  }

  static Future<bool> getProfileCompletedStatus() async {
    String? status = await _storage.read(key: _profileCompletedKey);
    return status == 'true';
  }

  static Future<bool> getOnboardingStatus() async {
    String? status = await _storage.read(key: _onboardingKey);
    return status ==
        'true'; // បើ 'true' វានឹង return true, បើ null វានឹង return false
  }

  /// ទាញយក Access Token មកប្រើ (សម្រាប់ដាក់ក្នុង API Header)
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// ទាញយក Refresh Token មកប្រើ (សម្រាប់ហៅ API សុំ Access Token ថ្មី)
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _keyUserRole);
  }

  /// លុប Token ទាំងអស់ចោល (ប្រើនៅពេល Logout ឬពេល Refresh Token ផុតកំណត់ដែរ)
  static Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserRole);
    await _storage.delete(key: _profileCompletedKey);
    await _storage.delete(key: _onboardingKey);
  }

  static Future<void> saveUserId(String id) async {
    await _storage.write(key: _keyUserId, value: id);
  }

  // 🎯 មុខងារទាញយក User ID មកប្រើ
  static Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  // 🎯 គួរលុបចោលវិញពេល Logout
  static Future<void> deleteUserId() async {
    await _storage.delete(key: _keyUserId);
  }
}
