import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added GetX Import
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';

class LocationEmptySearch extends StatelessWidget {
  const LocationEmptySearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: LocationColors.border,
          ),
          const SizedBox(height: 12),
          Text(
            'No cities found'.tr, // 🟢 Added .tr
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: LocationColors.sub,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try a different search term'.tr, // 🟢 Added .tr
            style: const TextStyle(fontSize: 13, color: LocationColors.muted),
          ),
        ],
      ),
    );
  }
}
