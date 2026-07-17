import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/employer/new_job/new_job_view.dart';
import 'package:jobber_city/widgets/custom_bottom_sheet_picker.dart';
import 'package:jobber_city/widgets/custom_form_textfield.dart';

class Step2Salary extends GetView<NewJobViewController> {
  const Step2Salary({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> staticSalaryPeriods = [
      "Hourly",
      "Daily",
      "Weekly",
      "Monthly",
      "Yearly",
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Salary Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "How much are you offering for this position?",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),

            // ── 1. Salary Range (Min & Max) ──
            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "Min Salary *",
                    hint: "e.g. 500",
                    controller: controller.minSalaryCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFormTextField(
                    label: "Max Salary *",
                    hint: "e.g. 1000",
                    controller: controller.maxSalaryCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── 2. Salary Period ──
            CustomFormTextField(
              label: "Salary Period *",
              hint: "e.g. Monthly",
              isDropdown: true,
              controller: controller.salaryPeriodCtrl,
              onTap: () {
                CustomBottomSheetPicker.show<String>(
                  title: "Select Salary Period",
                  items: staticSalaryPeriods,
                  getName: (item) =>
                      item, // ដោយសារវាជា String ស្រាប់ យើងគ្រាន់តែ return យក item ផ្ទាល់
                  onSelected: (item) {
                    controller.salaryPeriodCtrl.text = item;
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // ── 3. Is Negotiable (Toggle Switch) ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Is the salary negotiable?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Candidates can discuss the salary with you",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Switch(
                      value: controller.isNegotiable.value,
                      onChanged: (value) {
                        controller.isNegotiable.value = value;
                      },
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
