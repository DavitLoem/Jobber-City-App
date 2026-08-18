import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions".tr, // 🟢 Added .tr
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.bodyLarge?.color,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: "Post New Job".tr, // 🟢 Added .tr
                    icon: Icons.add_rounded,
                    iconColor: isDark
                        ? Colors.blueAccent
                        : const Color(0xFF4F7DF7),
                    theme: theme,
                    isDark: isDark,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: "View Analytics".tr, // 🟢 Added .tr
                    icon: Icons.bar_chart_rounded,
                    iconColor: isDark
                        ? Colors.purpleAccent
                        : const Color(0xFF9333EA),
                    theme: theme,
                    isDark: isDark,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: "Top Candidates".tr, // 🟢 Added .tr
                    icon: Icons.bolt_rounded,
                    iconColor: isDark
                        ? Colors.orangeAccent
                        : const Color(0xFFD97706),
                    theme: theme,
                    isDark: isDark,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: "Schedule".tr, // 🟢 Added .tr
                    icon: Icons.calendar_month_rounded,
                    iconColor: isDark
                        ? Colors.greenAccent
                        : const Color(0xFF059669),
                    theme: theme,
                    isDark: isDark,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required ThemeData theme,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.2 : 0.02, // 🟢 Updated opacity
              ),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(
                  alpha: 0.15, // 🟢 Updated opacity
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
