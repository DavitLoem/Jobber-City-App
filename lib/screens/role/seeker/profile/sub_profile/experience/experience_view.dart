import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/core/api/services/role/seeker/profile_crud_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/widgets/custom_confirm_dialog.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../../models/role/seeker/profile_model.dart';
import '../../profile_screen/profile_screen_view.dart';
import '../widgets/custom_info_card.dart';
import 'experience_form_view.dart';

part 'experience_binding.dart';
part 'experience_controller.dart';

class ExperienceView extends GetView<ExperienceViewController> {
  const ExperienceView({super.key});

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
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Work Experience'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.experienceList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_off_outlined,
                  size: 64,
                  color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No work experience added yet.'.tr, // 🟢 Added .tr
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.experienceList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final exp = controller.experienceList[index];

            final startDate = _formatDateForDisplay(exp.startDate);
            final endDate = exp.isCurrentJob
                ? 'Present'
                      .tr // 🟢 Added .tr
                : _formatDateForDisplay(exp.endDate);

            return CustomInfoCard(
              title: exp.jobTitle,
              subtitle: exp.companyName,
              dateText: '$startDate - $endDate',
              onEdit: () {
                controller.populateForm(exp);
                Get.to(() => const ExperienceFormView());
              },
              onDelete: () {
                Get.dialog(
                  CustomConfirmDialog(
                    title: 'Delete Experience'.tr, // 🟢 Added .tr
                    description:
                        'Are you sure you want to delete this work experience? This action cannot be undone.'
                            .tr, // 🟢 Added .tr
                    icon: LucideIcons.trash2,
                    onConfirm: () {
                      if (exp.id != null) {
                        controller.deleteExperience(exp.id!);
                      }
                    },
                  ),
                  barrierDismissible: true,
                );
              },
            );
          },
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.3 : 0.05,
              ), // 🟢 Updated Opacity
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            controller.clearForm();
            Get.to(() => const ExperienceFormView());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            'Add Experience'.tr, // 🟢 Added .tr
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

  String _formatDateForDisplay(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final DateTime parsed = DateTime.parse(dateStr);
      return DateFormat('MMM yyyy').format(parsed);
    } catch (e) {
      return dateStr.split('T').first;
    }
  }
}
