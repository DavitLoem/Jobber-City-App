import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/theme/app_assets.dart';
import 'package:jobber_city/core/utils/auth_validator.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/widgets/custom_button.dart';

import '../../../controllers/auth_controller.dart';

part 'verify_otp_binding.dart';
part 'verify_otp_controller.dart';

class VerifyOtpView extends GetView<VerifyOtpController> {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        foregroundColor:
            theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Appbar Text/Icon
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'OTP Code Verification',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                AppAssets.imageOtp,
                fit: BoxFit.cover,
                height: 350,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "Check Your Email",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme
                              .textTheme
                              .bodyLarge
                              ?.color, // 🟢 Dynamic Title
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "We have sent an OTP code to ",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors
                                        .textSecondary, // 🟢 Dynamic Subtitle
                            ),
                          ),
                          Text(
                            controller.maskedEmail.isNotEmpty
                                ? controller.maskedEmail
                                : "your email",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme
                                  .textTheme
                                  .bodyLarge
                                  ?.color, // 🟢 Dynamic Highlight
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => _buildOtpTextField(
                            index,
                            isDark,
                          ), // 🟢 Passed Context (isDark)
                        ),
                      ),

                      const SizedBox(height: 30),

                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive code? ",
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors
                                          .textSecondary, // 🟢 Dynamic Subtext
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.remainingSeconds.value == 0
                                  ? () => controller.resendOtp()
                                  : null,
                              child: Text(
                                controller.remainingSeconds.value == 0
                                    ? "Resend OTP"
                                    : "Resend in ${controller.remainingSeconds.value}s",
                                style: TextStyle(
                                  color: controller.remainingSeconds.value == 0
                                      ? AppColors.primary
                                      : (isDark
                                            ? AppColors.darkTextHint
                                            : Colors
                                                  .grey), // 🟢 Dynamic Hint Text
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      const Spacer(),

                      Obx(() {
                        return CustomButton(
                          onPressed: () {
                            if (!controller.isLoading.value) {
                              controller.verifyOtp();
                            }
                          },
                          text: controller.isLoading.value
                              ? "Verifying..."
                              : "Verify & Proceed",
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpTextField(int index, bool isDark) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkInputBackground
              : AppColors.inputBackground, // 🟢 Dynamic BG
          border: Border.all(
            color: isDark
                ? AppColors.darkCardBorder
                : AppColors.buttonOutlineBorder, // 🟢 Dynamic Border
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isDark ? 0.2 : 0.05,
              ), // 🟢 Adjusted shadow
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: TextField(
            controller: controller.controllers[index],
            focusNode: controller.focusNodes[index],
            onChanged: (value) {
              if (value.length == 1 && index < 3) {
                controller.focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && index > 0) {
                controller.focusNodes[index - 1].requestFocus();
              }
            },
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkInputText
                  : AppColors.textPrimary, // 🟢 Dynamic Input Text
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
      ),
    );
  }
}
