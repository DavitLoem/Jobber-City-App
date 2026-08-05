import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/core/api/services/role/seeker/profile_crud_service.dart';
import 'package:jobber_city/screens/role/seeker/profile/profile_screen/profile_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/sub_profile/education/education_form_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/sub_profile/widgets/custom_info_card.dart';
import 'package:jobber_city/widgets/custom_confirm_dialog.dart';

import '../../../../../../models/role/seeker/profile_model.dart';

part 'education_binding.dart';
part 'education_controller.dart';

class EducationView extends GetView<EducationViewController> {
  const EducationView({super.key});

  // 🎯 មុខងារជំនួយសម្រាប់ Format Date បង្ហាញលើកាត
  String _formatDateForDisplay(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'Present'; // បើអត់មាន End Date ដាក់ Present
    }
    try {
      final DateTime parsed = DateTime.parse(dateStr);
      return DateFormat('MMM yyyy').format(parsed);
    } catch (e) {
      return dateStr.split('T').first;
    }
  }

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
          'Education Background',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // 🎯 រុំដោយ Obx ទីនេះ
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }

        if (controller.educationList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No education background added yet.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.educationList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final edu = controller.educationList[index];

            final startDate = _formatDateForDisplay(edu.startDate);
            final endDate = _formatDateForDisplay(edu.endDate);

            return CustomInfoCard(
              title: edu.schoolName,
              // ផ្គុំ Degree និង Field of Study បញ្ចូលគ្នា
              subtitle: edu.fieldOfStudy != null && edu.fieldOfStudy!.isNotEmpty
                  ? '${edu.degree} in ${edu.fieldOfStudy}'
                  : edu.degree,
              dateText: '$startDate - $endDate',
              onEdit: () {
                // 🎯 បញ្ចូលទិន្នន័យចាស់ទៅ Form មុននឹងបើក
                controller.populateForm(edu);
                Get.to(() => const EducationFormView());
              },
              onDelete: () {
                Get.dialog(
                  CustomConfirmDialog(
                    title: 'Delete Education',
                    description:
                        'Are you sure you want to delete this education background? This action cannot be undone.',
                    onConfirm: () {
                      if (edu.id != null) {
                        controller.deleteEducation(edu.id!);
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
            // 🎯 Clear Form ឱ្យទទេស្អាតមុននឹង Add ថ្មី
            controller.clearForm();
            Get.to(() => const EducationFormView());
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
            'Add Education',
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
