import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/job_model.dart';
import 'package:jobber_city/widgets/custom_bottom_sheet_picker.dart';
import 'package:jobber_city/widgets/custom_form_textfield.dart';

import '../new_job_view.dart';

class Step4Schedule extends GetView<NewJobViewController> {
  const Step4Schedule({super.key});

  // បញ្ជីថ្ងៃ Static សម្រាប់ហៅប្រើ
  final List<String> _daysOfWeek = const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  Widget build(BuildContext context) {
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
              "Schedule & Deadline",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "When do they work and when does this post expire?",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),

            // ── 1. Working Days (Start & End) ──
            const Text(
              "Working Days *",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "Start Day",
                    isDropdown: true,
                    controller: controller.startDayCtrl,
                    onTap: () {
                      _showDayPicker(
                        context,
                        "Select Start Day",
                        controller.startDayCtrl,
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "-",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "End Day",
                    isDropdown: true,
                    controller: controller.endDayCtrl,
                    onTap: () {
                      _showDayPicker(
                        context,
                        "Select End Day",
                        controller.endDayCtrl,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── 2. Working Hours (Start & End) ──
            const Text(
              "Working Hours *",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "Start Time",
                    controller: controller.startTimeCtrl,
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onTap: () => _pickTime(context, controller.startTimeCtrl),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "-",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "End Time",
                    controller: controller.endTimeCtrl,
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onTap: () => _pickTime(context, controller.endTimeCtrl),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── 3. Specific Schedule (Custom Days/Hours) ──
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddSpecificScheduleDialog(context),
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                label: const Text(
                  "Add Specific Schedule",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // បង្ហាញ Specific Schedule ដែលបាន Add រួច
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
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${schedule.day}: ${schedule.hours}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => controller.specificScheduleList
                                      .remove(schedule),
                                  child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
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
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 24),

            // ── 4. Closing Date (Date Picker) ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Closing Date *",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: true,
                  controller: controller.closingDateCtrl,
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
                      // Format បង្ហាញជាទម្រង់ ថ្ងៃ-ខែ-ឆ្នាំ (ឧ. 15-08-2026)
                      controller.closingDateCtrl.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Select application deadline",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    suffixIcon: const Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Post will automatically hide after this date.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ── មុខងារជំនួយសម្រាប់ UI ──
  // ==========================================

  // ហៅ BottomSheet សម្រាប់រើសថ្ងៃ
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

  // ហៅ TimePicker របស់ Flutter
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

  // ផ្ទាំង Dialog សម្រាប់បន្ថែម Specific Schedule
  void _showAddSpecificScheduleDialog(BuildContext context) {
    final specDayCtrl = TextEditingController();
    final specStartTimeCtrl = TextEditingController();
    final specEndTimeCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Add Specific Schedule",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormTextField(
              label: "Day",
              hint: "e.g. Sunday",
              isDropdown: true,
              controller: specDayCtrl,
              onTap: () => _showDayPicker(context, "Select Day", specDayCtrl),
            ),
            const SizedBox(height: 16),

            // ── ប្តូរពីវាយអក្សរ មកជារើសម៉ោងវិញ ──
            const Text(
              "Hours",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "Start Time",
                    controller: specStartTimeCtrl,
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onTap: () => _pickTime(context, specStartTimeCtrl),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "-",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: CustomFormTextField(
                    label: "",
                    hint: "End Time",
                    controller: specEndTimeCtrl,
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: Colors.grey,
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
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              // ឆែកមើលថាគាត់បានរើសពេញលេញឬនៅ មុននឹង Add
              if (specDayCtrl.text.isNotEmpty &&
                  specStartTimeCtrl.text.isNotEmpty &&
                  specEndTimeCtrl.text.isNotEmpty) {
                controller.specificScheduleList.add(
                  SpecificSchedule(
                    day: specDayCtrl.text.trim(),
                    // 🎯 តភ្ជាប់អក្សរម៉ោងទាំង២ បញ្ចូលគ្នា មុននឹង Save ចូល Controller
                    hours:
                        "${specStartTimeCtrl.text.trim()} - ${specEndTimeCtrl.text.trim()}",
                  ),
                );
                Get.back();
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
