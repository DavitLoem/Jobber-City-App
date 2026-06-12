import 'package:flutter/material.dart';
import 'package:jobber_city/routes/core/constants/app_colors.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key, required this.text, required this.iconPath, required this.onPressed, this.isLoading = false});

  final String text;
  final String iconPath;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withValues(alpha: 0.8),
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
                color: AppColors.badgeBackground.withValues(alpha: 0.1),
                blurRadius: 10,
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
}