import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations
import 'package:jobber_city/core/constants/app_colors.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final String iconPath;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: (isDark ? Colors.blueAccent : Colors.blue).withValues(
            alpha: 0.2,
          ), // 🟢 Dynamic Splash
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark
                  ? AppColors.darkInputBackground
                  : AppColors.white, // 🟢 Dynamic Input BG
              border: Border.all(
                color: isDark
                    ? AppColors.darkCardBorder
                    : AppColors.line, // 🟢 Dynamic Border
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.transparent
                      : AppColors.badgeBackground.withValues(
                          alpha: 0.1,
                        ), // 🟢 Dynamic Shadow
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(iconPath, width: 20, height: 20),
                const SizedBox(width: 10),
                Text(
                  text.tr, // 🟢 Added .tr (Supports both direct String and translated mapped keys)
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white
                        : AppColors.textPrimary, // 🟢 Dynamic Text
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
}
