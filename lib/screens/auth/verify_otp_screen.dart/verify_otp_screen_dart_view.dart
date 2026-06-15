import 'dart:async';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/routes/core/api/services/auth_services.dart';
import 'package:jobber_city/routes/core/constants/app_colors.dart';
import 'package:jobber_city/routes/core/theme/app_assets.dart';
import 'package:jobber_city/widgets/custom_button.dart';

part 'verify_otp_screen_dart_binding.dart';
part 'verify_otp_screen_dart_controller.dart';

class VerifyOtpScreenDartView
    extends GetView<VerifyOtpScreenDartViewController> {
  const VerifyOtpScreenDartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
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
                const Text(
                  "Check Your Email",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "We have sent an OTP code to ",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      controller.maskedEmail.isNotEmpty
                          ? controller.maskedEmail
                          : "your email",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
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
                    (index) => _buildOtpTextField(index),
                  ),
                ),

                const SizedBox(height: 30),

                // ប៊ូតុងផ្ញើឡើងវិញ និងការបង្ហាញការរាប់ថយក្រោយ
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive code? ",
                        style: TextStyle(color: AppColors.textSecondary),
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
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                const Spacer(),

                // ប៊ូតុង Submit សម្រាប់ផ្ទៀងផ្ទាត់
                // ស្វែងរកប្លុកកូដនេះ រួចជំនួសដោយកូដខាងក្រោម
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
                        : "Verify & Proceed",
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
  Widget _buildOtpTextField(int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          border: Border.all(color: AppColors.buttonOutlineBorder, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.textTertiary.withValues(alpha: 0.2),
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
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
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
