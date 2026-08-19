import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class JobUiUtils {
  static String periodShort(String period) {
    final p = period.toLowerCase();
    if (p.contains('year')) return 'yr'.tr; // 🟢 Optional: Add .tr for periods
    if (p.contains('week')) return 'wk'.tr;
    if (p.contains('month')) return 'mo'.tr;
    return p.isEmpty ? 'mo'.tr : p.tr;
  }

  static Widget buildSectionHeader(
    String title, {
    VoidCallback? onSeeAll,
    bool? isDark,
  }) {
    isDark ??= Get.theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, // Translations applied in parent
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
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
  }

  static Widget buildBookmarkButton({
    required bool isSaved,
    required VoidCallback onTap,
    bool? isDark,
  }) {
    isDark ??= Get.theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceElevated
              : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(9),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            key: ValueKey(isSaved),
            size: 17,
            color: isSaved
                ? AppColors.primary
                : (isDark ? AppColors.darkTextHint : AppColors.textHint),
          ),
        ),
      ),
    );
  }

  static Widget buildCompanyLogo(
    String? logoUrl,
    String companyName, {
    double size = 46,
    bool? isDark,
  }) {
    isDark ??= Get.theme.brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(size * 0.26),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.26),
        child: (logoUrl != null && logoUrl.isNotEmpty)
            ? Image.network(
                logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildLogoFallback(companyName, isDark: isDark),
              )
            : _buildLogoFallback(companyName, isDark: isDark),
      ),
    );
  }

  static Widget _buildLogoFallback(String companyName, {bool? isDark}) {
    isDark ??= Get.theme.brightness == Brightness.dark;
    return Center(
      child: Text(
        companyName.isNotEmpty ? companyName[0].toUpperCase() : 'C',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: isDark ? AppColors.darkTextLink : AppColors.textLink,
        ),
      ),
    );
  }

  static Widget buildTag(String text, {bool? isDark}) {
    if (text.isEmpty) return const SizedBox.shrink();
    final lower = text.toLowerCase();
    isDark ??= Get.theme.brightness == Brightness.dark;

    Color bg;
    Color fg;

    // 🟢 Updated all .withOpacity to .withValues
    if (lower.contains('remote')) {
      bg = isDark
          ? AppColors.info.withValues(alpha: 0.15)
          : AppColors.infoBackground;
      fg = isDark ? Colors.blueAccent : AppColors.info;
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
          ? AppColors.primary.withValues(alpha: 0.2)
          : AppColors.primaryLight;
      fg = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.tr, // 🟢 Translated Job Tag Text
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  static Widget buildInlineEmptyState(
    String message, {
    double topPadding = 0,
    bool? isDark,
  }) {
    isDark ??= Get.theme.brightness == Brightness.dark;

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
                  ? AppColors.darkTextDisabled
                  : AppColors.textDisabled,
            ),
            const SizedBox(height: 10),
            Text(
              message, // Parent handles .tr
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
  }
}
