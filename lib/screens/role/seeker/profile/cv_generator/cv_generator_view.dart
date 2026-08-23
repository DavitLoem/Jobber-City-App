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

/// Seeker-only screen: turns their saved profile (experience, education,
/// skills, etc. — already filled in via the other Profile section screens)
/// into a downloadable PDF resume, picking from the backend's template
/// library. Entry point is the "Generate CV" item on `ProfileScreenView`.
class CvGeneratorView extends GetView<CvGeneratorViewController> {
  const CvGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Generate CV',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.currentCv.value?.hasCv == true) ...[
                CurrentCvBanner(cv: controller.currentCv.value!, onView: controller.viewCurrentCv),
                const SizedBox(height: 24),
              ],

              const Text(
                'Choose a template',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                'We\'ll fill it in automatically using your profile — experience, education, skills, and more.',
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, height: 1.4),
              ),
              const SizedBox(height: 16),

              if (controller.templates.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('No templates available right now.', style: TextStyle(color: Colors.grey.shade500)),
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
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 18, color: Colors.orange.shade700),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          controller.profileWarning.value,
                          style: TextStyle(fontSize: 12.5, color: Colors.orange.shade800, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.selectedTemplateId.value.isEmpty || controller.isGenerating.value
                      ? null
                      : controller.generateCv,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: controller.isGenerating.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                        )
                      : Text(
                          controller.currentCv.value?.hasCv == true ? 'Regenerate CV' : 'Generate CV',
                          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.white),
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
