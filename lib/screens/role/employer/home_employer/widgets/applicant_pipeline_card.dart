import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 បន្ថែម GetX សម្រាប់រត់ទៅ Tab
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
// 🟢 Import Controller ដែលពាក់ព័ន្ធ (សូមប្រាកដថា Path ត្រឹមត្រូវតាម Project របស់អ្នក)
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// ចាំអភិវឌ្ឍមុខងារ Kanban Board ថ្ងៃក្រោយ
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

              // 🟢 ប៊ូតុង Details (ធ្វើឱ្យចុចបាន លោតទៅ Tab: All)
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── ផ្នែកទី ២៖ របារពណ៌ Dynamic Progress Bar (រក្សាទុកដដែល) ──[cite: 19]
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

          // ── ផ្នែកទី ៣៖ តួលេខលម្អិត (Legend Grid ដែលអាចចុចបាន) ──
          Column(
            children: [
              Row(
                children: [
                  // 🟢 ភ្ជាប់ Screening ទៅ pending
                  Expanded(
                    child: _buildLegendItem(
                      "Screening",
                      screening,
                      colorScreening,
                      'pending',
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 🟢 ភ្ជាប់ Review ទៅ shortlisted
                  Expanded(
                    child: _buildLegendItem(
                      "Review",
                      review,
                      colorReview,
                      'shortlisted',
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  // 🟢 ភ្ជាប់ Interview ទៅ interview
                  Expanded(
                    child: _buildLegendItem(
                      "Interview",
                      interview,
                      colorInterview,
                      'interview',
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 🟢 ភ្ជាប់ Offer ទៅ hired
                  Expanded(
                    child: _buildLegendItem(
                      "Offer",
                      offer,
                      colorOffer,
                      'hired',
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

  // អនុគមន៍គូររបារពណ៌កាត់កង់ៗ[cite: 19]
  Widget _buildSegment(Color color) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  // 🟢 អនុគមន៍គូរអក្សរ និងតួលេខ ធ្វើឱ្យអាចចុចបាន
  Widget _buildLegendItem(
    String title,
    int value,
    Color color,
    String targetStatus,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _goToCandidatesTab(targetStatus),
        borderRadius: BorderRadius.circular(8),
        splashColor: color.withValues(
          alpha: 0.1,
        ), // ពណ៌ Splash ស្រាលៗតាមពណ៌របស់វា
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 4.0,
          ), // បន្ថែម Padding ងាយស្រួលចុច
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
          ),
        ),
      ),
    );
  }

  // 🎯 អនុគមន៍ជំនួយសម្រាប់រត់ទៅកាន់ Candidates Tab រួចកំណត់ Status
  void _goToCandidatesTab(String targetStatus) {
    // ១. ប្តូរ Tab ខាងក្រោម (Bottom Nav Bar) ទៅកាន់ Candidates (Index 2)
    if (Get.isRegistered<MainScreenEmloyerController>()) {
      Get.find<MainScreenEmloyerController>().changeTab(2);
    }

    // ២. បញ្ជាឱ្យ Candidates Controller ប្តូរ Tab Status
    if (Get.isRegistered<CandidatesViewController>()) {
      final candidateCtrl = Get.find<CandidatesViewController>();

      // ផ្តាច់ (Clear) ការ Filter តាមការងារ (Job) ដើម្បីមើលបេក្ខជនទាំងអស់
      candidateCtrl.selectedJobId.value = 'all';

      // រកទីតាំង Index របស់ Tab គោលដៅ
      int targetIndex = candidateCtrl.tabs.indexOf(targetStatus);
      if (targetIndex == -1) targetIndex = 0;

      // បញ្ជាឱ្យ TabController រំកិលទៅ Tab នោះ
      candidateCtrl.tabController.animateTo(targetIndex);

      // ហៅមុខងារទាញយកទិន្នន័យសាជាថ្មី
      candidateCtrl.fetchApplicants(isRefresh: true);
      candidateCtrl.fetchStatusSummary();
    }
  }
}
