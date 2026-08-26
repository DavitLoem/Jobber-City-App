import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobSearchBar extends StatelessWidget {
  final TextEditingController? searchController;
  final Function(String)? onChanged;
  final String currentSort;
  final Function(String)? onSortChanged;

  const JobSearchBar({
    super.key,
    this.searchController,
    this.onChanged,
    required this.currentSort,
    this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // ── 1. Search Box ──
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onChanged,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ), // 🟢 Dynamic Field Text
              decoration: InputDecoration(
                hintText: "Search jobs...".tr, // 🟢 Added .tr
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
                  fontSize: 15,
                ), // 🟢 Dynamic Hint Text
                prefixIcon: Icon(
                  LucideIcons.search,
                  color: isDark
                      ? AppColors.darkIconSecondary
                      : Colors.grey.shade400, // 🟢 Dynamic Search Icon
                  size: 20,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkInputBackground
                    : Colors.grey.shade50, // 🟢 Dynamic Field BG
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : Colors.grey.shade200,
                    width: 1,
                  ), // 🟢 Dynamic Outline
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : Colors.grey.shade200,
                    width: 1,
                  ), // 🟢 Dynamic Outline
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? Colors.blueAccent
                        : Colors.blueAccent, // Standardize on Blue Focus State
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),
          // ── 2. Sort/Filter Button ──
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceElevated
                  : Colors.grey.shade50, // 🟢 Dynamic Sort Component BG
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
                width: 1,
              ), // 🟢 Dynamic Border
            ),
            child: PopupMenuButton<String>(
              icon: Icon(
                LucideIcons.arrowUpDown,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Sort Icon
                size: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isDark
                  ? AppColors.darkSurfaceElevated
                  : Colors.white, // 🟢 Dynamic Menu Modal BG
              elevation: 4,
              position: PopupMenuPosition.under,
              onSelected: (String value) {
                if (onSortChanged != null) {
                  onSortChanged!(value);
                }
              },
              itemBuilder: (BuildContext context) => [
                _buildPopupItem(
                  'newest',
                  'Newest'.tr, // 🟢 Added .tr
                  LucideIcons.clock,
                  currentSort,
                  isDark, // 🟢 Passed Theme Component
                ),
                _buildPopupItem(
                  'oldest',
                  'Oldest'.tr, // 🟢 Added .tr
                  LucideIcons.history,
                  currentSort,
                  isDark,
                ),
                _buildPopupItem(
                  'expiring_soon',
                  'Expiring Soon'.tr, // 🟢 Added .tr
                  LucideIcons.calendarClock,
                  currentSort,
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(
    String value,
    String text,
    IconData icon,
    String currentVal,
    bool isDark,
  ) {
    final bool isSelected = value == currentVal;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? (isDark ? Colors.blueAccent : const Color(0xFF4f7df7))
                : (isDark
                      ? AppColors.darkIconSecondary
                      : Colors.grey.shade600), // 🟢 Dynamic Option Icon
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? (isDark ? Colors.blueAccent : const Color(0xFF4f7df7))
                  : (isDark
                        ? Colors.white
                        : Colors.black87), // 🟢 Dynamic Option Label
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
