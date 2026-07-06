import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/location_model.dart';

// Widget សម្រាប់បង្ហាញជួរទីក្រុង
class LocationListItem extends StatelessWidget {
  final LocationModel location;
  final bool isSelected;
  final VoidCallback onTap;

  const LocationListItem({
    super.key,
    required this.location,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.35)
                    : Colors.transparent,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                // Check circle (filled + check icon when selected)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textDisabled,
                      width: 1.6,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    location.nameEn,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isSelected
                      ? const Icon(
                          Icons.location_on_rounded,
                          key: ValueKey('pin'),
                          size: 20,
                          color: AppColors.primary,
                        )
                      : const SizedBox(key: ValueKey('empty'), width: 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
