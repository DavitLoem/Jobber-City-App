import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/routes/core/constants/app_colors.dart';
import 'package:jobber_city/routes/core/theme/app_assets.dart';
import 'package:jobber_city/screens/auth/widget/custom_animated_checkbox.dart';
import 'package:jobber_city/screens/auth/widget/logo.dart';
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
            // 1. Fixed Header Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildHeader(),
            ),
            const SizedBox(height: 20),
            
            // 2. Fixed Tab Bar Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AnimatedTabBar(controller: controller),
            ),
            const SizedBox(height: 20),
            
            // 3. Scrollable Input Fields Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Obx(() {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: controller.selectedIndex.value == 0
                        ? _buildLoginEmployer()
                        : _buildLoginSeeker(),
                  );
                }),
              ),
            ),
            
            // 4. Fixed Sticky Register Button at the very bottom
           
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Logo(size: 120),
        const SizedBox(height: 20),

        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'Fill in your details to get started',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

 

Widget _buildLoginEmployer() {
    return Column(
      key: const ValueKey('Employer'),
      children: [
        CustomTextfield(hintText: 'Full Name', prefixIcon: Icons.person),
        const SizedBox(height: 16),
       
        CustomTextfield(hintText: 'Email', prefixIcon: Icons.email), 
        const SizedBox(height: 16),
        CustomTextfield(hintText: 'Password', prefixIcon: Icons.lock, suffixIcon: Icons.visibility, isPasswordField: true), 
        const SizedBox(height: 16),
        CustomTextfield(hintText: 'Confirm Password', prefixIcon: Icons.lock, suffixIcon: Icons.visibility, isPasswordField: true), 
        const SizedBox(height: 30),
        
       Obx(() => CustomAnimatedCheckbox(
             value: controller.agreeToTermsEmployer.value, // Bind to true boolean state
              onTap: () => controller.toggleTermsEmployer(), //
              label: "I agree to the ",
              linkText: "Terms of Service",
              labelText: " and",
              linkText2: " Privacy Policy",
              onLinkTap: () {
                // Handle opening your Terms & Conditions page here
              },
              onLinkTap2: () {
                // Handle opening your Privacy Policy page here
              },
            )),
            const SizedBox(height: 20),
            CustomButton(onPressed: (){}, text: 'Create Account'),
            const SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            Expanded(child: Divider(
              thickness: 1.4,
              color: AppColors.line,
            )),
            Text(
              'Or',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
              ),
            ),
            Expanded(child: Divider(
              thickness: 1.4,
              color: AppColors.line,
            )),
          ],


        ),
        SizedBox(height: 20),
        Row(
          spacing: 30,
          children: [
           
            _buildContinueWith(text: 'Continue with Google', iconPath: AppAssets.google),
           
            
          ],
        ),
        SizedBox(height: 20),
        Row(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
              ),
            ),
             GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.login);
              },
          child: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
              decorationThickness: 1.4,
            ),
          ),
        ),
          ],
        ),
        SizedBox(height: 20,)
       
      ],
    );
  }

  Widget _buildContinueWith({
  required String text,
  required String iconPath,
  VoidCallback? onPressed,
  bool isLoading = false,
}) {
  return Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            border: Border.all(
              color: AppColors.line,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.badgeBackground.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconPath,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      text,
                      style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
        ),
      ),
    ),
  );
}
  Widget _buildLoginSeeker() {
     return Column(
      key: const ValueKey('Seeker'),
      children: [
        CustomTextfield(hintText: 'Full Name', prefixIcon: Icons.person),
        const SizedBox(height: 16),
     
        CustomTextfield(hintText: 'Email', prefixIcon: Icons.email), 
        const SizedBox(height: 16),
        CustomTextfield(hintText: 'Password', prefixIcon: Icons.lock, suffixIcon: Icons.visibility, isPasswordField: true), 
        const SizedBox(height: 16),
        CustomTextfield(hintText: 'Confirm Password', prefixIcon: Icons.lock, suffixIcon: Icons.visibility, isPasswordField: true), 
        const SizedBox(height: 40),
        
       Obx(() => CustomAnimatedCheckbox(
             value: controller.agreeToTermsSeeker.value, // Bind to true boolean state
              onTap: () => controller.toggleTermsSeeker(), //
              label: "I agree to the ",
              linkText: "Terms of Service",
              labelText: " and",
              linkText2: " Privacy Policy",
              onLinkTap: () {
                // Handle opening your Terms & Conditions page here
              },
              onLinkTap2: () {
                // Handle opening your Privacy Policy page here
              },
            )),
        const SizedBox(height: 30),
        CustomButton(onPressed: (){}, text: 'Create Account'),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            Expanded(child: Divider(
              thickness: 1.4,
              color: AppColors.line,
            )),
            Text(
              'Or',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
              ),
            ),
            Expanded(child: Divider(
              thickness: 1.4,
              color: AppColors.line,
            )),
          ],


        ),
        SizedBox(height: 20),
        Row(
          spacing: 30,
          children: [
           
            _buildContinueWith(text: 'Google', iconPath: AppAssets.google),
         
            
          ],
        ),
        SizedBox(height: 20),
         Row(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
              ),
            ),
             GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.login);
              },
          child: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
              decorationThickness: 1.4,
            ),
          ),
        ),
          ],
        ),
        SizedBox(height: 20,)
      ],
    );
  }
}