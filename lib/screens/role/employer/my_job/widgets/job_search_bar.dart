import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added GetX import for translations
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobSearchBar extends StatelessWidget {
  final TextEditingController? searchController;
  final Function(String)? onChanged;
  final VoidCallback? onSortTap;
  final bool isDark;
  final ThemeData theme;

  const JobSearchBar({
    super.key,
    this.searchController,
    this.onChanged,
    this.onSortTap,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onChanged,
              style: TextStyle(
                color: isDark ? AppColors.darkInputText : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: "Search jobs...".tr, // 🟢 Added .tr
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  color: isDark
                      ? AppColors.darkIconSecondary
                      : Colors.grey.shade400,
                  size: 20,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkInputBackground
                    : Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          InkWell(
            onTap: onSortTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkInputBackground
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Icon(
                LucideIcons.arrowUpDown,
                color: theme.textTheme.bodyLarge?.color,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
