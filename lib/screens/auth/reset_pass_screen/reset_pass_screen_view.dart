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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppAssets.imageResetPass),
              const Text(
                "Create New Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your new password must be different from previous used passwords.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // New Password Field
              CustomTextfield(
                hintText: "New Password",
                controller: controller.newPasswordCtrl,
                prefixIcon: Icons.lock,
                isPasswordField: true,
              ),

              const SizedBox(height: 16),

              // Confirm Password Field
              CustomTextfield(
                hintText: "Confirm New Password",
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
                      : "Reset Password",
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
