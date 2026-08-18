import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ), // 🟢 Dynamic Border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : Colors.grey.shade500, // 🟢 Dynamic Subtitle
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            height: 1,
            color: isDark
                ? AppColors.darkDivider
                : Colors.grey.shade100, // 🟢 Dynamic Divider
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
