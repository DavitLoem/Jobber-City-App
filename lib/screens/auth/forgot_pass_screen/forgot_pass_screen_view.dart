import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/core/theme/app_assets.dart';
import 'package:jobber_city/core/utils/auth_validator.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';

part 'forgot_pass_screen_binding.dart';
part 'forgot_pass_screen_controller.dart';

class ForgotPassScreenView extends GetView<ForgotPassScreenViewController> {
  const ForgotPassScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Forgot Password".tr, // 🟢 Added .tr
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: theme.textTheme.bodyLarge?.color,
          ), // 🟢 Dynamic Icon
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: controller.fromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppAssets.imageForgotPass),

                const SizedBox(height: 20),

                const SizedBox(height: 15),

                CustomTextfield(
                  hintText: "Enter Email Address".tr, // 🟢 Added .tr
                  prefixIcon: Icons.email_outlined,
                  controller: controller.emailCtrl,
                  validator: AuthValidator.validateEmail,
                ),
                const SizedBox(height: 30),

                Text(
                  "Enter the email address associated with your account and we'll send you a verification code to reset your password."
                      .tr, // 🟢 Added .tr
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey, // 🟢 Dynamic Subtext
                    height: 1.5,
                  ),
                ),

                const Spacer(),

                Obx(
                  () => CustomButton(
                    onPressed: () {
                      controller.forgotPassword();
                    },
                    text: "Send Verification Code".tr, // 🟢 Added .tr
                    isLoading: controller.isLoading.value,
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
