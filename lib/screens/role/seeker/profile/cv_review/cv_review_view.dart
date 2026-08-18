import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/cv_parsed_data_model.dart';

import '../../../../../widgets/custom_textfield.dart';

part 'cv_review_binding.dart';
part 'cv_review_controller.dart';

class CvReviewView extends GetView<CvReviewViewController> {
  const CvReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.textTheme.bodyLarge?.color,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Review Extracted Data'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          'Personal Information'.tr, // 🟢 Added .tr
                          icon: Icons.person_outline,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        _buildPersonalInfoForm(),
                        const SizedBox(height: 32),

                        _buildSectionHeader(
                          'Skills'.tr, // 🟢 Added .tr
                          icon: Icons.bolt_outlined,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        _buildSkillsSection(isDark),
                        const SizedBox(height: 32),

                        _buildSectionHeaderWithAdd(
                          title: 'Work Experiences'.tr, // 🟢 Added .tr
                          icon: Icons.work_outline,
                          isDark: isDark,
                          onAdd: () {},
                        ),
                        const SizedBox(height: 16),
                        _buildExperiencesList(isDark),
                        const SizedBox(height: 32),

                        _buildSectionHeaderWithAdd(
                          title: 'Educations'.tr, // 🟢 Added .tr
                          icon: Icons.school_outlined,
                          isDark: isDark,
                          onAdd: () {},
                        ),
                        const SizedBox(height: 16),
                        _buildEducationsList(isDark),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                _buildBottomSaveButton(theme, isDark),
              ],
            ),

            if (controller.isLoading.value)
              Container(
                color: Colors.black.withValues(
                  alpha: 0.3,
                ), // 🟢 Updated opacity
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    required IconData icon,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeaderWithAdd({
    required String title,
    required IconData icon,
    required bool isDark,
    required VoidCallback onAdd,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionHeader(title, icon: icon, isDark: isDark),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(
            Icons.add_circle_outline,
            size: 20,
            color: AppColors.primary,
          ),
          label: Text(
            'Add'.tr, // 🟢 Added .tr
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextfield(
                hintText: 'First Name'.tr, // 🟢 Added .tr
                controller: controller.firstNameCtrl,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextfield(
                hintText: 'Last Name'.tr, // 🟢 Added .tr
                controller: controller.lastNameCtrl,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          hintText: 'Email'.tr, // 🟢 Added .tr
          controller: controller.emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          hintText: 'Phone Number'.tr, // 🟢 Added .tr
          controller: controller.phoneCtrl,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          hintText: 'Biography'.tr, // 🟢 Added .tr
          controller: controller.bioCtrl,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSkillsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextfield(
                hintText: 'e.g. Flutter, Python...'.tr, // 🟢 Added .tr
                controller: controller.skillInputCtrl,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => controller.addSkill(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.skills.isEmpty) {
            return Text(
              'No skills extracted.'.tr, // 🟢 Added .tr
              style: TextStyle(
                color: isDark ? AppColors.darkTextHint : Colors.grey.shade500,
              ),
            );
          }
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: controller.skills.map((skill) {
              return Chip(
                label: Text(
                  skill,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : AppColors.primaryDark,
                  ),
                ),
                backgroundColor: isDark
                    ? AppColors.primary.withValues(
                        alpha: 0.2,
                      ) // 🟢 Updated opacity
                    : AppColors.primaryLight.withValues(
                        alpha: 0.3,
                      ), // 🟢 Updated opacity
                deleteIcon: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.redAccent,
                ),
                onDeleted: () => controller.removeSkill(skill),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide.none,
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildExperiencesList(bool isDark) {
    return Obx(() {
      if (controller.experiences.isEmpty) {
        return _buildEmptyState(
          'No work experience found.'.tr,
          isDark,
        ); // 🟢 Added .tr
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.experiences.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final exp = controller.experiences[index];
          return _buildInfoCard(
            title: exp.jobTitle ?? 'Unknown Title'.tr, // 🟢 Added .tr
            subtitle: exp.companyName ?? 'Unknown Company'.tr, // 🟢 Added .tr
            dateText:
                '${exp.startDate ?? 'N/A'} - ${exp.endDate ?? 'Present'.tr}', // 🟢 Added .tr
            isDark: isDark,
            onEdit: () {},
            onDelete: () => controller.removeExperience(index),
          );
        },
      );
    });
  }

  Widget _buildEducationsList(bool isDark) {
    return Obx(() {
      if (controller.educations.isEmpty) {
        return _buildEmptyState(
          'No education history found.'.tr,
          isDark,
        ); // 🟢 Added .tr
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.educations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final edu = controller.educations[index];
          return _buildInfoCard(
            title: edu.schoolName ?? 'Unknown School'.tr, // 🟢 Added .tr
            subtitle: edu.degree ?? 'Unknown Degree'.tr, // 🟢 Added .tr
            dateText:
                '${edu.startDate ?? 'N/A'} - ${edu.endDate ?? 'Present'.tr}', // 🟢 Added .tr
            isDark: isDark,
            onEdit: () {},
            onDelete: () => controller.removeEducation(index),
          );
        },
      );
    });
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required String dateText,
    required bool isDark,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateText,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: isDark ? AppColors.primary : Colors.blueAccent,
                  size: 20,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: isDark ? AppColors.darkTextHint : Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSaveButton(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.05,
            ), // 🟢 Updated opacity
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.saveReviewedData(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            'Save & Update Profile'.tr, // 🟢 Added .tr
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
