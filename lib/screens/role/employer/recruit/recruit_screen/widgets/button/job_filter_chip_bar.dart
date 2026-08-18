import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart';

class JobFilterChipBar extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Map<String, int> counts;
  final ValueChanged<String> onSelect;

  const JobFilterChipBar({
    super.key,
    required this.options,
    required this.selected,
    required this.counts,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // 🟢 Blend with scaffold
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: options.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final label = options[index];
            final count = counts[label] ?? 0;
            final isSelected = selected == label;
            return _FilterChip(
              label: label,
              count: count,
              isSelected: isSelected,
              onTap: () => onSelect(label),
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.chipUnselected), // 🟢 Dynamic Chip BG
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark && !isSelected
                ? AppColors.darkCardBorder
                : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.shadowBlue.withValues(
                      alpha: isDark ? 0.3 : 0.5,
                    ), // 🟢 Updated to withValues
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '@label (@count)'.trParams({
            'label': label.tr,
            'count': count.toString(),
          }), // 🟢 Added .trParams
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColors.white
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.chipUnselectedText), // 🟢 Dynamic Text
          ),
        ),
      ),
    );
  }
}
