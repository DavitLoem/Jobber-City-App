import 'package:flutter/material.dart';
import 'package:jobber_city/core/theme/app_assets.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

class Logo extends StatelessWidget {
  const Logo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? AppColors.darkSurfaceElevated : Colors.white, // 🟢 Dynamic BG
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1), // 🟢 Dynamic Shadow
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(AppAssets.logo, height: size, width: size),
    );
  }
}