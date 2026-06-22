import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/utils/token_storage.dart';

import '../routes/app_routes.dart';

class AuthController {
  final _authService = AuthServices();

  void _executeLogout() async {
    try {
      await _authService.logout();

      await TokenStorage.clearTokens();
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(
        "Logout Successful",
        "You have been logged out successfully.",
      );
    } on ApiException catch (e) {
      await TokenStorage.clearTokens();
      Get.offAllNamed(AppRoutes.login);

      if (e.statusCode == 401) {
        Get.snackbar(
          "Session Expired",
          "Your session was already expired. Logged out.",
        );
      } else {
        Get.snackbar(
          "Notice",
          "Logged out locally. Server issue: ${e.message}",
        );
      }
    } catch (e) {
      await TokenStorage.clearTokens();

      Get.offAllNamed(AppRoutes.login);

      Get.snackbar("Offline Logout", "You have been logged out locally.");
    }
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
