import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added GetX Import
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
    return Container(
      decoration: BoxDecoration(
        color: LocationColors.searchBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.transparent),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          color: LocationColors.ink,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search province…'.tr, // 🟢 Added .tr
          hintStyle: const TextStyle(fontSize: 14, color: LocationColors.muted),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: LocationColors.sub,
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
          fillColor: LocationColors.searchBg,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
