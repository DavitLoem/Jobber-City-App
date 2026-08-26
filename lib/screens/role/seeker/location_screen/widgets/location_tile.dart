import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';

class LocationTile extends StatelessWidget {
  final LocationModel location;
  final bool isSelected;
  final VoidCallback onTap;

  const LocationTile({
    super.key,
    required this.location,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : LocationColors.tileBgHover)
              : Colors.transparent, // 🟢 Dynamic Hover BG
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? LocationColors.accent.withValues(
                    alpha: 0.25,
                  ) // 🟢 Updated to withValues
                : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? LocationColors.accent : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? LocationColors.accent
                      : (isDark
                            ? AppColors.darkCardBorder
                            : LocationColors
                                  .muted), // 🟢 Dynamic Checkbox Border
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                location
                    .nameEn
                    .tr, // 🟢 Ensure API location names evaluate translation
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? theme
                            .textTheme
                            .bodyLarge
                            ?.color // 🟢 Dynamic Selected Text
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : LocationColors.ink.withValues(
                                alpha: 0.85,
                              )), // 🟢 Dynamic Unselected Text
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.location_on_rounded,
                size: 16,
                color: LocationColors.accent,
              ),
          ],
        ),
      ),
    );
  }
}
