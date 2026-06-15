import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/theme/app_assets.dart';
import 'package:jobber_city/screens/auth/widget/custom_animated_checkbox.dart';
import 'package:jobber_city/screens/auth/widget/logo.dart';
import 'package:jobber_city/screens/auth/widget/social_login.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';

part 'login_screen_controller.dart';

class LoginScreenView extends GetView<LoginScreenViewController> {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 80,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildLoginForm(),
                const SizedBox(height: 5),
                _buildForgotPassword(),
                const SizedBox(height: 20),
                CustomButton(onPressed: () {}, text: 'Login'),
                const SizedBox(height: 25),
                _buildDivider(),
                const SizedBox(height: 25),
                SocialLogin(
                  onPressed: () {},
                  text: 'Continue with Google',
                  iconPath: AppAssets.google,
                ),
                const SizedBox(height: 20),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.createAccount);
            },
            child: Text(
              'Sign up',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
                decorationThickness: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Expanded(child: Divider(thickness: 1.4, color: AppColors.line)),
        Text(
          'Or',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(child: Divider(thickness: 1.4, color: AppColors.line)),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(
              () => CustomAnimatedCheckbox(
                value: controller.rememberMe.value,
                onTap: controller.toggleRememberMe,
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
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
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
          controller: controller.emailCtrl,
          hintText: 'Email',
          prefixIcon: Icons.email,
        ),
        SizedBox(height: 16),
        CustomTextfield(
          controller: controller.passwordCtrl,
          hintText: 'Password',
          prefixIcon: Icons.lock,
          isPasswordField: true,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Logo(size: 110),
        const SizedBox(height: 20),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Sign in to continue to your account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
