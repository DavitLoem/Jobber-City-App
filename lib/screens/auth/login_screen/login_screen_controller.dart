part of 'login_screen_view.dart';

class LoginScreenViewController extends GetxController {
  final AuthServices authServices = AuthServices();

  late TextEditingController emailCtrl;
  late TextEditingController passwordCtrl;

  var rememberMe = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  // Clear input fields manually
  void clearFields() {
    emailCtrl.clear();
    passwordCtrl.clear();
  }

  void toggleRememberMe([bool? value]) {
    rememberMe.value = value ?? !rememberMe.value;
  }

  void login() async {
    // 1. Validate user input
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;
    try {
      // 2. Call Auth API Service
      var response = await authServices.login(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      // DEBUG PRINT
      print("=================== BACKEND RESPONSE ===================");
      print("Response content: $response");
      print("========================================================");

      // 3. Normalize Response into a Map
      Map<String, dynamic> responseMap = {};
      if (response is Map) {
        responseMap = Map<String, dynamic>.from(response);
      }

      String? accessToken;
      String? refreshToken;
      String? message;
      bool isSuccess = false;

      // Extract tokens from data layer
      if (responseMap["data"] is Map) {
        var dataMap = responseMap["data"];
        accessToken = (dataMap["access_token"] ?? dataMap["token"])?.toString();
        refreshToken = dataMap["refresh_token"]?.toString();
        isSuccess = responseMap["success"] == true || accessToken != null;
      } else if (responseMap.containsKey("access_token")) {
        accessToken = responseMap["access_token"]?.toString();
        refreshToken = responseMap["refresh_token"]?.toString();
        isSuccess = true;
      }

      // 🟢 FIX: Extract success message carefully from response root
      if (responseMap["message"] != null) {
        message = responseMap["message"].toString();
      }

      // 4. Handle Navigation or fallback error
      if (isSuccess || accessToken != null) {
        if (accessToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', accessToken);
          if (refreshToken != null) {
            await prefs.setString('refresh_token', refreshToken);
          }
        }

        // Display the clean success message from the backend ("Login successful")
        Get.snackbar('Success', message ?? 'Login Successfully');

        clearFields();
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          'Error',
          message ?? "Invalid response format or authentication failed.",
        );
      }
    } catch (e, stacktrace) {
      print("❌ Login Runtime Crash Log: $e");
      print("❌ Stacktrace: $stacktrace");

      if (e is DioException) {
        dynamic errorData = e.response?.data;
        String errorMessage = "Login failed. Please check your credentials.";

        // 🟢 FIX: Parse nested error structures or array-lists from FastAPI (422 Content)
        if (errorData is Map) {
          if (errorData["message"] != null) {
            errorMessage = errorData["message"].toString();
          } else if (errorData["detail"] != null) {
            var detail = errorData["detail"];

            // Checking if FastAPI returned an array error list
            if (detail is List && detail.isNotEmpty) {
              var firstError = detail[0];
              if (firstError is Map && firstError["msg"] != null) {
                // Grabs clean error string like: "String should have at least 8 characters"
                errorMessage = firstError["msg"].toString();
              }
            } else {
              errorMessage = detail.toString();
            }
          }
        }
        Get.snackbar('Error', errorMessage);
      } else {
        Get.snackbar('Error', 'An unexpected error occurred: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
