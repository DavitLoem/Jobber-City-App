import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/profile_crud_service.dart';
import 'package:jobber_city/models/role/seeker/profile_model.dart';
import 'package:jobber_city/screens/role/seeker/profile/profile_screen/profile_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/sub_profile/language/language_form_view.dart';

import '../../../../../../widgets/custom_confirm_dialog.dart';
import '../widgets/custom_info_card.dart';

part 'language_binding.dart';
part 'language_controller.dart';

class LanguageView extends GetView<LanguageViewController> {
  const LanguageView({super.key});

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
          'Languages',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }

        if (controller.languageList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.language_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No languages added yet.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.languageList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final lang = controller.languageList[index];

            return CustomInfoCard(
              title: lang.language,
              subtitle: 'Proficiency: ${lang.proficiency}',
              dateText: '', // ទុកទទេ ព្រោះ Language អត់មានថ្ងៃខែ
              onEdit: () {
                controller.populateForm(lang);
                Get.to(() => const LanguageFormView());
              },
              onDelete: () {
                Get.dialog(
                  CustomConfirmDialog(
                    title: 'Delete Language',
                    description:
                        'Are you sure you want to delete this language?',
                    onConfirm: () {
                      if (lang.id != null) controller.deleteLanguage(lang.id!);
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
            controller.clearForm();
            Get.to(() => const LanguageFormView());
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
            'Add Language',
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
