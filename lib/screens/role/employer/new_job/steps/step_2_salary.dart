import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/screens/role/employer/new_job/new_job_view.dart';
import 'package:jobber_city/widgets/custom_bottom_sheet_picker.dart';
import 'package:jobber_city/widgets/custom_form_textfield.dart';

class Step2Salary extends GetView<NewJobViewController> {
  const Step2Salary({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    final List<String> staticSalaryPeriods = [
      "Hourly".tr, // 🟢 Configured localized array mappings early
      "Daily".tr,
      "Weekly".tr,
      "Monthly".tr,
      "Yearly".tr,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceElevated
              : Colors.white, // 🟢 Dynamic Form Section BG
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
          ), // 🟢 Dynamic Border
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Salary Details".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Section Title
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "How much are you offering for this position?".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade500,
              ), // 🟢 Dynamic Instruction Text
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "Min Salary *".tr, // 🟢 Added .tr
                    hint: "e.g. 500".tr, // 🟢 Added .tr
                    controller: controller.minSalaryCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFormTextField(
                    label: "Max Salary *".tr, // 🟢 Added .tr
                    hint: "e.g. 1000".tr, // 🟢 Added .tr
                    controller: controller.maxSalaryCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomFormTextField(
              label: "Salary Period *".tr, // 🟢 Added .tr
              hint: "e.g. Monthly".tr, // 🟢 Added .tr
              isDropdown: true,
              controller: controller.salaryPeriodCtrl,
              onTap: () {
                CustomBottomSheetPicker.show<String>(
                  title: "Select Salary Period".tr, // 🟢 Added .tr
                  items: staticSalaryPeriods,
                  getName: (item) => item,
                  onSelected: (item) {
                    controller.salaryPeriodCtrl.text = item;
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkInputBackground
                    : AppColors.primary.withValues(
                        alpha: 0.05,
                      ), // 🟢 Dynamic Form Highlight Area
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.primary.withValues(
                          alpha: 0.1,
                        ), // 🟢 Dynamic Form Highlight Border
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Is the salary negotiable?".tr, // 🟢 Added .tr
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : Colors
                                      .black87, // 🟢 Dynamic Switch Label Text
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Candidates can discuss the salary with you"
                              .tr, // 🟢 Added .tr
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : Colors
                                      .grey
                                      .shade500, // 🟢 Dynamic Switch Instruction Text
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
                      activeThumbColor: isDark
                          ? Colors.white
                          : AppColors.primary,
                      activeTrackColor: isDark
                          ? Colors.blueAccent
                          : AppColors.primary.withValues(alpha: 0.5),
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
