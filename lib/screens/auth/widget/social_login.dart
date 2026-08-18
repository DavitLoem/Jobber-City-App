import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: isDark
              ? AppColors.primary.withOpacity(0.3)
              : Colors.blue.withOpacity(0.8), // 🟢 Dynamic Splash Color
          highlightColor: AppColors.primary.withOpacity(isDark ? 0.15 : 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark
                  ? AppColors.darkInputBackground
                  : AppColors.white, // 🟢 Dynamic Box BG
              border: Border.all(
                color: isDark
                    ? AppColors.darkCardBorder
                    : AppColors.line, // 🟢 Dynamic Border
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.badgeBackground.withOpacity(
                    isDark ? 0.02 : 0.1,
                  ), // 🟢 Adjusted shadow for Dark Mode
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
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkInputText
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
