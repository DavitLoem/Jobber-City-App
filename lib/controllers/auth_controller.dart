import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/api/services/chat/chat_ws_service.dart';
import 'package:jobber_city/core/utils/token_storage.dart';

import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final _authService = AuthServices();

  var isLoggedIn = false.obs;
  var userRole = ''.obs;
  var isProfileCompleted = false.obs;
  var isOnboardingCompleted = false.obs;
  var isGoogleLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? token = await TokenStorage.getAccessToken();
    String? role = await TokenStorage.getUserRole();
    bool onboarding = await TokenStorage.getOnboardingStatus();
    bool profileCompleted = await TokenStorage.getProfileCompletedStatus();

    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      userRole.value = role ?? 'seeker';
      isOnboardingCompleted.value = onboarding;
      isProfileCompleted.value = profileCompleted;
      Get.find<ChatWsService>().connect(token);
      debugPrint("✅ Status: Login as ${userRole.value}");
    } else {
      isLoggedIn.value = false;
      userRole.value = '';
      isOnboardingCompleted.value = false;
      isProfileCompleted.value = false;
      // debugPrint("❌ Status: Not Logged In");
    }
  }

  Future<void> loginWithGoogle({String? role}) async {
    try {
      isGoogleLoading.value = true;
      var response = await _authService.loginWithGoogle(role);
      var token = response.accessToken;

      await TokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        role: response.user.role,
        isProfileCompleted: response.user.isProfileCompleted,
        onboardingCompleted: response.user.onboardingCompleted,
      );

      await TokenStorage.saveUserId(response.user.id);

      Get.find<ChatWsService>().connect(token);

      isLoggedIn.value = true;
      userRole.value = response.user.role;
      isOnboardingCompleted.value = response.user.onboardingCompleted;
      isProfileCompleted.value = response.user.isProfileCompleted;

      Get.snackbar(
        "Success",
        "Login Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      _navigateBasedOnStatus();
    } on ApiException catch (e) {
      // 🎯 ចាប់ Error ខុស Role
      if (e.errorCode == 'ROLE_MISMATCH' && e.existingRole != null) {
        _showRoleMismatchDialog(e.existingRole!);
      }
      // 🎯 ចាប់ Error អត់មានគណនី (មកពី Login Screen)
      else if (e.errorCode == 'ACCOUNT_NOT_FOUND') {
        _showAccountNotFoundDialog();
      } else {
        Get.snackbar(
          "Failed",
          e.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not login with Google",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void _showAccountNotFoundDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.person_add_disabled, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              'Account Not Found',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'This Google email is not registered in our system. Please register first.',
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoutes.createAccount); // រត់ទៅទំព័រ Register
            },
            child: const Text(
              'Go to Register Page',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showRoleMismatchDialog(String existingRole) {
    String roleName = existingRole == 'seeker'
        ? 'Job Seeker (Seeker)'
        : 'Employer (Employer)';

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blueAccent),
            SizedBox(width: 8),
            Text(
              'Account Already Exists',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'This Google account is already registered as $roleName. Do you want to sign in using the $existingRole account?',
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Get.back(); // close dialog
              loginWithGoogle(role: existingRole); // retry login
            },
            child: const Text(
              'Proceed to Sign In',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _navigateBasedOnStatus() {
    if (userRole.value == 'seeker') {
      // កែប្រែ៖ ប្រសិនបើបញ្ចប់ Onboarding ពិតមែន (true) ឱ្យទៅ Main Screen
      if (isOnboardingCompleted.value) {
        Get.offAllNamed(AppRoutes.mainScreenSeeker);
      } else {
        // បើមិនទាន់បញ្ចប់ (false) ឱ្យទៅចាប់ផ្តើមពី Location មុន
        Get.offAllNamed(AppRoutes.location);
      }
    } else if (userRole.value == 'employer') {
      // កែប្រែ៖ ធ្វើឱ្យស្របគ្នាជាមួយ Employer ដែរ
      if (isProfileCompleted.value) {
        Get.offAllNamed(AppRoutes.mainScreenEmployer);
      } else {
        Get.offAllNamed(AppRoutes.companyProfile);
      }
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

    // 🎯 បន្ថែមបន្ទាត់នេះ៖ បិទ WebSocket ចាស់ចោលរាល់ពេល Logout
    try {
      Get.find<ChatWsService>().disconnect();
    } catch (e) {
      debugPrint("WebSocket disconnect error: $e");
    }

    isLoggedIn.value = false;
    userRole.value = '';
    isOnboardingCompleted.value = false;
    isProfileCompleted.value = false;

    Get.offAllNamed(AppRoutes.login);
    Get.snackbar(title, message);
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
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
