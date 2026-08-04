import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/trainings_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_profile_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/trainings_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';

part 'trainings_screen_binding.dart';
part 'trainings_screen_controller.dart';

class TrainingsScreenView extends GetView<TrainingsScreenViewController> {
  const TrainingsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          "Training & Certificate",
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
              // ── COURSE ────────────────────────────────────────────────────
              _sectionTitle("COURSE"),
              const SizedBox(height: 12),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Course Name"),
                    const SizedBox(height: 6),
                    CustomTextfield(
                      hintText: "e.g. Flutter Bootcamp",
                      prefixIcon: Icons.menu_book_outlined,
                      controller: controller.courseNameController,
                    ),
                    const SizedBox(height: 18),
                    _label("Institution / Provider"),
                    const SizedBox(height: 6),
                    CustomTextfield(
                      hintText: "e.g. Udemy, Coursera, Google",
                      prefixIcon: Icons.account_balance_outlined,
                      controller: controller.institutionController,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ── DURATION ──────────────────────────────────────────────────
              _sectionTitle("DURATION"),
              const SizedBox(height: 12),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: visual timeline track
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
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 14),

                        // Right: date fields
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("Start Date"),
                              const SizedBox(height: 6),
                              CustomTextfield(
                                hintText: "YYYY-MM-DD",
                                prefixIcon: Icons.calendar_today_outlined,
                                controller: controller.startDateController,
                                readOnly: true,
                                onTap: () => controller.selectDate(
                                  context,
                                  controller.startDateController,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _label("End Date"),
                              const SizedBox(height: 6),
                              CustomTextfield(
                                hintText: "YYYY-MM-DD (leave empty if ongoing)",
                                prefixIcon: Icons.event_outlined,
                                controller: controller.endDateController,
                                readOnly: true,
                                onTap: () => controller.selectDate(
                                  context,
                                  controller.endDateController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Divider(color: AppColors.line, thickness: 1),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Still in progress?",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                "Leave End Date empty to mark as ongoing",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ── CERTIFICATE ───────────────────────────────────────────────
              _sectionTitle("CERTIFICATE"),
              const SizedBox(height: 12),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labelOptional("Certificate URL"),
                    const SizedBox(height: 6),
                    CustomTextfield(
                      hintText: "https://certificate-link.com",
                      prefixIcon: Icons.link_outlined,
                      controller: controller.certificateUrlController,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ── DETAILS ───────────────────────────────────────────────────
              _sectionTitle("DETAILS"),
              const SizedBox(height: 12),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labelOptional("Description"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: controller.descriptionController,
                        maxLines: 5,
                        maxLength: 500,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: "Describe what you learned or achieved...",
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

              // ── SAVE BUTTON ───────────────────────────────────────────────
              Obx(
                () => CustomButton(
                  text: controller.isLoading.value
                      ? "Saving..."
                      : "Save Training",
                  onPressed: controller.isLoading.value
                      ? () {}
                      : controller.saveTraining,
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

  // Required field label (with red asterisk)
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

  // Optional field label (no asterisk, with badge)
  Widget _labelOptional(String text) {
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
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Optional",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textHint,
            ),
          ),
        ),
      ],
    );
  }
}
