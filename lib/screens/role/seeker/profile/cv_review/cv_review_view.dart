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
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Icon
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Review Extracted Data'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ), // 🟢 Dynamic Text
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Stack(
          children: [
            Column(
              children: [
                // ── ផ្ទៃដែលអាច Scroll បានសម្រាប់ទិន្នន័យ ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ១. ផ្នែក Personal Information
                        _buildSectionHeader(
                          'Personal Information'.tr, // 🟢 Added .tr
                          theme,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildPersonalInfoForm(),
                        const SizedBox(height: 32),

                        // ២. ផ្នែក Skills
                        _buildSectionHeader(
                          'Skills'.tr, // 🟢 Added .tr
                          theme,
                          icon: Icons.bolt_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildSkillsSection(isDark), // 🟢 Pass Theme State
                        const SizedBox(height: 32),

                        // ៣. ផ្នែក Experiences
                        _buildSectionHeaderWithAdd(
                          title: 'Work Experiences'.tr, // 🟢 Added .tr
                          icon: Icons.work_outline,
                          theme: theme,
                          onAdd: () {
                            // TODO: បើក BottomSheet ឬ Page ថ្មីដើម្បីថែមបទពិសោធន៍
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildExperiencesList(theme, isDark),
                        const SizedBox(height: 32),

                        // ៤. ផ្នែក Educations
                        _buildSectionHeaderWithAdd(
                          title: 'Educations'.tr, // 🟢 Added .tr
                          icon: Icons.school_outlined,
                          theme: theme,
                          onAdd: () {
                            // TODO: បើក BottomSheet ឬ Page ថ្មីដើម្បីថែមការសិក្សា
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildEducationsList(theme, isDark),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                // ── ប៊ូតុង Save នៅខាងក្រោមជាប់ជានិច្ច ──
                _buildBottomSaveButton(theme, isDark),
              ],
            ),

            // ── Loading Overlay ពេលកំពុង Save ──
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withValues(
                  alpha: 0.3,
                ), // 🟢 Updated to withValues
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        );
      }),
    );
  }

  // ==========================================
  // 📍 អនុគមន៍ជំនួយសម្រាប់រៀបចំ UI
  // ==========================================

  Widget _buildSectionHeader(
    String title,
    ThemeData theme, {
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 8),
        Text(
          title, // 🟢 Already translated in parent
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text Color
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeaderWithAdd({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required VoidCallback onAdd,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionHeader(title, theme, icon: icon),
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
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade500,
              ), // 🟢 Dynamic Text
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
                    color: isDark
                        ? Colors.blueAccent
                        : AppColors.textPrimary, // 🟢 Dynamic Chip Text
                  ),
                ),
                backgroundColor: isDark
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.primaryLight.withValues(
                        alpha: 0.3,
                      ), // 🟢 Dynamic BG
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

  Widget _buildExperiencesList(ThemeData theme, bool isDark) {
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
            theme: theme, // 🟢 Pass Theme
            isDark: isDark,
            onEdit: () {},
            onDelete: () => controller.removeExperience(index),
          );
        },
      );
    });
  }

  Widget _buildEducationsList(ThemeData theme, bool isDark) {
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
            theme: theme, // 🟢 Pass Theme
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
    required ThemeData theme,
    required bool isDark,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.grey.shade50, // 🟢 Dynamic BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ), // 🟢 Dynamic Border
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
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade700, // 🟢 Dynamic Subtext
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
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.blueAccent,
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
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.grey.shade50, // 🟢 Dynamic BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkCardBorder
              : Colors.grey.shade200, // 🟢 Dynamic Border
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Text(
          message, // 🟢 Already translated
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : Colors.grey.shade500, // 🟢 Dynamic Text
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
        color: theme.cardColor, // 🟢 Dynamic Bottom Container BG
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.05,
            ), // 🟢 Dynamic Shadow
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
            disabledBackgroundColor: isDark
                ? AppColors.darkSurfaceElevated
                : Colors.grey.shade300, // 🟢 Dynamic Disabled BG
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
