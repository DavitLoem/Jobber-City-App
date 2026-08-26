import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';

class LocationEmptySearch extends StatelessWidget {
  const LocationEmptySearch({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: isDark
                ? AppColors.darkIconSecondary
                : LocationColors.border, // 🟢 Dynamic Icon
          ),
          const SizedBox(height: 12),
          Text(
            'No cities found'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : LocationColors.sub, // 🟢 Dynamic Text
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try a different search term'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextTertiary
                  : LocationColors.muted, // 🟢 Dynamic Text
            ),
          ),
        ],
      ),
    );
  }
}
