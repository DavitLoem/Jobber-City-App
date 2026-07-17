import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'job_detail_screen_controller.dart'; // 🟢 Import Controller ចូលទីនេះ

class JobDetailScreenView extends GetView<JobDetailScreenViewController> {
  const JobDetailScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceVariant,

      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 22,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        actions: [
          Obx(() {
            final isSaved = controller.job.value?.isSaved ?? false;
            return GestureDetector(
              onTap: controller.toggleSaveJob,
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSaved ? AppColors.primaryLight : AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? AppColors.primary : AppColors.iconSecondary,
                  size: 22,
                ),
              ),
            );
          }),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: controller.applyForJob,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buttonPrimaryText,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Obx(() {
        final job = controller.job.value;

        if (job == null) {
          return const Center(
            child: Text(
              "Loading job details...",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        final title = job.title ?? 'Unknown Title';
        final companyName = job.companyName ?? 'Unknown Company';
        final location = job.location ?? 'Location not specified';
        final logoUrl = job.logoUrl ?? '';
        final minSalary = job.minSalary?.toInt() ?? 0;
        final maxSalary = job.maxSalary?.toInt() ?? 0;
        final salaryPeriod = job.salaryPeriod ?? 'Monthly';
        final employmentType = job.employmentType ?? 'Full Time';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(logoUrl, title, companyName, location),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoBox(
                      "Salary",
                      "\$${minSalary} - \$${maxSalary}",
                      "/${salaryPeriod.toLowerCase()}",
                      Icons.attach_money_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoBox(
                      "Job Type",
                      employmentType,
                      "Onsite",
                      Icons.work_outline_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                "Job Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "We are looking for an innovative, dedicated $title to join our growing team. You will be responsible for developing modern applications, collaborating with the UI/UX team, and ensuring top-notch performance. \n\nIf you have a passion for building high-quality software in a fast-paced environment, we would love to meet you!",
                style: const TextStyle(
                  fontSize: 14.5,
                  color: AppColors.textTertiary,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Requirements & Skills",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildRequirementItem(
                "Proven experience working as a $title or similar role.",
              ),
              _buildRequirementItem(
                "Strong proficiency in modern frameworks and architecture.",
              ),
              _buildRequirementItem(
                "Excellent problem-solving skills and attention to detail.",
              ),
              _buildRequirementItem(
                "Ability to work effectively both independently and in a team.",
              ),
              _buildRequirementItem(
                "Good communication skills in English and Khmer.",
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  // ==========================================
  // WIDGETS COMPONENTS
  // ==========================================

  Widget _buildHeaderCard(
    String logoUrl,
    String title,
    String company,
    String location,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: logoUrl.isNotEmpty
                  ? Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildLogoFallback(company),
                    )
                  : _buildLogoFallback(company),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            company,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 16,
                color: AppColors.iconSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(
    String label,
    String value1,
    String value2,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value1,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            value2,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.5,
                color: AppColors.textTertiary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoFallback(String companyName) {
    return Center(
      child: Text(
        companyName.isNotEmpty ? companyName[0].toUpperCase() : 'C',
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 32,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
