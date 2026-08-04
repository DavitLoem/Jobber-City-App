import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

/// Search field + sort-order toggle for the job list.
/// Pure/presentational: caller owns the actual state.
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
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.inputText,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search jobs...',
                  hintStyle: TextStyle(
                    color: AppColors.inputHint,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.iconSecondary,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
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
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                sortAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.swap_vert_rounded,
                color: AppColors.iconSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
