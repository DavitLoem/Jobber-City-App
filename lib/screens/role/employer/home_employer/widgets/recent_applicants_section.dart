import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/models/role/employer/employer_dashboard_model.dart';
// 🟢 Import Controller ដែលពាក់ព័ន្ធ
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';

import '../../../../../routes/app_routes.dart';

class RecentApplicantsSection extends StatelessWidget {
  // 🟢 ទទួលយក List នៃទិន្នន័យពិតពី View
  final List<RecentApplicantModel> applicants;

  const RecentApplicantsSection({super.key, required this.applicants});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Applicants",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                letterSpacing: -0.3,
              ),
            ),
            // 🟢 ប៊ូតុង View all លោតទៅកាន់ Tab Candidates
            InkWell(
              onTap: () {
                if (Get.isRegistered<MainScreenEmloyerController>()) {
                  Get.find<MainScreenEmloyerController>().changeTab(
                    2,
                  ); // Index 2 គឺ Candidates
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: const [
                    Text(
                      "View all",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F7DF7),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Color(0xFF4F7DF7),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 🟢 បង្ហាញ UI ពេលគ្មានបេក្ខជនសោះ (Empty State)
        if (applicants.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.person_search_rounded,
                  size: 48,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                Text(
                  "No recent applicants yet",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          // 🟢 គូរ List បេក្ខជនពីទិន្នន័យពិត
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: applicants.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = applicants[index];
              return _buildApplicantCard(data);
            },
          ),
      ],
    );
  }

  // ── អនុគមន៍សម្រាប់គូរកាតបេក្ខជននីមួយៗ ──
  Widget _buildApplicantCard(RecentApplicantModel applicant) {
    // 🟢 កំណត់ពណ៌តាមស្ថានភាព (Status)
    Color statusBgColor = const Color(0xFFF1F5F9);
    Color statusTextColor = const Color(0xFF64748B);

    final statusLower = applicant.status.toLowerCase();
    if (statusLower == 'interview') {
      statusBgColor = const Color(0xFFEEF2FF);
      statusTextColor = const Color(0xFF4F7DF7);
    } else if (statusLower == 'shortlisted' || statusLower == 'review') {
      statusBgColor = const Color(0xFFFFFBEB);
      statusTextColor = const Color(0xFFD97706);
    } else if (statusLower == 'hired' || statusLower == 'offer') {
      statusBgColor = const Color(0xFFECFDF5);
      statusTextColor = const Color(0xFF10B981);
    } else if (statusLower == 'rejected') {
      statusBgColor = const Color(0xFFFEF2F2);
      statusTextColor = const Color(0xFFEF4444);
    }

    // 🟢 កំណត់អក្សរកាត់ (Initials) ចេញពីឈ្មោះ
    String initials = "U";
    if (applicant.name.isNotEmpty) {
      final nameParts = applicant.name.trim().split(" ");
      if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
        initials = "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase();
      } else {
        initials = nameParts[0][0].toUpperCase();
      }
    }

    // 🟢 កំណត់ថ្ងៃខែ (Format)
    String dateStr = "Recently";
    if (applicant.appliedAt != null) {
      dateStr =
          "${applicant.appliedAt!.day}/${applicant.appliedAt!.month}/${applicant.appliedAt!.year}";
    }

    // រុំ Material និង InkWell ដើម្បីអាចចុចបាន
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                // ផ្នែកទី ១៖ រូប Avatar ឬ អក្សរកាត់
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F7DF7),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F7DF7).withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    // បើមានរូបភាព ប្រើរូបភាពជំនួស
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

                // ផ្នែកទី ២៖ ឈ្មោះ និង តំណែង
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        applicant.jobTitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // ផ្នែកទី ៣៖ ស្លាកស្ថានភាព (លុប Rating ចេញ)
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
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        applicant.status.capitalizeFirst ?? applicant.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: statusTextColor,
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
