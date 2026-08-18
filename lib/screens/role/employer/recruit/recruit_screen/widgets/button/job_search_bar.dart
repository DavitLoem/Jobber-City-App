import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart';

class JobSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool sortAscending;
  final VoidCallback onSortTap;

  const JobSearchBar({
    super.key,
    required this.onChanged,
    required this.sortAscending,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkInputBackground
                    : AppColors.inputBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : Colors.transparent,
                ),
              ),
              child: TextField(
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkInputText : AppColors.inputText,
                ),
                decoration: InputDecoration(
                  hintText: 'Search jobs...'.tr, // 🟢 Added .tr
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextHint
                        : AppColors.inputHint,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isDark
                        ? AppColors.darkIconSecondary
                        : AppColors.iconSecondary,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onSortTap,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkInputBackground
                    : AppColors.inputBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : Colors.transparent,
                ),
              ),
              child: Icon(
                sortAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.swap_vert_rounded,
                color: isDark
                    ? AppColors.darkIconSecondary
                    : AppColors.iconSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
