import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/job_model.dart';
import 'package:jobber_city/widgets/custom_bottom_sheet_picker.dart';
import 'package:jobber_city/widgets/custom_form_textfield.dart';

import '../new_job_view.dart';

class Step4Schedule extends GetView<NewJobViewController> {
  const Step4Schedule({super.key});

  List<String> get _daysOfWeek => [
    "Monday".tr,
    "Tuesday".tr,
    "Wednesday".tr,
    "Thursday".tr,
    "Friday".tr,
    "Saturday".tr,
    "Sunday".tr,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Schedule & Deadline".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "When do they work and when does this post expire?"
                  .tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Working Days *".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "Start Day".tr, // 🟢 Added .tr
                    isDropdown: true,
                    controller: controller.startDayCtrl,
                    onTap: () {
                      _showDayPicker(
                        context,
                        "Select Start Day".tr, // 🟢 Added .tr
                        controller.startDayCtrl,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "-",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "End Day".tr, // 🟢 Added .tr
                    isDropdown: true,
                    controller: controller.endDayCtrl,
                    onTap: () {
                      _showDayPicker(
                        context,
                        "Select End Day".tr, // 🟢 Added .tr
                        controller.endDayCtrl,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              "Working Hours *".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "Start Time".tr, // 🟢 Added .tr
                    controller: controller.startTimeCtrl,
                    readOnly: true,
                    suffixIcon: Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                    ),
                    onTap: () => _pickTime(context, controller.startTimeCtrl),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "-",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "End Time".tr, // 🟢 Added .tr
                    controller: controller.endTimeCtrl,
                    readOnly: true,
                    suffixIcon: Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                    ),
                    onTap: () => _pickTime(context, controller.endTimeCtrl),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    _showAddSpecificScheduleDialog(context, theme, isDark),
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                label: Text(
                  "Add Specific Schedule".tr, // 🟢 Added .tr
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primary.withValues(
                    alpha: isDark ? 0.15 : 0.05,
                  ), // 🟢 Updated opacity
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ), // 🟢 Updated opacity
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            Obx(
              () => controller.specificScheduleList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: controller.specificScheduleList.map((
                          schedule,
                        ) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceElevated
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkCardBorder
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${schedule.day}: ${schedule.hours}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => controller.specificScheduleList
                                      .remove(schedule),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: isDark
                                        ? Colors.redAccent
                                        : Colors.redAccent.shade400,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),
            Divider(
              height: 1,
              color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
            ),
            const SizedBox(height: 24),

            CustomFormTextField(
              label: "Closing Date *".tr, // 🟢 Added .tr
              hint: "Select application deadline".tr, // 🟢 Added .tr
              controller: controller.closingDateCtrl,
              readOnly: true,
              suffixIcon: Icon(
                Icons.calendar_today_rounded,
                color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                size: 20,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      controller.selectedClosingDate.value ??
                      DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  controller.selectedClosingDate.value = pickedDate;
                  controller.closingDateCtrl.text =
                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              "Post will automatically hide after this date."
                  .tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showDayPicker(
    BuildContext context,
    String title,
    TextEditingController textCtrl,
  ) {
    CustomBottomSheetPicker.show<String>(
      title: title,
      items: _daysOfWeek,
      getName: (item) => item,
      onSelected: (item) {
        textCtrl.text = item;
      },
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    TextEditingController textCtrl,
  ) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (pickedTime != null && context.mounted) {
      textCtrl.text = pickedTime.format(context);
    }
  }

  void _showAddSpecificScheduleDialog(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final specDayCtrl = TextEditingController();
    final specStartTimeCtrl = TextEditingController();
    final specEndTimeCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Add Specific Schedule".tr, // 🟢 Added .tr
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormTextField(
              label: "Day".tr, // 🟢 Added .tr
              hint: "e.g. Sunday".tr, // 🟢 Added .tr
              isDropdown: true,
              controller: specDayCtrl,
              onTap: () => _showDayPicker(
                context,
                "Select Day".tr,
                specDayCtrl,
              ), // 🟢 Added .tr
            ),
            const SizedBox(height: 16),

            Text(
              "Hours".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "Start Time".tr, // 🟢 Added .tr
                    controller: specStartTimeCtrl,
                    readOnly: true,
                    suffixIcon: Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                    ),
                    onTap: () => _pickTime(context, specStartTimeCtrl),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "-",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "End Time".tr, // 🟢 Added .tr
                    controller: specEndTimeCtrl,
                    readOnly: true,
                    suffixIcon: Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                    ),
                    onTap: () => _pickTime(context, specEndTimeCtrl),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel".tr, // 🟢 Added .tr
              style: TextStyle(
                color: isDark ? AppColors.darkTextHint : Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (specDayCtrl.text.isNotEmpty &&
                  specStartTimeCtrl.text.isNotEmpty &&
                  specEndTimeCtrl.text.isNotEmpty) {
                controller.specificScheduleList.add(
                  SpecificSchedule(
                    day: specDayCtrl.text.trim(),
                    hours:
                        "${specStartTimeCtrl.text.trim()} - ${specEndTimeCtrl.text.trim()}",
                  ),
                );
                Get.back();
              }
            },
            child: Text(
              "Add".tr,
              style: const TextStyle(color: Colors.white),
            ), // 🟢 Added .tr
          ),
        ],
      ),
    );
  }
}
