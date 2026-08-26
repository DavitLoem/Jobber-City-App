import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ApplicantPipelineCard extends StatelessWidget {
  final int screening;
  final int review;
  final int interview;
  final int offer;

  const ApplicantPipelineCard({
    super.key,
    required this.screening,
    required this.review,
    required this.interview,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    final int total = screening + review + interview + offer;
    final double progressWidth = 3;

    const Color colorScreening = Color(0xFF64748B);
    const Color colorReview = Color(0xFFF59E0B);
    const Color colorInterview = Color(0xFF3B82F6);
    const Color colorOffer = Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic BG
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.transparent,
        ), // 🟢 Dynamic Border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.04,
            ), // 🟢 Dynamic Shadow
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ផ្នែកទី ១៖ ចំណងជើង និងប៊ូតុង Details ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Applicant Pipeline".tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color:
                          theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "@count active candidates".trParams({
                      'count': total.toString(),
                    }), // 🟢 Added .trParams
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : const Color(0xFF64748B), // 🟢 Dynamic Text
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _goToCandidatesTab('all'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : const Color(
                              0xFFEEF2FF,
                            ), // 🟢 Dynamic Details Button BG
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.barChart2,
                          size: 16,
                          color: isDark
                              ? Colors.blueAccent
                              : const Color(0xFF4F7DF7), // 🟢 Dynamic Icon
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Details".tr, // 🟢 Added .tr
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.blueAccent
                                : const Color(0xFF4F7DF7), // 🟢 Dynamic Text
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── ផ្នែកទី ២៖ របារពណ៌ Dynamic Progress Bar ──
          Row(
            children: [
              if (total == 0)
                Expanded(
                  child: _buildSegment(
                    isDark
                        ? AppColors.darkInputBackground
                        : Colors.grey.shade200,
                  ),
                ) // 🟢 Dynamic Empty Bar
              else ...[
                if (screening > 0) ...[
                  Expanded(
                    flex: screening,
                    child: _buildSegment(colorScreening),
                  ),
                  if (review > 0 || interview > 0 || offer > 0)
                    SizedBox(width: progressWidth),
                ],
                if (review > 0) ...[
                  Expanded(flex: review, child: _buildSegment(colorReview)),
                  if (interview > 0 || offer > 0)
                    SizedBox(width: progressWidth),
                ],
                if (interview > 0) ...[
                  Expanded(
                    flex: interview,
                    child: _buildSegment(colorInterview),
                  ),
                  if (offer > 0) SizedBox(width: progressWidth),
                ],
                if (offer > 0) ...[
                  Expanded(flex: offer, child: _buildSegment(colorOffer)),
                ],
              ],
            ],
          ),
          const SizedBox(height: 24),

          // ── ផ្នែកទី ៣៖ តួលេខលម្អិត (Legend Grid ដែលអាចចុចបាន) ──
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildLegendItem(
                      "Screening".tr, // 🟢 Added .tr
                      screening,
                      colorScreening,
                      'pending',
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildLegendItem(
                      "Review".tr, // 🟢 Added .tr
                      review,
                      colorReview,
                      'shortlisted',
                      isDark,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildLegendItem(
                      "Interview".tr, // 🟢 Added .tr
                      interview,
                      colorInterview,
                      'interview',
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildLegendItem(
                      "Offer".tr, // 🟢 Added .tr
                      offer,
                      colorOffer,
                      'hired',
                      isDark,
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

  Widget _buildSegment(Color color) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildLegendItem(
    String title,
    int value,
    Color color,
    String targetStatus,
    bool isDark,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _goToCandidatesTab(targetStatus),
        borderRadius: BorderRadius.circular(8),
        splashColor: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : const Color(0xFF64748B), // 🟢 Dynamic Label
                ),
              ),
              const Spacer(),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF1E293B), // 🟢 Dynamic Value
                ),
              ),
            ],
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
