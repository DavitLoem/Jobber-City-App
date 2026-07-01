import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/utils/token_storage.dart';

import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final _authService = AuthServices();

  var isLoggedIn = false.obs;
  var userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // ពេល App បើកភ្លាម ឱ្យវាឆែកមើល Token ភ្លាម
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? token = await TokenStorage.getAccessToken();
    String? role = await TokenStorage.getUserRole();

    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      userRole.value = role ?? 'seeker';
      debugPrint("✅ Status: Login as ${userRole.value}");
    } else {
      isLoggedIn.value = false;
      userRole.value = '';
      debugPrint("❌ Status: Not Logged In");
    }
  }

  void _executeLogout() async {
    try {
      await _authService.logout();
      _clearStateAndLogout(
        "You have been logged out successfully.",
        "Logout Successful",
      );
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        _clearStateAndLogout(
          "Your session was already expired. Logged out.",
          "Session Expired",
        );
      } else {
        _clearStateAndLogout(
          "Logged out locally. Server issue: ${e.message}",
          "Notice",
        );
      }
    } catch (e) {
      _clearStateAndLogout(
        "You have been logged out locally.",
        "Offline Logout",
      );
    }
  }

  void _clearStateAndLogout(String message, String title) async {
    await TokenStorage.clearTokens();

    // Reset
    isLoggedIn.value = false;
    userRole.value = '';

    Get.offAllNamed(AppRoutes.login);
    Get.snackbar(title, message);
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // ប៊ូតុង OK (យល់ព្រម)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Get.back();
              _executeLogout();
            },
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
