import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/cv_generator_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/cv_generator_model.dart';

import 'cv_pdf_view.dart';
import 'widgets/current_cv_banner.dart';
import 'widgets/cv_template_card.dart';

part 'cv_generator_binding.dart';
part 'cv_generator_controller.dart';

class CvGeneratorView extends GetView<CvGeneratorViewController> {
  const CvGeneratorView({super.key});

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
          'Generate CV'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
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

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.currentCv.value?.hasCv == true) ...[
                CurrentCvBanner(
                  cv: controller.currentCv.value!,
                  onView: controller.viewCurrentCv,
                ),
                const SizedBox(height: 24),
              ],

              Text(
                'Choose a template'.tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'We\'ll fill it in automatically using your profile — experience, education, skills, and more.'
                    .tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.grey.shade600, // 🟢 Dynamic Subtext
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              if (controller.templates.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No templates available right now.'.tr, // 🟢 Added .tr
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextHint
                            : Colors.grey.shade500, // 🟢 Dynamic Subtext
                      ),
                    ),
                  ),
                )
              else
                ...controller.templates.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CvTemplateCard(
                      template: t,
                      isSelected: controller.selectedTemplateId.value == t.id,
                      onTap: () => controller.selectedTemplateId.value = t.id,
                    ),
                  ),
                ),

              const SizedBox(height: 12),
              if (controller.profileWarning.value.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.orangeAccent.withValues(alpha: 0.15)
                        : Colors.orange.shade50, // 🟢 Dynamic BG
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.orangeAccent.withValues(alpha: 0.3)
                          : Colors.orange.shade100, // 🟢 Dynamic Border
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: isDark
                            ? Colors.orangeAccent
                            : Colors.orange.shade700, // 🟢 Dynamic Icon
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          controller.profileWarning.value,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark
                                ? Colors.orangeAccent
                                : Colors.orange.shade800, // 🟢 Dynamic Text
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                      controller.selectedTemplateId.value.isEmpty ||
                          controller.isGenerating.value
                      ? null
                      : controller.generateCv,
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
                  child: controller.isGenerating.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          controller.currentCv.value?.hasCv == true
                              ? 'Regenerate CV'
                                    .tr // 🟢 Added .tr
                              : 'Generate CV'.tr, // 🟢 Added .tr
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
