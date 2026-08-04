import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Text(
            'Selected:',
            style: TextStyle(
              fontSize: 12,
              color: LocationColors.sub,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: LocationColors.accentBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 13,
                  color: LocationColors.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  cityName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: LocationColors.accent,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onClear,
                  child: const Icon(
                    Icons.close_rounded,
                    size: 13,
                    color: LocationColors.accent,
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
