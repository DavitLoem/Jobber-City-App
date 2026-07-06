import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';
import 'experience_screen_controller.dart';

class ExperienceScreenView extends GetView<ExperienceScreenViewController> {
  const ExperienceScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          "Work Experience",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── ROLE ─────────────────────────────────────────────────────
              _sectionTitle("ROLE"),
              const SizedBox(height: 12),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Job Title"),
                    const SizedBox(height: 6),
                    CustomTextfield(
                      hintText: "e.g. Software Engineer",
                      prefixIcon: Icons.work_outline,
                      controller: controller.jobTitleCtrl,
                    ),
                    const SizedBox(height: 18),
                    _label("Company Name"),
                    const SizedBox(height: 6),
                    CustomTextfield(
                      hintText: "e.g. Google",
                      prefixIcon: Icons.business_outlined,
                      controller: controller.companyNameCtrl,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ─── DURATION ─────────────────────────────────────────────────
              _sectionTitle("DURATION"),
              const SizedBox(height: 12),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline: Start → End
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Left: visual timeline ──
                        Column(
                          children: [
                            const SizedBox(height: 38),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 64,
                              color: AppColors.primary.withOpacity(0.25),
                            ),
                            Obx(
                              () => Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.isCurrentJob.value
                                      ? AppColors.primary.withOpacity(0.3)
                                      : AppColors.primary,
                                  border: controller.isCurrentJob.value
                                      ? Border.all(
                                          color: AppColors.primary,
                                          width: 2,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 14),

                        // ── Right: date fields ──
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("Start Date"),
                              const SizedBox(height: 6),
                              CustomTextfield(
                                hintText: "YYYY-MM-DD",
                                prefixIcon: Icons.calendar_today_outlined,
                                controller: controller.startDateCtrl,
                                readOnly: true,
                                onTap: () => controller.selectDate(
                                  context,
                                  controller.startDateCtrl,
                                ),
                              ),

                              const SizedBox(height: 18),

                              _label("End Date"),
                              const SizedBox(height: 6),
                              Obx(
                                () => AnimatedOpacity(
                                  duration: const Duration(milliseconds: 250),
                                  opacity: controller.isCurrentJob.value
                                      ? 0.4
                                      : 1.0,
                                  child: CustomTextfield(
                                    hintText: controller.isCurrentJob.value
                                        ? "Present"
                                        : "YYYY-MM-DD",
                                    prefixIcon: Icons.event_busy_outlined,
                                    controller: controller.endDateCtrl,
                                    readOnly: true,
                                    onTap: controller.isCurrentJob.value
                                        ? null
                                        : () => controller.selectDate(
                                            context,
                                            controller.endDateCtrl,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Divider(color: AppColors.line, thickness: 1),
                    const SizedBox(height: 6),

                    // ── Currently working toggle ──
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          controller.isCurrentJob.value =
                              !controller.isCurrentJob.value;
                          if (controller.isCurrentJob.value) {
                            controller.endDateCtrl.clear();
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: controller.isCurrentJob.value
                                    ? AppColors.primary.withOpacity(0.1)
                                    : AppColors.inputBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                controller.isCurrentJob.value
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: controller.isCurrentJob.value
                                    ? AppColors.primary
                                    : AppColors.inputIconText,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Currently working here",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: controller.isCurrentJob.value
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    "End date will be marked as Present",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: controller.isCurrentJob.value,
                              onChanged: (val) {
                                controller.isCurrentJob.value = val;
                                if (val) controller.endDateCtrl.clear();
                              },
                              activeColor: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ─── DETAILS ──────────────────────────────────────────────────
              _sectionTitle("DETAILS"),
              const SizedBox(height: 12),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Job Description"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: controller.descriptionCtrl,
                        maxLines: 5,
                        maxLength: 500,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText:
                              "Describe your responsibilities and achievements...",
                          hintStyle: TextStyle(
                            color: AppColors.inputIconText,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          counterStyle: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ─── SAVE BUTTON ──────────────────────────────────────────────
              Obx(
                () => CustomButton(
                  text: controller.isLoading.value
                      ? "Saving..."
                      : "Save Experience",
                  onPressed: controller.isLoading.value
                      ? () {}
                      : controller.saveExperience,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.textHint,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _label(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textHint,
          ),
        ),
        const Text(
          " *",
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
