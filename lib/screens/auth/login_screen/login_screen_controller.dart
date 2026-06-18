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

  void clearFields() {
    emailCtrl.clear();
    passwordCtrl.clear();
  }

  void toggleRememberMe([bool? value]) {
    rememberMe.value = value ?? !rememberMe.value;
  }

  void login() async {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;
    try {
      var response = await authServices.login(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      print("=================== BACKEND RESPONSE ===================");
      print("Response content: $response");
      print("========================================================");

      Map<String, dynamic> responseMap = {};
      if (response is Map) {
        responseMap = Map<String, dynamic>.from(response);
      }

      String? accessToken;
      String? refreshToken;
      String? message;
      bool isSuccess = false;

      // 🟢 កែសម្រួលត្រង់នេះ៖ រក្សារចនាសម្ព័ន្ធទាញយក Token ដើមរបស់អ្នក ដើម្បីកុំឱ្យបាត់បង់ទិន្នន័យពី "data"
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

      if (responseMap["message"] != null) {
        message = responseMap["message"].toString();
      }

      if (isSuccess || accessToken != null) {
        // 🟢 រក្សាទុកចូលទៅក្នុង TokenStorage ឱ្យបានត្រឹមត្រូវសម្រាប់ការហៅ API បន្ទាប់
        if (accessToken != null) {
          await TokenStorage.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken ?? '',
          );
        }

        Get.snackbar('Success', message ?? 'Login Successfully');
        clearFields();

        // ធ្វើដំណើរទៅកាន់ទំព័រ Categories
        Get.offAllNamed(AppRoutes.location);
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

        if (errorData is Map) {
          if (errorData["message"] != null) {
            errorMessage = errorData["message"].toString();
          } else if (errorData["detail"] != null) {
            var detail = errorData["detail"];
            if (detail is List && detail.isNotEmpty) {
              var firstError = detail[0];
              if (firstError is Map && firstError["msg"] != null) {
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
