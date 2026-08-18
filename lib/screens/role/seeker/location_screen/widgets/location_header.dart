import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added GetX Import
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';

class LocationHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackPressed;
  final bool showBackButton;

  const LocationHeader({
    super.key,
    required this.title,
    required this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showBackButton) ...[
                GestureDetector(
                  onTap: onBackPressed,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],

              Text(
                title, // 🟢 Translation is handled by the parent View passing this title
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: LocationColors.ink,
                  letterSpacing: -0.6,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Select your province to find jobs near you'.tr, // 🟢 Added .tr
            style: const TextStyle(
              fontSize: 14,
              color: LocationColors.sub,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
