import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    super.key,
    required this.searchController,
    this.onChanged,
  });

  final TextEditingController searchController;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkInputBackground
            : LocationColors.searchBg, // 🟢 Dynamic BG
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.darkCardBorder
              : Colors.transparent, // 🟢 Dynamic Border
        ),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14,
          color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search province…'.tr, // 🟢 Added .tr
          hintStyle: TextStyle(
            fontSize: 14,
            color: isDark
                ? AppColors.darkTextHint
                : LocationColors.muted, // 🟢 Dynamic Hint
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark
                ? AppColors.darkIconSecondary
                : LocationColors.sub, // 🟢 Dynamic Icon
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: LocationColors.accent,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: isDark
              ? AppColors.darkInputBackground
              : LocationColors.searchBg, // 🟢 Dynamic Fill
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
