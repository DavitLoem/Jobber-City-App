import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added GetX import for translations
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobCardItem extends StatelessWidget {
  final String title;
  final String? logoUrl;
  final String department;
  final String location;
  final String timeAgo;
  final String status;
  final bool isUrgent;
  final int candidatesCount;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;
  final bool isDark;
  final ThemeData theme;

  const JobCardItem({
    super.key,
    required this.title,
    required this.department,
    required this.location,
    required this.timeAgo,
    required this.status,
    this.isUrgent = false,
    required this.candidatesCount,
    required this.onTap,
    required this.onMoreTap,
    this.logoUrl,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final statusLower = status.toLowerCase();

    Color badgeColor = isDark
        ? AppColors.darkSurfaceElevated
        : Colors.grey.shade100;
    Color badgeTextColor = isDark
        ? AppColors.darkTextSecondary
        : Colors.grey.shade700;
    String displayStatus = status.toUpperCase();

    if (statusLower == 'active') {
      badgeColor = isDark
          ? Colors.greenAccent.withValues(alpha: 0.15) // 🟢 Updated opacity
          : Colors.green.shade50;
      badgeTextColor = isDark ? Colors.greenAccent : Colors.green.shade700;
      displayStatus = 'ACTIVE'.tr; // 🟢 Added .tr
    } else if (statusLower == 'inactive' || statusLower == 'paused') {
      badgeColor = isDark
          ? Colors.orangeAccent.withValues(alpha: 0.15) // 🟢 Updated opacity
          : Colors.orange.shade50;
      badgeTextColor = isDark ? Colors.orangeAccent : Colors.orange.shade700;
      displayStatus = 'PAUSED'.tr; // 🟢 Added .tr
    } else if (statusLower == 'closed') {
      badgeColor = isDark
          ? Colors.redAccent.withValues(alpha: 0.15) // 🟢 Updated opacity
          : Colors.red.shade50;
      badgeTextColor = isDark ? Colors.redAccent : Colors.red.shade700;
      displayStatus = 'CLOSED'.tr; // 🟢 Added .tr
    } else if (statusLower == 'draft') {
      badgeColor = isDark
          ? AppColors.darkSurfaceElevated
          : Colors.grey.shade100;
      badgeTextColor = isDark ? AppColors.darkTextHint : Colors.grey.shade700;
      displayStatus = 'DRAFT'.tr; // 🟢 Added .tr
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.grey.shade100,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.2 : 0.02, // 🟢 Updated opacity
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(
                            alpha: 0.15,
                          ) // 🟢 Updated opacity
                        : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: logoUrl != null && logoUrl!.isNotEmpty
                        ? Image.network(
                            logoUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            LucideIcons.briefcase,
                            size: 28,
                            color: isDark
                                ? AppColors.primary
                                : Colors.grey.shade400,
                          ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              department,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : Colors.grey.shade500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUrgent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.redAccent.withValues(
                                        alpha: 0.15,
                                      ) // 🟢 Updated opacity
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "URGENT".tr, // 🟢 Added .tr
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.redAccent
                                      : Colors.red.shade400,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    displayStatus,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onMoreTap,
                  child: Icon(
                    Icons.more_vert,
                    color: isDark ? AppColors.darkTextHint : Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Icon(
                  LucideIcons.mapPin,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  LucideIcons.clock,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 1,
                color: isDark ? AppColors.darkDivider : const Color(0xFFF3F4F6),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (candidatesCount > 0) ...[
                      _buildOverlappingAvatars(),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      candidatesCount == 0
                          ? "No candidates yet"
                                .tr // 🟢 Added .tr
                          : "@count candidates".trParams({
                              'count': candidatesCount.toString(),
                            }), // 🟢 Added .trParams
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: candidatesCount == 0
                            ? (isDark
                                  ? AppColors.darkTextTertiary
                                  : Colors.grey.shade500)
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlappingAvatars() {
    if (candidatesCount == 0) return const SizedBox.shrink();

    final displayCount = candidatesCount > 3 ? 3 : candidatesCount;

    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
    ];
    final letters = ['A', 'B', 'C'];

    return SizedBox(
      width: 26.0 + ((displayCount - 1) * 18.0),
      height: 26,
      child: Stack(
        children: List.generate(displayCount, (index) {
          return Positioned(
            left: index * 18.0,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  letters[index],
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
