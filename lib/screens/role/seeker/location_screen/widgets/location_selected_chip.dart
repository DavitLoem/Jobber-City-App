import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';

class LocationSelectedChip extends StatelessWidget {
  final String cityName;
  final VoidCallback onClear;
  const LocationSelectedChip({
    super.key,
    required this.cityName,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            'Selected:'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : LocationColors.sub, // 🟢 Dynamic Text
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : LocationColors.accentBg, // 🟢 Dynamic BG
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 13,
                  color: isDark
                      ? Colors.blueAccent
                      : LocationColors.accent, // 🟢 Dynamic Icon
                ),
                const SizedBox(width: 4),
                Text(
                  cityName
                      .tr, // 🟢 Support translating province names if mapped
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.blueAccent
                        : LocationColors.accent, // 🟢 Dynamic Text
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onClear,
                  child: Icon(
                    Icons.close_rounded,
                    size: 13,
                    color: isDark
                        ? Colors.blueAccent
                        : LocationColors.accent, // 🟢 Dynamic Icon
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
