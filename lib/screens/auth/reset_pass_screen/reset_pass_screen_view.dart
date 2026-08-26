import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/theme/app_assets.dart';
import 'package:jobber_city/models/auth_model/reset_password_request_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_view.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';

part 'reset_pass_screen_binding.dart';
part 'reset_pass_screen_controller.dart';

class ResetPassScreenView extends GetView<ResetPassScreenViewController> {
  const ResetPassScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        iconTheme: IconThemeData(
          color: theme.textTheme.bodyLarge?.color,
        ), // 🟢 Dynamic Icon
        title: Text(
          "Reset Password".tr, // 🟢 Added .tr
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppAssets.imageResetPass),
              Text(
                "Create New Password".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your new password must be different from previous used passwords."
                    .tr, // 🟢 Added .tr
                style: TextStyle(
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey, // 🟢 Dynamic Subtext
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // New Password Field
              CustomTextfield(
                hintText: "New Password".tr, // 🟢 Added .tr
                controller: controller.newPasswordCtrl,
                prefixIcon: Icons.lock,
                isPasswordField: true,
              ),

              const SizedBox(height: 16),

              // Confirm Password Field
              CustomTextfield(
                hintText: "Confirm New Password".tr, // 🟢 Added .tr
                controller: controller.confirmPasswordCtrl,
                prefixIcon: Icons.lock,
                isPasswordField: true,
              ),

              const Spacer(),

              // Submit Button
              Obx(() {
                return CustomButton(
                  onPressed: () {
                    // Prevent multiple clicks while loading
                    if (!controller.isLoading.value) {
                      controller.resetPassword();
                    }
                  },
                  text: controller.isLoading.value
                      ? "Resetting..."
                            .tr // 🟢 Added .tr
                      : "Reset Password".tr, // 🟢 Added .tr
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
