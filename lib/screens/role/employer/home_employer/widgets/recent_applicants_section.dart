import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

class RecentApplicantsSection extends StatelessWidget {
  const RecentApplicantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Applicants".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: theme.textTheme.bodyLarge?.color,
                letterSpacing: -0.3,
              ),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      "View all".tr, // 🟢 Added .tr
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            // Note: Since this is purely UI mock data, we leave names alone,
            // but translate roles/status strings for demonstration.
            final mockData = [
              {
                "initials": "AC",
                "name": "Alexandra Chen",
                "role": "Senior Product Designer".tr,
                "status": "Interview".tr,
                "rating": "4.9",
                "date": "Today, 10:30 AM".tr,
                "statusTextColor": isDark
                    ? Colors.blueAccent
                    : const Color(0xFF4F7DF7),
              },
              {
                "initials": "MJ",
                "name": "Marcus Johnson",
                "role": "Full Stack Engineer".tr,
                "status": "Review".tr,
                "rating": "4.7",
                "date": "Today, 11:15 AM".tr,
                "statusTextColor": isDark
                    ? Colors.orangeAccent
                    : const Color(0xFFD97706),
              },
              {
                "initials": "SL",
                "name": "Sarah Lee",
                "role": "Growth Marketing Lead".tr,
                "status": "Screening".tr,
                "rating": "4.5",
                "date": "Yesterday, 2:45 PM".tr,
                "statusTextColor": isDark
                    ? AppColors.darkTextSecondary
                    : const Color(0xFF64748B),
              },
              {
                "initials": "VL",
                "name": "Victor Lee",
                "role": "Creative Director".tr,
                "status": "Offer".tr,
                "rating": "4.6",
                "date": "Yesterday, 2:45 PM".tr,
                "statusTextColor": isDark
                    ? Colors.greenAccent
                    : const Color(0xFF10B981),
              },
            ];

            final data = mockData[index];

            return _buildApplicantCard(
              initials: data["initials"] as String,
              name: data["name"] as String,
              role: data["role"] as String,
              status: data["status"] as String,
              rating: data["rating"] as String,
              statusTextColor: data["statusTextColor"] as Color,
              date: data["date"] as String,
              theme: theme,
              isDark: isDark,
            );
          },
        ),
      ],
    );
  }

  Widget _buildApplicantCard({
    required String initials,
    required String name,
    required String role,
    required String status,
    required String rating,
    required String date,
    required Color statusTextColor,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.2 : 0.03, // 🟢 Updated opacity
            ),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: 0.2,
                  ), // 🟢 Updated opacity
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusTextColor.withValues(
                    alpha: isDark ? 0.15 : 0.1, // 🟢 Updated opacity
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
