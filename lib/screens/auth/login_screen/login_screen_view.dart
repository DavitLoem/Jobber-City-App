import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/theme/app_assets.dart';
import 'package:jobber_city/core/utils/auth_validator.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/auth/widget/logo.dart';
import 'package:jobber_city/screens/auth/widget/social_login.dart';
import 'package:jobber_city/widgets/custom_animated_checkbox.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';

part 'login_screen_controller.dart';

class LoginScreenView extends GetView<LoginScreenViewController> {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 80,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(theme, isDark), // 🟢 Passed Context
                  const SizedBox(height: 32),
                  _buildLoginForm(),
                  const SizedBox(height: 5),
                  _buildForgotPassword(isDark), // 🟢 Passed Context
                  const SizedBox(height: 20),
                  Obx(() {
                    return CustomButton(
                      onPressed: () {
                        if (!controller.isLoading.value) {
                          controller.login();
                        }
                      },
                      text: controller.isLoading.value
                          ? "Logging in..."
                          : "Login",
                    );
                  }),
                  const SizedBox(height: 25),
                  _buildDivider(isDark), // 🟢 Passed Context
                  const SizedBox(height: 25),
                  SocialLogin(
                    onPressed: () {
                      controller.loginWithGoogle();
                    },
                    text: 'Continue with Google',
                    iconPath: AppAssets.google,
                  ),
                  const SizedBox(height: 20),
                  _buildSignUpLink(isDark), // 🟢 Passed Context
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary, // 🟢 Dynamic Text
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              Get.offNamed(AppRoutes.createAccount);
            },
            child: Text(
              'Sign up',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? Colors.blueAccent
                    : AppColors.primary, // 🟢 Dynamic Link
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: isDark ? Colors.blueAccent : AppColors.primary,
                decorationThickness: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Expanded(
          child: Divider(
            thickness: 1.4,
            color: isDark ? AppColors.darkDivider : AppColors.line,
          ),
        ), // 🟢 Dynamic Divider
        Text(
          'Or',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary, // 🟢 Dynamic Text
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.4,
            color: isDark ? AppColors.darkDivider : AppColors.line,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(
              () => CustomAnimatedCheckbox(
                value: controller.rememberMe.value,
                onTap: () => controller.toggleRememberMe(),
                label: 'Remember me',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.toNamed(AppRoutes.forgotPassword);
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: isDark
                    ? Colors.blueAccent
                    : AppColors.primary, // 🟢 Dynamic Link
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: isDark ? Colors.blueAccent : AppColors.primary,
                decorationThickness: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        CustomTextfield(
          key: ValueKey('email_field_${controller.hashCode}'),
          controller: controller.emailCtrl,
          hintText: 'Email',
          prefixIcon: Icons.email,
          validator: AuthValidator.validateEmail,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          key: ValueKey('password_field_${controller.hashCode}'),
          controller: controller.passwordCtrl,
          hintText: 'Password',
          prefixIcon: Icons.lock,
          isPasswordField: true,
          validator: AuthValidator.validateLoginPassword,
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Column(
      children: [
        const Logo(size: 110),
        const SizedBox(height: 20),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Sign in to continue to your account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary, // 🟢 Dynamic Subtitle
          ),
        ),
      ],
    );
  }
}
