import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
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
    final theme = Theme.of(context);
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
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.2 : 0.04, // 🟢 Updated opacity
            ),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      color: theme.textTheme.bodyLarge?.color,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "@total active candidates".trParams({
                      'total': total.toString(),
                    }), // 🟢 Added .trParams
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withValues(
                          alpha: 0.15,
                        ) // 🟢 Updated opacity
                      : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.barChart2,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Details".tr, // 🟢 Added .tr
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              if (total == 0)
                Expanded(
                  child: _buildSegment(
                    isDark
                        ? AppColors.darkSurfaceElevated
                        : Colors.grey.shade200,
                  ),
                )
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

          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildLegendItem(
                      "Screening".tr, // 🟢 Added .tr
                      screening,
                      colorScreening,
                      theme,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildLegendItem(
                      "Review".tr, // 🟢 Added .tr
                      review,
                      colorReview,
                      theme,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildLegendItem(
                      "Interview".tr, // 🟢 Added .tr
                      interview,
                      colorInterview,
                      theme,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildLegendItem(
                      "Offer".tr, // 🟢 Added .tr
                      offer,
                      colorOffer,
                      theme,
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
    ThemeData theme,
    bool isDark,
  ) {
    return Row(
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
                : const Color(0xFF64748B),
          ),
        ),
        const Spacer(),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}
