import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 បន្ថែម Get សម្រាប់ Navigation
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
// 🟢 Import Controllers សម្រាប់បញ្ជាការប្តូរ Tab (កែ Path ឱ្យត្រូវ)
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),

        Column(
          children: [
            // ជួរទី ១[cite: 15]
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: "Post New Job",
                    icon: Icons.add_rounded,
                    iconColor: const Color(0xFF4F7DF7),
                    onTap: () {
                      // 🟢 លោតទៅ Tab: My Jobs (Index 1)
                      if (Get.isRegistered<MainScreenEmloyerController>()) {
                        Get.find<MainScreenEmloyerController>().changeTab(1);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: "View Analytics",
                    icon: Icons.bar_chart_rounded,
                    iconColor: const Color(0xFF9333EA), // ពណ៌ស្វាយ
                    onTap: () {
                      // 🟢 អាចលោតទៅទំព័រ Report ឬបច្ចុប្បន្នគ្រាន់តែ Scroll ទៅលើ
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ជួរទី ២[cite: 15]
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: "Top Candidates",
                    icon: Icons.bolt_rounded,
                    iconColor: const Color(0xFFD97706), // ពណ៌លឿងទុំ
                    onTap: () {
                      // 🟢 លោតទៅ Tab: Candidates (Index 2)
                      _goToCandidatesTab('all');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: "Schedule",
                    icon: Icons.calendar_month_rounded,
                    iconColor: const Color(0xFF059669), // ពណ៌បៃតង
                    onTap: () {
                      // 🟢 លោតទៅ Tab: Candidates -> Interview
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

  // ── ៣. អនុគមន៍សម្រាប់គូរប្រអប់ Action នីមួយៗ (Reusable Widget) ──
  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    // 🟢 ផ្លាស់ទី InkWell ចូលក្នុង Material ដើម្បីឱ្យមាន Ripple Effect ល្អជាងមុន
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
          splashColor: iconColor.withValues(alpha: 0.1), // ពណ៌ពេលចុច
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              children: [
                // ផ្នែក Icon ដែលមានផ្ទៃពណ៌ព្រាលៗ (Tinted Background)[cite: 15]
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),

                // ផ្នែកអក្សរចំណងជើង[cite: 15]
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
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

  // 🎯 អនុគមន៍ជំនួយសម្រាប់រត់ទៅកាន់ Candidates Tab រួចកំណត់ Status
  void _goToCandidatesTab(String targetStatus) {
    if (Get.isRegistered<MainScreenEmloyerController>()) {
      Get.find<MainScreenEmloyerController>().changeTab(2);
    }

    if (Get.isRegistered<CandidatesViewController>()) {
      final candidateCtrl = Get.find<CandidatesViewController>();

      // ផ្តាច់ (Clear) ការ Filter តាមការងារ (Job) ដើម្បីមើលបេក្ខជនទាំងអស់
      candidateCtrl.selectedJobId.value = 'all';

      int targetIndex = candidateCtrl.tabs.indexOf(targetStatus);
      if (targetIndex == -1) targetIndex = 0;

      candidateCtrl.tabController.animateTo(targetIndex);
      candidateCtrl.fetchApplicants(isRefresh: true);
      candidateCtrl.fetchStatusSummary();
    }
  }
}
