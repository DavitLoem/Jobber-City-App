import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/core/api/services/role/seeker/profile_crud_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/profile_model.dart';
import 'package:jobber_city/screens/role/seeker/profile/profile_screen/profile_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/sub_profile/widgets/custom_info_card.dart';
import 'package:jobber_city/widgets/custom_confirm_dialog.dart';

import 'training_form_view.dart';

part 'training_binding.dart';
part 'training_controller.dart';

class TrainingView extends GetView<TrainingViewController> {
  const TrainingView({super.key});

  String _formatDateForDisplay(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Present'.tr; // 🟢 Added .tr
    try {
      return DateFormat('MMM yyyy').format(DateTime.parse(dateStr));
    } catch (e) {
      return dateStr.split('T').first;
    }
  }

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
          'Trainings & Certificates'.tr, // 🟢 Added .tr
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

        if (controller.trainingList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  size: 64,
                  color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No trainings added yet.'.tr, // 🟢 Added .tr
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
          itemCount: controller.trainingList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final training = controller.trainingList[index];
            final startDate = _formatDateForDisplay(training.startDate);
            final endDate = _formatDateForDisplay(training.endDate);

            return CustomInfoCard(
              title: training.courseName,
              subtitle: training.institution,
              dateText: '$startDate - $endDate',
              onEdit: () {
                controller.populateForm(training);
                Get.to(() => const TrainingFormView());
              },
              onDelete: () {
                Get.dialog(
                  CustomConfirmDialog(
                    title: 'Delete Training'.tr, // 🟢 Added .tr
                    description:
                        'Are you sure you want to delete this training?'
                            .tr, // 🟢 Added .tr
                    onConfirm: () {
                      if (training.id != null) {
                        controller.deleteTraining(training.id!);
                      }
                    },
                  ),
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
              ), // 🟢 Updated opacity
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            controller.clearForm();
            Get.to(() => const TrainingFormView());
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
            'Add Training'.tr, // 🟢 Added .tr
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
