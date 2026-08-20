import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/models/role/employer/employer_dashboard_model.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../candidates/candidates_view.dart';

// 🟢 ត្រូវប្រាកដថាបាន Import Controllers ទាំងនេះ (សូមកែប្រែ Path ឱ្យត្រូវនឹង Project អ្នក)
// import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';
// import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart'; // ទីតាំង CandidatesViewController

class StatItem {
  final String label;
  final String value;
  final String delta;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap; // 🟢 ១. បន្ថែមអថេរ onTap សម្រាប់ទទួលការចុច

  const StatItem({
    required this.label,
    required this.value,
    required this.delta,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}

class StatsGrid extends StatelessWidget {
  final OverviewStatsModel? overview;

  const StatsGrid({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    final List<StatItem> dynamicStats = [
      StatItem(
        label: "Jobs Posted",
        value: overview?.jobsPosted.toString() ?? "0",
        delta: overview?.jobsPostedTrend ?? "0",
        icon: LucideIcons.briefcase,
        gradient: const [Color(0xFF4F7DF7), Color(0xFF78A8FF)],
        onTap: () {
          // 🟢 គោលដៅទី ១: ទៅកាន់ Tab My Jobs (Index 1)
          if (Get.isRegistered<MainScreenEmloyerController>()) {
            Get.find<MainScreenEmloyerController>().changeTab(1);
          }
        },
      ),
      StatItem(
        label: "Total Applications",
        value: overview?.totalApplications.toString() ?? "0",
        delta: overview?.applicationsTrend ?? "0",
        icon: LucideIcons.users,
        gradient: const [Color(0xFF8B5CF6), Color(0xFFC4B5FD)],
        onTap: () {
          // 🟢 គោលដៅទី ២: ទៅកាន់ Tab Candidates -> All
          _goToCandidatesTab('all');
        },
      ),
      StatItem(
        label: "Interviews",
        value: overview?.interviews.toString() ?? "0",
        delta: overview?.interviewsTrend ?? "0",
        icon: LucideIcons.checkCircle,
        gradient: const [Color(0xFF22C55E), Color(0xFF86EFAC)],
        onTap: () {
          // 🟢 គោលដៅទី ៣: ទៅកាន់ Tab Candidates -> Interview
          _goToCandidatesTab('interview');
        },
      ),
      StatItem(
        label: "Hired",
        value: overview?.hired.toString() ?? "0",
        delta: overview?.hiredTrend ?? "0",
        icon: LucideIcons.trendingUp,
        gradient: const [Color(0xFFF59E0B), Color(0xFFFCD34D)],
        onTap: () {
          // 🟢 គោលដៅទី ៤: ទៅកាន់ Tab Candidates -> Hired / Offer
          _goToCandidatesTab('hired');
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dynamicStats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) => _StatCard(stat: dynamicStats[index]),
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
      candidateCtrl.selectedJobId.value =
          'all'; // 🟢 កែពី '' ទៅ 'all' តាមទម្រង់របស់ Controller

      // ៣. រកទីតាំង Index របស់ Tab គោលដៅ
      int targetIndex = candidateCtrl.tabs.indexOf(targetStatus);

      // ប្រសិនបើរាវរកមិនឃើញ (ការពារ Error) គឺឱ្យវារត់ទៅ 'all' (Index 0)
      if (targetIndex == -1) {
        targetIndex = 0;
      }

      // ៤. បញ្ជាឱ្យ TabController រំកិលទៅ Tab នោះ
      candidateCtrl.tabController.animateTo(targetIndex);

      // ៥. ហៅមុខងារទាញយកទិន្នន័យសាជាថ្មី (ព្រោះប្តូរពីការងារមួយទៅទាំងអស់)
      candidateCtrl.fetchApplicants(isRefresh: true);
      candidateCtrl.fetchStatusSummary();
    }
  }
}

class _StatCard extends StatelessWidget {
  final StatItem stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final isNegative = stat.delta.contains('-');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: stat.gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // 🟢 ២. រុំជាមួយ Material និង InkWell ឱ្យវាមាន Ripple Effect ពេលចុច
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: stat.onTap, // 🟢 ហៅមុខងារ onTap ទីនេះ
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      top: 16.0,
                      bottom: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Icon(stat.icon, size: 18, color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          stat.value,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.8,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 12,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 80),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isNegative
                            ? Colors.red.withValues(alpha: 0.8)
                            : Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        stat.delta,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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
}
