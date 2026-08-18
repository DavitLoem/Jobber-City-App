import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class SectionFieldLabel extends StatelessWidget {
  final String title;
  final bool isOptional;
  const SectionFieldLabel({
    super.key,
    required this.title,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Text(
          title, // 🟢 Translation is handled by the parent widget passing the string
          style: TextStyle(
            color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        if (!isOptional)
          const Text(
            ' *',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.2,
            ),
          ),
      ],
    );
  }
}
