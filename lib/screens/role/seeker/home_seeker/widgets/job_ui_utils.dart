import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class JobUiUtils {
  static String periodShort(String period) {
    final p = period.toLowerCase();
    if (p.contains('year')) return 'yr';
    if (p.contains('week')) return 'wk';
    if (p.contains('month')) return 'mo';
    return p.isEmpty ? 'mo' : p;
  }

  static Widget buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "See All",
                style: TextStyle(
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.lightSurfaceVariant,
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
            color: isSaved ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }

  static Widget buildCompanyLogo(
    String? logoUrl,
    String companyName, {
    double size = 46,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(size * 0.26),
        border: Border.all(color: AppColors.cardBorder),
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
    final lower = text.toLowerCase();
    Color bg;
    Color fg;

    if (lower.contains('remote')) {
      bg = AppColors.infoBackground;
      fg = AppColors.info;
    } else if (lower.contains('onsite') || lower.contains('on-site')) {
      bg = AppColors.warningBackground;
      fg = AppColors.warning;
    } else if (lower.contains('hybrid') || lower.contains('full')) {
      bg = AppColors.successBackground;
      fg = AppColors.success;
    } else if (lower.contains('part') ||
        lower.contains('contract') ||
        lower.contains('senior')) {
      bg = AppColors.warningBackground;
      fg = AppColors.warning;
    } else if (lower.contains('junior') || lower.contains('entry')) {
      bg = AppColors.successBackground;
      fg = AppColors.success;
    } else {
      bg = AppColors.primaryLight;
      fg = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  static Widget buildInlineEmptyState(String message, {double topPadding = 0}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 32,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
