import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions".tr, // 🟢 Added .tr
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Header
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
                        : const Color(0xFF4F7DF7), // 🟢 Dynamic Color
                    isDark: isDark,
                    onTap: () {
                      if (Get.isRegistered<MainScreenEmloyerController>()) {
                        Get.find<MainScreenEmloyerController>().changeTab(1);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: "View Analytics".tr, // 🟢 Added .tr
                    icon: Icons.bar_chart_rounded,
                    iconColor: isDark
                        ? const Color(0xFFA855F7)
                        : const Color(0xFF9333EA), // 🟢 Dynamic Color
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
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFD97706), // 🟢 Dynamic Color
                    isDark: isDark,
                    onTap: () {
                      _goToCandidatesTab('all');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: "Schedule".tr, // 🟢 Added .tr
                    icon: Icons.calendar_month_rounded,
                    iconColor: isDark
                        ? const Color(0xFF10B981)
                        : const Color(0xFF059669), // 🟢 Dynamic Color
                    isDark: isDark,
                    onTap: () {
                      _goToCandidatesTab('interview');
                    },
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
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Card Action BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.transparent,
        ), // 🟢 Edge highlight for dark UI
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.02,
            ), // 🟢 Dynamic Shadow Opacity
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: iconColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(
                      alpha: isDark ? 0.2 : 0.1,
                    ), // 🟢 Dynamic Tint Opacity
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
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF1E293B), // 🟢 Dynamic Card Name
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToCandidatesTab(String targetStatus) {
    if (Get.isRegistered<MainScreenEmloyerController>()) {
      Get.find<MainScreenEmloyerController>().changeTab(2);
    }

    if (Get.isRegistered<CandidatesViewController>()) {
      final candidateCtrl = Get.find<CandidatesViewController>();

      candidateCtrl.selectedJobId.value = 'all';

      int targetIndex = candidateCtrl.tabs.indexOf(targetStatus);
      if (targetIndex == -1) targetIndex = 0;

      candidateCtrl.tabController.animateTo(targetIndex);
      candidateCtrl.fetchApplicants(isRefresh: true);
      candidateCtrl.fetchStatusSummary();
    }
  }
}
