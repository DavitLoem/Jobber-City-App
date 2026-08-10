import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../candidates_view.dart';

class JobFilterDropdown extends GetView<CandidatesViewController> {
  const JobFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: InkWell(
        onTap: () =>
            _showJobBottomSheet(context), // 🎯 ចុចដើម្បីបើក Bottom Sheet
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.briefcase,
                size: 20,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => Text(
                    controller
                        .selectedJobDisplayName, // 🟢 បង្ហាញឈ្មោះដែលបានរើសពី Controller
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Icon(
                LucideIcons.chevronDown,
                size: 20,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🎯 អនុគមន៍សម្រាប់គូរផ្ទាំង Bottom Sheet
  void _showJobBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height:
            MediaQuery.of(context).size.height *
            0.65, // កំណត់កម្ពស់ 65% នៃអេក្រង់
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Job Post",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.black54,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            // ── បញ្ជីការងារ ──
            Expanded(
              child: Obx(() {
                // ពេលកំពុង Load API
                if (controller.isJobsLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    // 🟢 ជម្រើស "All Jobs" នៅលើគេជានិច្ច
                    _buildJobTile(
                      jobId: 'all',
                      displayName: 'All Jobs',
                      status: 'active',
                      isSelected:
                          controller.selectedJobId.value == 'all' ||
                          controller.selectedJobId.value.isEmpty,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),

                    // 🟢 បញ្ជីការងារពិតប្រាកដដែលទាញពី Backend
                    ...controller.postedJobs.map((job) {
                      return _buildJobTile(
                        jobId: job.jobId,
                        displayName: job.displayName,
                        status: job.status,
                        isSelected: controller.selectedJobId.value == job.jobId,
                      );
                    }),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true, // អនុញ្ញាតឱ្យ Bottom Sheet ឡើងខ្ពស់បាន
      backgroundColor: Colors.transparent,
    );
  }

  // 🎯 អនុគមន៍គូរ Item នីមួយៗក្នុងបញ្ជី
  Widget _buildJobTile({
    required String jobId,
    required String displayName,
    required String status,
    required bool isSelected,
  }) {
    final bool isClosed = status.toLowerCase() != 'active' && jobId != 'all';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      tileColor: isSelected
          ? const Color(0xFF4f7df7).withValues(alpha: 0.05)
          : Colors.transparent,
      title: Text(
        displayName,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isClosed
              ? Colors.grey.shade500
              : (isSelected ? const Color(0xFF4f7df7) : Colors.black87),
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: Color(0xFF4f7df7))
          : null,
      onTap: () {
        Get.back(); // បិទ Bottom Sheet សិន
        if (controller.selectedJobId.value != jobId) {
          controller.selectedJobId.value = jobId;
          controller.fetchApplicants(); // ហៅ API ទាញបេក្ខជនសារថ្មី
        }
      },
    );
  }
}
