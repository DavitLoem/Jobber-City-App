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
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        foregroundColor:
            theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Appbar Text
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textTheme.bodyLarge?.color),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'OTP Code Verification'.tr, // 🟢 Added .tr
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  AppAssets.imageOtp,
                  fit: BoxFit.contain,
                  height: 180,
                ),
                const SizedBox(height: 30),
                Text(
                  "Check Your Email".tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "We have sent an OTP code to ".tr, // 🟢 Added .tr
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary, // 🟢 Dynamic Text
                      ),
                    ),
                    Text(
                      controller.maskedEmail.isNotEmpty
                          ? controller.maskedEmail
                          : "your email".tr, // 🟢 Added .tr
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimary, // 🟢 Dynamic Text
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // ប្រឡោះបញ្ចូលលេខកូដទាំង ៤ ខ្ទង់
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => _buildOtpTextField(
                      index,
                      isDark,
                    ), // 🟢 Passed Theme State
                  ),
                ),

                const SizedBox(height: 30),

                // ប៊ូតុងផ្ញើឡើងវិញ និងការបង្ហាញការរាប់ថយក្រោយ
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive code? ".tr, // 🟢 Added .tr
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ), // 🟢 Dynamic Text
                      ),
                      GestureDetector(
                        onTap: controller.remainingSeconds.value == 0
                            ? () => controller.resendOtp()
                            : null,
                        child: Text(
                          controller.remainingSeconds.value == 0
                              ? "Resend OTP"
                                    .tr // 🟢 Added .tr
                              : "Resend in @secs".trParams({
                                  'sec': controller.remainingSeconds.value
                                      .toString(),
                                }), // 🟢 Added .trParams
                          style: TextStyle(
                            color: controller.remainingSeconds.value == 0
                                ? (isDark
                                      ? Colors.blueAccent
                                      : AppColors
                                            .primary) // 🟢 Dynamic Resend Action Text
                                : (isDark
                                      ? AppColors.darkTextTertiary
                                      : Colors
                                            .grey), // 🟢 Dynamic Countdown Timer
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
                      // ប្រសិនបើមិនកំពុង Loading ទេ ទើបអនុញ្ញាតឱ្យហៅ verifyOtp()
                      if (!controller.isLoading.value) {
                        controller.verifyOtp();
                      }
                    },
                    text: controller.isLoading.value
                        ? "Verifying..."
                              .tr // 🟢 Added .tr
                        : "Verify & Proceed".tr, // 🟢 Added .tr
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget សម្រាប់ប្រឡោះ OTP នីមួយៗ
  Widget _buildOtpTextField(int index, bool isDark) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkInputBackground
              : AppColors.inputBackground, // 🟢 Dynamic Input BG
          border: Border.all(
            color: isDark
                ? AppColors.darkCardBorder
                : AppColors.buttonOutlineBorder, // 🟢 Dynamic Input Border
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.transparent
                  : AppColors.textTertiary.withValues(
                      alpha: 0.2,
                    ), // 🟢 Dynamic Shadow
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
                  ? Colors.white
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
