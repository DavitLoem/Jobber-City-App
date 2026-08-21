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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Review Extracted Data',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
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
                          'Personal Information',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildPersonalInfoForm(),
                        const SizedBox(height: 32),

                        // ២. ផ្នែក Skills
                        _buildSectionHeader(
                          'Skills',
                          icon: Icons.bolt_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildSkillsSection(),
                        const SizedBox(height: 32),

                        // ៣. ផ្នែក Experiences
                        _buildSectionHeaderWithAdd(
                          title: 'Work Experiences',
                          icon: Icons.work_outline,
                          onAdd: () {
                            // TODO: បើក BottomSheet ឬ Page ថ្មីដើម្បីថែមបទពិសោធន៍
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildExperiencesList(),
                        const SizedBox(height: 32),

                        // ៤. ផ្នែក Educations
                        _buildSectionHeaderWithAdd(
                          title: 'Educations',
                          icon: Icons.school_outlined,
                          onAdd: () {
                            // TODO: បើក BottomSheet ឬ Page ថ្មីដើម្បីថែមការសិក្សា
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildEducationsList(),
                        const SizedBox(height: 40), // ទុកចន្លោះខាងក្រោមបន្តិច
                      ],
                    ),
                  ),
                ),

                // ── ប៊ូតុង Save នៅខាងក្រោមជាប់ជានិច្ច ──
                _buildBottomSaveButton(),
              ],
            ),

            // ── Loading Overlay ពេលកំពុង Save ──
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
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

  Widget _buildSectionHeader(String title, {required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeaderWithAdd({
    required String title,
    required IconData icon,
    required VoidCallback onAdd,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionHeader(title, icon: icon),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(
            Icons.add_circle_outline,
            size: 20,
            color: AppColors.primary,
          ),
          label: const Text(
            'Add',
            style: TextStyle(
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
                hintText: 'First Name',
                controller: controller.firstNameCtrl,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextfield(
                hintText: 'Last Name',
                controller: controller.lastNameCtrl,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          hintText: 'Email',
          controller: controller.emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          hintText: 'Phone Number',
          controller: controller.phoneCtrl,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          hintText: 'Biography',
          controller: controller.bioCtrl,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ប្រអប់វាយបញ្ចូល Skill ថ្មី
        Row(
          children: [
            Expanded(
              child: CustomTextfield(
                hintText: 'e.g. Flutter, Python...',
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
        // បង្ហាញជំនាញដែលមានស្រាប់ជា Chips
        Obx(() {
          if (controller.skills.isEmpty) {
            return Text(
              'No skills extracted.',
              style: TextStyle(color: Colors.grey.shade500),
            );
          }
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: controller.skills.map((skill) {
              return Chip(
                label: Text(
                  skill,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.3),

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

  Widget _buildExperiencesList() {
    return Obx(() {
      if (controller.experiences.isEmpty) {
        return _buildEmptyState('No work experience found.');
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.experiences.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final exp = controller.experiences[index];
          return _buildInfoCard(
            title: exp.jobTitle ?? 'Unknown Title',
            subtitle: exp.companyName ?? 'Unknown Company',
            dateText: '${exp.startDate ?? 'N/A'} - ${exp.endDate ?? 'Present'}',
            onEdit: () {
              // បើក BottomSheet ឱ្យកែប្រែ
            },
            onDelete: () => controller.removeExperience(index),
          );
        },
      );
    });
  }

  Widget _buildEducationsList() {
    return Obx(() {
      if (controller.educations.isEmpty) {
        return _buildEmptyState('No education history found.');
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.educations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final edu = controller.educations[index];
          return _buildInfoCard(
            title: edu.schoolName ?? 'Unknown School',
            subtitle: edu.degree ?? 'Unknown Degree',
            dateText: '${edu.startDate ?? 'N/A'} - ${edu.endDate ?? 'Present'}',
            onEdit: () {
              // TODO: បើក BottomSheet ឱ្យកែប្រែ
            },
            onDelete: () => controller.removeEducation(index),
          );
        },
      );
    });
  }

  // Card សម្រាប់បង្ហាញទាំង Experience និង Education
  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required String dateText,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
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

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSaveButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
          child: const Text(
            'Save & Update Profile',
            style: TextStyle(
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
