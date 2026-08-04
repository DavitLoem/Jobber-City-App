import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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
            // ជួរទី ១
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: "Post New Job",
                    icon: Icons.add_rounded,
                    iconColor: const Color(0xFF4F7DF7),
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: "View Analytics",
                    icon: Icons.bar_chart_rounded,
                    iconColor: const Color(0xFF9333EA), // ពណ៌ស្វាយ
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ជួរទី ២
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: "Top Candidates",
                    icon: Icons.bolt_rounded,
                    iconColor: const Color(0xFFD97706), // ពណ៌លឿងទុំ
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: "Schedule",
                    icon: Icons.calendar_month_rounded,
                    iconColor: const Color(0xFF059669), // ពណ៌បៃតង
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

  // ── ៣. អនុគមន៍សម្រាប់គូរប្រអប់ Action នីមួយៗ (Reusable Widget) ──
  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
        child: Row(
          children: [
            // ផ្នែក Icon ដែលមានផ្ទៃពណ៌ព្រាលៗ (Tinted Background)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),

            // ផ្នែកអក្សរចំណងជើង
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
    );
  }
}
