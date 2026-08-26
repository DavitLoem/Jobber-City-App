import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/models/role/employer/employer_dashboard_model.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../routes/app_routes.dart';

class RecentApplicantsSection extends StatelessWidget {
  final List<RecentApplicantModel> applicants;

  const RecentApplicantsSection({super.key, required this.applicants});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
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
                color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Subheader
                letterSpacing: -0.3,
              ),
            ),
            InkWell(
              onTap: () {
                if (Get.isRegistered<MainScreenEmloyerController>()) {
                  Get.find<MainScreenEmloyerController>().changeTab(2);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      "View all".tr, // 🟢 Added .tr
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.blueAccent
                            : const Color(
                                0xFF4F7DF7,
                              ), // 🟢 Dynamic Subaction Text
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: isDark
                          ? Colors.blueAccent
                          : const Color(0xFF4F7DF7), // 🟢 Dynamic Action Icon
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (applicants.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceElevated
                  : Colors.white, // 🟢 Dynamic Empty State BG
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
              ), // 🟢 Dynamic Border
            ),
            child: Column(
              children: [
                Icon(
                  Icons.person_search_rounded,
                  size: 48,
                  color: isDark
                      ? AppColors.darkIconSecondary
                      : Colors.grey.shade300, // 🟢 Dynamic Placeholder Icon
                ),
                const SizedBox(height: 12),
                Text(
                  "No recent applicants yet".tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : Colors.grey.shade500, // 🟢 Dynamic Empty State Text
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: applicants.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = applicants[index];
              return _buildApplicantCard(data, isDark); // 🟢 Passed Theme State
            },
          ),
      ],
    );
  }

  Widget _buildApplicantCard(RecentApplicantModel applicant, bool isDark) {
    Color statusBgColor = isDark
        ? const Color(0xFF64748B).withValues(alpha: 0.15)
        : const Color(0xFFF1F5F9);
    Color statusTextColor = isDark
        ? Colors.grey.shade300
        : const Color(0xFF64748B);

    final statusLower = applicant.status.toLowerCase();
    if (statusLower == 'interview') {
      statusBgColor = isDark
          ? const Color(0xFF4F7DF7).withValues(alpha: 0.15)
          : const Color(0xFFEEF2FF);
      statusTextColor = isDark ? Colors.blueAccent : const Color(0xFF4F7DF7);
    } else if (statusLower == 'shortlisted' || statusLower == 'review') {
      statusBgColor = isDark
          ? const Color(0xFFD97706).withValues(alpha: 0.15)
          : const Color(0xFFFFFBEB);
      statusTextColor = isDark
          ? const Color(0xFFFBBF24)
          : const Color(0xFFD97706);
    } else if (statusLower == 'hired' || statusLower == 'offer') {
      statusBgColor = isDark
          ? const Color(0xFF10B981).withValues(alpha: 0.15)
          : const Color(0xFFECFDF5);
      statusTextColor = isDark ? Colors.greenAccent : const Color(0xFF10B981);
    } else if (statusLower == 'rejected') {
      statusBgColor = isDark
          ? const Color(0xFFEF4444).withValues(alpha: 0.15)
          : const Color(0xFFFEF2F2);
      statusTextColor = isDark ? Colors.redAccent : const Color(0xFFEF4444);
    }

    String initials = "U";
    if (applicant.name.isNotEmpty) {
      final nameParts = applicant.name.trim().split(" ");
      if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
        initials = "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase();
      } else {
        initials = nameParts[0][0].toUpperCase();
      }
    }

    String dateStr = "Recently".tr; // 🟢 Added .tr
    if (applicant.appliedAt != null) {
      dateStr =
          "${applicant.appliedAt!.day}/${applicant.appliedAt!.month}/${applicant.appliedAt!.year}";
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Entry BG
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.transparent,
        ), // 🟢 Edge highlight for dark UI
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.03,
            ), // 🟢 Dynamic Shadow
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.toNamed(
              AppRoutes.candidateDetail,
              arguments: applicant.applicantId,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.blueAccent
                        : const Color(
                            0xFF4F7DF7,
                          ), // 🟢 Dynamic Avatar Accent Base
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isDark
                                    ? Colors.blueAccent
                                    : const Color(0xFF4F7DF7))
                                .withValues(
                                  alpha: 0.2,
                                ), // 🟢 Dynamic Avatar Shadow
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: applicant.avatarUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(applicant.avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: applicant.avatarUrl.isEmpty
                      ? Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(
                                  0xFF1E293B,
                                ), // 🟢 Dynamic List Label Text
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        applicant.jobTitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : const Color(
                                  0xFF64748B,
                                ), // 🟢 Dynamic List Subtext
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : const Color(0xFF94A3B8), // 🟢 Dynamic List Time
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            statusBgColor, // 🟢 Inject configured color block
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        applicant.status.capitalizeFirst ??
                            applicant
                                .status, // Often these represent states; handle localization logic inside status mapping if preferred
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color:
                              statusTextColor, // 🟢 Inject configured color text
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
