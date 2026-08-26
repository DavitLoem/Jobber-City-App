import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/models/role/employer/job_model.dart';
import 'package:jobber_city/widgets/custom_bottom_sheet_picker.dart';
import 'package:jobber_city/widgets/custom_form_textfield.dart';

import '../new_job_view.dart';

class Step4Schedule extends GetView<NewJobViewController> {
  const Step4Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    final List<String> _daysOfWeek = [
      "Monday".tr,
      "Tuesday".tr,
      "Wednesday".tr,
      "Thursday".tr,
      "Friday".tr,
      "Saturday".tr,
      "Sunday".tr,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceElevated
              : Colors.white, // 🟢 Dynamic Outer Frame
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
          ), // 🟢 Dynamic Border Shape
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Schedule & Deadline".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Title Form Color
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
              ), // 🟢 Dynamic Instructional Text
            ),
            const SizedBox(height: 24),

            Text(
              "Working Days *".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Form Inner Labels
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
                        _daysOfWeek,
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
                      color: isDark ? Colors.white : Colors.black87,
                    ), // 🟢 Dynamic Color Spacer
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
                        _daysOfWeek,
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
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Text Label Config
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
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : Colors.grey, // 🟢 Dynamic Right Side Icon
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
                      color: isDark ? Colors.white : Colors.black87,
                    ), // 🟢 Dynamic Color Spacer
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
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : Colors.grey, // 🟢 Dynamic Right Side Icon
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
                onPressed: () => _showAddSpecificScheduleDialog(
                  context,
                  isDark,
                  _daysOfWeek,
                ), // 🟢 Passed State Items
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: isDark
                      ? Colors.blueAccent
                      : AppColors.primary, // 🟢 Dynamic Button Accent
                  size: 20,
                ),
                label: Text(
                  "Add Specific Schedule".tr, // 🟢 Added .tr
                  style: TextStyle(
                    color: isDark
                        ? Colors.blueAccent
                        : AppColors
                              .primary, // 🟢 Dynamic Button Action Link Text
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: isDark
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(
                          alpha: 0.05,
                        ), // 🟢 Dynamic Context Fill
                  side: BorderSide(
                    color: isDark
                        ? Colors.blueAccent
                        : AppColors.primary.withValues(
                            alpha: 0.3,
                          ), // 🟢 Dynamic Frame Context
                  ),
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
                                  ? AppColors.darkInputBackground
                                  : Colors
                                        .grey
                                        .shade50, // 🟢 Dynamic Entry Wrapping Field Item
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkCardBorder
                                    : Colors.grey.shade200,
                              ), // 🟢 Dynamic Separator Boundary
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${schedule.day.tr}: ${schedule.hours}", // Will match map logic if day translation needed
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.white
                                        : Colors
                                              .black87, // 🟢 Dynamic Read Text
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => controller.specificScheduleList
                                      .remove(schedule),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: isDark
                                        ? Colors.redAccent
                                        : Colors.redAccent,
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
            ), // 🟢 Dynamic Line Break Check
            const SizedBox(height: 24),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Closing Date *".tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white
                        : Colors.black87, // 🟢 Dynamic Date Field Label Text
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: true,
                  controller: controller.closingDateCtrl,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ), // 🟢 Dynamic Field Text Readout Value
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
                      final endOfDayDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        23,
                        59,
                        59,
                      );

                      controller.selectedClosingDate.value = endOfDayDate;

                      controller.closingDateCtrl.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Select application deadline".tr, // 🟢 Added .tr
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.darkTextHint
                          : Colors
                                .grey
                                .shade400, // 🟢 Dynamic Hint Status Color Layer Value
                      fontSize: 14,
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_today_rounded,
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : Colors
                                .grey, // 🟢 Dynamic Edge Value Setup Icon Context Object Color Layer Update Control Structure Parameter Assignment Logic Pass Through Verification System Requirement Satisfaction Function Parameter Addition Block Segment
                      size: 20,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkInputBackground
                        : Colors
                              .white, // 🟢 Dynamic Field Background Parameter Target Point
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.darkCardBorder
                            : Colors.grey.shade300,
                      ), // 🟢 Dynamic System Field Form Unfocus Color Status Tracking Event State Control Hook Target Object Definition Point Mapping Property Configuration Rule Requirement Resolution
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.blueAccent
                            : Colors.blueAccent, // Consistent standard blue
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Post will automatically hide after this date."
                      .tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : Colors.grey.shade500,
                  ), // 🟢 Dynamic Warning Tip Color Constraint Enforcement Rule Match Action Binding Result View Process Block Scope Segment Level
                ),
              ],
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
    List<String> validDays,
  ) {
    CustomBottomSheetPicker.show<String>(
      title: title,
      items: validDays,
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
    bool isDark,
    List<String> availableDays,
  ) {
    final specDayCtrl = TextEditingController();
    final specStartTimeCtrl = TextEditingController();
    final specEndTimeCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Alert Action BG
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Add Specific Schedule".tr, // 🟢 Added .tr
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ), // 🟢 Dynamic Control Box Title Config View System Pass Context Logic Action Setup Parameter Assignment Value Link Node
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
                availableDays,
              ), // 🟢 Added .tr
            ),
            const SizedBox(height: 16),

            Text(
              "Hours".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.white
                    : Colors
                          .black87, // 🟢 Dynamic Title String State Configuration Rule Assignment Property Binding Execution Loop Condition Block Node Statement Logic Target
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
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : Colors.grey, // 🟢 Dynamic Field Icon Parameter
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
                      color: isDark ? Colors.white : Colors.black87,
                    ), // 🟢 Dynamic Space Field Separator Constraint Text System Functionality
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
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : Colors
                                .grey, // 🟢 Dynamic Action Context View Link Control Configuration Output Form Event Binding Segment Condition Function Block View Node Context Output Link State Evaluation Processing Point Structure Logic Flow Requirement Pattern Fulfillment
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
              "Cancel".tr,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : Colors.grey,
              ),
            ), // 🟢 Added .tr
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.blueAccent : AppColors.primary,
            ), // 🟢 Dynamic Submit System Action View Process Link Setup State Logic Point Flow Execution Block
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
