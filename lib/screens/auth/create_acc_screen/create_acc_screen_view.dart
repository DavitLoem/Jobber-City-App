import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/theme/app_assets.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/core/utils/auth_validator.dart';
import 'package:jobber_city/models/auth_model/register_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/auth/widget/logo.dart';
import 'package:jobber_city/screens/auth/widget/social_login.dart';
import 'package:jobber_city/screens/auth/widget/tab_bar.dart';
import 'package:jobber_city/widgets/custom_animated_checkbox.dart';
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
        // 🎯 ១. ប្រើ LayoutBuilder ដើម្បីចាប់យកទំហំកម្ពស់អេក្រង់
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                // 🎯 ២. បង្ខំឱ្យកម្ពស់អប្បបរមា ស្មើនឹងកម្ពស់អេក្រង់ទូរស័ព្ទ
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                // 🎯 ៣. ប្រើ IntrinsicHeight ដើម្បីឱ្យ Widget ខាងក្នុងអាចរុញគ្នាបានត្រឹមត្រូវ
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(23, 0, 23, 30),
                    child: Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        AnimatedTabBar(controller: controller),
                        const SizedBox(height: 8),

                        Expanded(
                          child: Form(
                            key: controller.formKey,
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 12),

        const Logo(size: 80),

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
                validator: AuthValidator.validateName,
                textInputAction: TextInputAction.next,
              ),
            ),
            Expanded(
              child: CustomTextfield(
                controller: controller.lastNameCtrl,
                hintText: 'Last Name',
                prefixIcon: Icons.person,
                validator: AuthValidator.validateName,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        CustomTextfield(
          controller: controller.emailCtrl,
          hintText: 'Email',
          prefixIcon: Icons.email,
          validator: AuthValidator.validateEmail,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 16),

        CustomTextfield(
          controller: controller.passwordCtrl,
          hintText: 'Password',
          prefixIcon: Icons.lock,
          suffixIcon: Icons.visibility,
          isPasswordField: true,
          showPasswordStrength: true,
          validator: AuthValidator.validatePassword,
          textInputAction: TextInputAction.done,
        ),

        const SizedBox(height: 16),

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

        const SizedBox(height: 16),

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

        const SizedBox(height: 16),

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

        const SizedBox(height: 16),

        Obx(() {
          // ១. កំណត់អក្សរទៅតាម Tab
          String btnText = isEmployer
              ? 'Continue as Employer with Google'
              : 'Continue as Seeker with Google';

          // ២. ទាញយក Loading State ពី AuthController
          bool isGoogleLoading =
              Get.find<AuthController>().isGoogleLoading.value;

          return SizedBox(
            width: double.infinity,
            child: SocialLogin(
              // បិទប៊ូតុងមិនឱ្យចុច ពេលកំពុង Loading
              onPressed: isGoogleLoading
                  ? null
                  : () {
                      controller.registerWithGoogle();
                    },
              text: btnText,
              iconPath: AppAssets.google,
              isLoading: isGoogleLoading,
            ),
          );
        }),

        const SizedBox(height: 16),

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
                  Get.offNamed(AppRoutes.login);
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

        const SizedBox(height: 6),
      ],
    );
  }
}
