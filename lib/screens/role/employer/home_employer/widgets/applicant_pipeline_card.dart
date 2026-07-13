import 'package:flutter/material.dart';
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
    // គណនាចំនួនបេក្ខជនសរុប
    final int total = screening + review + interview + offer;

    final double progressWidth = 3;

    const Color colorScreening = Color(0xFF64748B);
    const Color colorReview = Color(0xFFF59E0B);
    const Color colorInterview = Color(0xFF3B82F6);
    const Color colorOffer = Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
                  const Text(
                    "Applicant Pipeline",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$total active candidates",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // ប៊ូតុង Details
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.barChart2,
                      size: 16,
                      color: Color(0xFF4F7DF7),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4F7DF7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── ផ្នែកទី ២៖ របារពណ៌ Dynamic Progress Bar ──
          Row(
            children: [
              if (total == 0)
                Expanded(child: _buildSegment(Colors.grey.shade200))
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

          // ── ផ្នែកទី ៣៖ តួលេខលម្អិត (Legend Grid) ──
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildLegendItem(
                      "Screening",
                      screening,
                      colorScreening,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildLegendItem("Review", review, colorReview),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildLegendItem(
                      "Interview",
                      interview,
                      colorInterview,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: _buildLegendItem("Offer", offer, colorOffer)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // អនុគមន៍គូររបារពណ៌កាត់កង់ៗ
  Widget _buildSegment(Color color) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  // អនុគមន៍គូរអក្សរ និងតួលេខ
  Widget _buildLegendItem(String title, int value, Color color) {
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        const Spacer(),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
