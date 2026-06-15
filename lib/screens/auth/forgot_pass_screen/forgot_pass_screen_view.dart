import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/theme/app_assets.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';

part 'forgot_pass_screen_binding.dart';
part 'forgot_pass_screen_controller.dart';

class ForgotPassScreenView extends GetView<ForgotPassScreenViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Forgot Password",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppAssets.imageForgotPass),

              const SizedBox(height: 20),

              const SizedBox(height: 15),

              CustomTextfield(
                hintText: "Enter Email Address",
                prefixIcon: Icons.email_outlined,
                controller: controller.emailCtrl,
              ),
              const SizedBox(height: 30),

              const Text(
                "Enter the email address associated with your account and we'll send you a verification code to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
              ),

              const Spacer(),

              CustomButton(
                onPressed: () {
                  controller.forgotPassword();
                },
                text: "Send Verification Code",
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
