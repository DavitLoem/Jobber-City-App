import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_profile_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/seeker_profile_model.dart';
import 'package:jobber_city/screens/role/seeker/profile/profile_screen/profile_screen_view.dart';

part 'skills_binding.dart';
part 'skills_controller.dart';

class SkillsView extends GetView<SkillsViewController> {
  const SkillsView({super.key});

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
          'Skills'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add your skills'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add skills that highlight your expertise.'.tr, // 🟢 Added .tr
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: controller.skillInputCtrl,
              onSubmitted: (_) => controller.addSkill(),
              style: TextStyle(
                color: isDark ? AppColors.darkInputText : AppColors.inputText,
              ),
              decoration: InputDecoration(
                hintText:
                    'e.g., Flutter, Problem Solving...'.tr, // 🟢 Added .tr
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkInputBackground
                    : AppColors.inputBackground,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                  onPressed: () => controller.addSkill(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.primary
                        : AppColors.inputFocusedBorder,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                  () => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: controller.skillsList.map((skill) {
                      return Chip(
                        label: Text(
                          skill,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white
                                : AppColors.primaryDark,
                          ),
                        ),
                        backgroundColor: isDark
                            ? AppColors.primary.withValues(
                                alpha: 0.2,
                              ) // 🟢 Updated opacity
                            : AppColors.primaryLight,
                        side: BorderSide.none,
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.error,
                        ),
                        onDeleted: () => controller.removeSkill(skill),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isSaving.value
                  ? null
                  : () => controller.saveSkills(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: isDark
                    ? AppColors.darkSurfaceElevated
                    : Colors.grey.shade300,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: controller.isSaving.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Save Skills'.tr, // 🟢 Added .tr
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
