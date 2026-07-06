import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? LocationColors.tileBgHover : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? LocationColors.accent.withValues(alpha: 0.25)
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
                      : LocationColors.muted,
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
                location.nameEn,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? LocationColors.ink
                      : LocationColors.ink.withValues(alpha: 0.85),
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
