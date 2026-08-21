import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/core/api/services/role/seeker/profile_crud_service.dart';
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
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Work Experience',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // 🎯 ប្រើ Obx ដើម្បីឱ្យបញ្ជីប្រែប្រួលដោយស្វ័យប្រវត្តិពេលទិន្នន័យផ្លាស់ប្តូរ
      body: Obx(() {
        // បង្ហាញ Loading ពេលកំពុងទាញយកទិន្នន័យ
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }

        // បង្ហាញរូបភាព ឬអត្ថបទពេលគ្មានទិន្នន័យ
        if (controller.experienceList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_off_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No work experience added yet.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // បង្ហាញបញ្ជីទិន្នន័យពិតប្រាកដ
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.experienceList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final exp = controller.experienceList[index];

            // រៀបចំទម្រង់កាលបរិច្ឆេទ
            final startDate = _formatDateForDisplay(exp.startDate);
            final endDate = exp.isCurrentJob
                ? 'Present'
                : _formatDateForDisplay(exp.endDate);

            return CustomInfoCard(
              title: exp.jobTitle,
              subtitle: exp.companyName,
              dateText: '$startDate - $endDate',
              onEdit: () {
                // 🎯 មុនពេល Edit ត្រូវបញ្ជូនទិន្នន័យទៅ Form សិន
                controller.populateForm(exp);
                Get.to(() => const ExperienceFormView());
              },
              onDelete: () {
                // 🎯 លោត Dialog សួរ Confirm មុននឹងលុប
                Get.dialog(
                  CustomConfirmDialog(
                    title: 'Delete Experience',
                    description:
                        'Are you sure you want to delete this work experience? This action cannot be undone.',
                    icon: LucideIcons.trash2,
                    onConfirm: () {
                      if (exp.id != null) {
                        controller.deleteExperience(exp.id!);
                      }
                    },
                  ),
                  barrierDismissible:
                      true, // ឱ្យអ្នកប្រើចុចក្រៅ Dialog ដើម្បីបិទបាន
                );
              },
            );
          },
        );
      }),

      // ប៊ូតុង Add New នៅខាងក្រោម
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            // 🎯 មុនពេល Add ត្រូវ Clear Form ឱ្យទទេស្អាតសិន
            controller.clearForm();
            Get.to(() => const ExperienceFormView());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add Experience',
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

  String _formatDateForDisplay(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final DateTime parsed = DateTime.parse(dateStr);
      return DateFormat('MMM yyyy').format(parsed); // ចេញជា: Jan 2020
    } catch (e) {
      return dateStr.split('T').first;
    }
  }
}
