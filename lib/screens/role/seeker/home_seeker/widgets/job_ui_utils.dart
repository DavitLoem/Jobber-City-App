import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class JobUiUtils {
  static String periodShort(String period) {
    final p = period.toLowerCase();
    if (p.contains('year')) return 'yr'.tr; // 🟢 Added .tr
    if (p.contains('week')) return 'wk'.tr; // 🟢 Added .tr
    if (p.contains('month')) return 'mo'.tr; // 🟢 Added .tr
    return p.isEmpty ? 'mo'.tr : p.tr; // 🟢 Added .tr
  }

  static Widget buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Builder(
      // Wrap in Builder to access context
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title, // Translation passed from parent
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Color
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "See All".tr, // 🟢 Added .tr
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget buildBookmarkButton({
    required bool isSaved,
    required VoidCallback onTap,
  }) {
    return Builder(
      // Wrap in Builder to access context
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceElevated
                  : AppColors.lightSurfaceVariant, // 🟢 Dynamic Background
              borderRadius: BorderRadius.circular(9),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                key: ValueKey(isSaved),
                size: 17,
                color: isSaved
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint), // 🟢 Dynamic Icon
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget buildCompanyLogo(
    String? logoUrl,
    String companyName, {
    double size = 46,
  }) {
    return Builder(
      // Wrap in Builder to access context
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceElevated
                : AppColors.lightSurfaceVariant, // 🟢 Dynamic Background
            borderRadius: BorderRadius.circular(size * 0.26),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            ), // 🟢 Dynamic Border
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.26),
            child: (logoUrl != null && logoUrl.isNotEmpty)
                ? Image.network(
                    logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildLogoFallback(companyName),
                  )
                : _buildLogoFallback(companyName),
          ),
        );
      },
    );
  }

  static Widget _buildLogoFallback(String companyName) {
    return Center(
      child: Text(
        companyName.isNotEmpty ? companyName[0].toUpperCase() : 'C',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: AppColors.primary,
        ),
      ),
    );
  }

  static Widget buildTag(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Builder(
      // Wrap in Builder to access context
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        final lower = text.toLowerCase();
        Color bg;
        Color fg;

        if (lower.contains('remote')) {
          bg = isDark
              ? AppColors.info.withValues(alpha: 0.15)
              : AppColors.infoBackground;
          fg = isDark ? AppColors.info : AppColors.info;
        } else if (lower.contains('onsite') || lower.contains('on-site')) {
          bg = isDark
              ? AppColors.warning.withValues(alpha: 0.15)
              : AppColors.warningBackground;
          fg = isDark ? Colors.orangeAccent : AppColors.warning;
        } else if (lower.contains('hybrid') || lower.contains('full')) {
          bg = isDark
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.successBackground;
          fg = isDark ? Colors.greenAccent : AppColors.success;
        } else if (lower.contains('part') ||
            lower.contains('contract') ||
            lower.contains('senior')) {
          bg = isDark
              ? AppColors.warning.withValues(alpha: 0.15)
              : AppColors.warningBackground;
          fg = isDark ? Colors.orangeAccent : AppColors.warning;
        } else if (lower.contains('junior') || lower.contains('entry')) {
          bg = isDark
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.successBackground;
          fg = isDark ? Colors.greenAccent : AppColors.success;
        } else {
          bg = isDark
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.primaryLight;
          fg = isDark ? Colors.blueAccent : AppColors.primary;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        );
      },
    );
  }

  static Widget buildInlineEmptyState(String message, {double topPadding = 0}) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 32,
                  color: isDark
                      ? AppColors.darkIconSecondary
                      : AppColors.textDisabled,
                ),
                const SizedBox(height: 10),
                Text(
                  message, // Translations passed down from parent widget
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.textTertiary,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
