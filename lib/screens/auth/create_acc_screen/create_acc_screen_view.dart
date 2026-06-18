import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/theme/app_assets.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/core/utils/auth_validator.dart';
import 'package:jobber_city/models/auth_model/register_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/widgets/custom_animated_checkbox.dart';
import 'package:jobber_city/screens/auth/widget/logo.dart';
import 'package:jobber_city/screens/auth/widget/social_login.dart';
import 'package:jobber_city/screens/auth/widget/tab_bar.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';

part 'create_acc_screen_binding.dart';
part 'create_acc_screen_controller.dart';

class CreateAccScreenView extends GetView<CreateAccScreenViewController> {
  const CreateAccScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: _buildHeader(),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: AnimatedTabBar(controller: controller),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(
                  parent: NeverScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(23, 0, 23, 30),
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: controller.selectedIndex.value == 0
                        ? _buildRegisterForm(isEmployer: false)
                        : _buildRegisterForm(isEmployer: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 12),

        const Logo(size: 120),

        const SizedBox(height: 12),

        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          'Fill in your details to get started',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRegisterForm({required bool isEmployer}) {
    return Column(
      key: ValueKey(isEmployer),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        Row(
          spacing: 12,
          children: [
            Expanded(
              child: CustomTextfield(
                controller: controller.firstNameCtrl,
                hintText: 'First Name',
                prefixIcon: Icons.person,
              ),
            ),
            Expanded(
              child: CustomTextfield(
                controller: controller.lastNameCtrl,
                hintText: 'Last Name',
                prefixIcon: Icons.person,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        CustomTextfield(
          controller: controller.emailCtrl,

          hintText: 'Email',
          prefixIcon: Icons.email,
        ),

        const SizedBox(height: 16),

        CustomTextfield(
          controller: controller.passwordCtrl,
          hintText: 'Password',
          prefixIcon: Icons.lock,
          suffixIcon: Icons.visibility,
          isPasswordField: true,
        ),

        const SizedBox(height: 24),

        Obx(
          () => CustomAnimatedCheckbox(
            value: isEmployer
                ? controller.agreeToTermsEmployer.value
                : controller.agreeToTermsSeeker.value,
            onTap: () {
              if (isEmployer) {
                controller.toggleTermsEmployer();
              } else {
                controller.toggleTermsSeeker();
              }
            },
            label: 'I agree to the ',
            linkText: 'Terms of Service',
            labelText: ' and ',
            linkText2: 'Privacy Policy',
            onLinkTap: () {},
            onLinkTap2: () {},
          ),
        ),

        const SizedBox(height: 24),

        Obx(
          () => CustomButton(
            onPressed: () {
              controller.register();
            },
            text: isEmployer
                ? 'Register as Employer'
                : 'Register as Job Seeker',
            isLoading:
                controller.isLoading.value, // បោះតម្លៃនេះទៅដើម្បីប្តូររាង
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: AppColors.line)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: AppColors.line)),
          ],
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: SocialLogin(
            onPressed: () {},
            text: 'Continue with Google',
            iconPath: AppAssets.google,
          ),
        ),

        const SizedBox(height: 24),

        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.login);
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
