import 'package:flutter/material.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';

class LocationEmptySearch extends StatelessWidget {
  const LocationEmptySearch({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: LocationColors.border,
          ),
          SizedBox(height: 12),
          Text(
            'No cities found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: LocationColors.sub,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Try a different search term',
            style: TextStyle(fontSize: 13, color: LocationColors.muted),
          ),
        ],
      ),
    );
  }
}
