import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../controllers/category_controller.dart';
import '../../../../controllers/location_controller.dart';
import '../../../../controllers/master_data_controller.dart';
import '../../../../core/api/services/role/employer/job_service.dart';
import '../../../../models/role/employer/company_model.dart';
import '../../../../models/role/employer/job_model.dart';
import '../employer_profile/employer_profile_view.dart';

part 'my_job_detail_binding.dart';
part 'my_job_detail_controller.dart';

class MyJobDetailView extends GetView<MyJobDetailViewController> {
  const MyJobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.edit, color: Colors.black87),
            onPressed: () {
              // Get.toNamed(
              //   AppRoutes.newJob,
              //   arguments: controller.jobData.value,
              // );
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.share2, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),

      // 🎯 រុំ Body ជាមួយ Obx ដើម្បីស្តាប់ការផ្លាស់ប្តូរ State (Loading & Data)
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4f7df7)),
          );
        }

        final job = controller.jobData.value;

        if (job == null) {
          return const Center(
            child: Text("Job details not found or failed to load."),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── ១. Header ──
                  _buildHeader(job.title, job.status),
                  const SizedBox(height: 24),

                  // ── ២. Tags & Highlights ──
                  _buildTagsSection(job),
                  const SizedBox(height: 24),

                  // ── ៣. ព័ត៌មានការងារ ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          LucideIcons.calendarDays,
                          "Working Days",
                          job.workingDays,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          LucideIcons.clock,
                          "Working Hours",
                          job.workingHours,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          LucideIcons.users,
                          "Headcount",
                          "${job.headcount} Positions",
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          LucideIcons.calendarX,
                          "Closing Date",
                          // បំប្លែង Date វែងៗយកតែ ឆ្នាំ-ខែ-ថ្ងៃ
                          job.closingDate.toString().split('T').first,
                          isUrgent: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                  const SizedBox(height: 20),

                  // ── ៤. អត្ថបទពិពណ៌នា (ប្រើប្រាស់ Array ពី JSON) ──
                  if (job.description.isNotEmpty) ...[
                    _buildSectionTitle("Job Description"),
                    const SizedBox(height: 12),
                    ...job.description.map((desc) => _buildBulletPoint(desc)),
                    const SizedBox(height: 24),
                  ],

                  if (job.requirements.isNotEmpty) ...[
                    _buildSectionTitle("Requirements"),
                    const SizedBox(height: 12),
                    ...job.requirements.map((req) => _buildBulletPoint(req)),
                    const SizedBox(height: 24),
                  ],

                  if (job.benefits.isNotEmpty) ...[
                    _buildSectionTitle("Benefits"),
                    const SizedBox(height: 12),
                    ...job.benefits.map((ben) => _buildBulletPoint(ben)),
                    const SizedBox(height: 24),
                  ],

                  if ((job.requiredSkills.isNotEmpty) ||
                      (job.customSkills.isNotEmpty)) ...[
                    _buildSectionTitle("Required Skills"),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...job.requiredSkills.map(
                          (skill) =>
                              _buildSkillChip(controller.getSkillName(skill)),
                        ),
                        ...job.customSkills.map(
                          (skill) => _buildSkillChip(skill),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),

            // ── ៥. Bottom Bar ──
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            controller.updateJobStatus('closed');
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Close Job",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF4f7df7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "View Applicants",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ==========================================
  // ── Helper Widgets ──
  // ==========================================

  // 🎯 បន្ថែម Parameter ឱ្យវាទទួល Data ពី Controller
  Widget _buildHeader(String? title, String? status) {
    // កំណត់ពណ៌ Status ទៅតាមពាក្យ
    final isClosed = status?.toLowerCase() == 'closed';
    final statusColor = isClosed ? Colors.red : Colors.green;
    final statusBgColor = isClosed ? Colors.red.shade50 : Colors.green.shade50;

    final profileCtrl = Get.find<EmployerProfileViewController>();
    final profile = profileCtrl.companyProfile.value;
    final hasLogo =
        profile != null &&
        profile.logoUrl != null &&
        profile.logoUrl!.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: hasLogo
                ? Image.network(
                    profile.logoUrl!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  )
                : Icon(LucideIcons.building, size: 32, color: statusColor),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "Untitled Job",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status?.toUpperCase() ?? "UNKNOWN",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🎯 ចាប់យក Data មកបង្ហាញក្នុង Tags
  Widget _buildTagsSection(dynamic job) {
    // រៀបចំអត្ថបទប្រាក់ខែ
    String salaryText = "\$${job.minSalary ?? 0} - \$${job.maxSalary ?? 0}";
    if (job.salaryPeriod != null) salaryText += " / ${job.salaryPeriod}";
    if (job.isNegotiable == true) salaryText += " (Negotiable)";

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildTag(
          LucideIcons.grid,
          controller.getCategoryName(),
          const Color(0xFFF3E8FF),
          const Color(0xFF8B5CF6),
        ),
        _buildTag(
          LucideIcons.dollarSign,
          salaryText,
          const Color(0xFFE8FDF3),
          const Color(0xFF0F9D58),
        ),
        _buildTag(
          LucideIcons.briefcase,
          controller.getEmploymentTypeName(),
          const Color(0xFFE8F0FE),
          const Color(0xFF4f7df7),
        ),
        _buildTag(
          LucideIcons.graduationCap,
          job.experience ?? "N/A",
          const Color(0xFFFEF3E8),
          const Color(0xFFE37400),
        ),
        _buildTag(
          LucideIcons.mapPin,
          controller.getLocationName(), // ទាញយកទីតាំងពី Controller
          Colors.grey.shade100,
          Colors.grey.shade700,
        ),
      ],
    );
  }

  Widget _buildTag(
    IconData icon,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    if (label.isEmpty)
      return const SizedBox.shrink(); // លាក់បាត់បើគ្មានទិន្នន័យ
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isUrgent = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isUrgent ? Colors.red : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: CircleAvatar(
              radius: 3,
              backgroundColor: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(
        skill,
        style: const TextStyle(fontSize: 13, color: Color(0xFF4f7df7)),
      ),
      backgroundColor: const Color(0xFFF0F4FF),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
