import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../candidates_view.dart';

class EditScheduleBottomSheet extends StatefulWidget {
  final ApplicantModel applicant;
  const EditScheduleBottomSheet({super.key, required this.applicant});

  @override
  State<EditScheduleBottomSheet> createState() =>
      _EditScheduleBottomSheetState();
}

class _EditScheduleBottomSheetState extends State<EditScheduleBottomSheet> {
  final CandidatesViewController controller =
      Get.find<CandidatesViewController>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillExistingData();
  }

  void _prefillExistingData() {
    final schedule = widget.applicant.interviewSchedule;
    if (schedule != null) {
      if (schedule['date'] != null) {
        try {
          String dateStr = schedule['date'];
          if (!dateStr.endsWith('Z')) dateStr += 'Z';
          final parsedDate = DateTime.parse(dateStr).toLocal();
          _selectedDate = parsedDate;
          _selectedTime = TimeOfDay.fromDateTime(parsedDate);
        } catch (_) {}
      }
      if (schedule['location'] != null) {
        _locationController.text = schedule['location'];
      }
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground
            : Colors.white, // 🟢 Dynamic BottomSheet BG
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Interview Schedule".tr, // 🟢 Added .tr
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Updating schedule for @name".trParams({
                  'name': widget.applicant.fullName,
                }), // 🟢 Added .trParams
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "Interview Date & Time".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        _selectedDate ??
                        DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                          _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
                    );
                    if (time != null) {
                      setState(() {
                        _selectedDate = date;
                        _selectedTime = time;
                      });
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkInputBackground
                        : Colors.white, // 🟢 Dynamic Field Area
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null || _selectedTime == null
                            ? "Select Date & Time"
                                  .tr // 🟢 Added .tr
                            : "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year} at ${_selectedTime!.format(context)}",
                        style: TextStyle(
                          color: _selectedDate == null
                              ? (isDark
                                    ? AppColors.darkTextHint
                                    : Colors.grey.shade600)
                              : (isDark ? Colors.white : Colors.black87),
                          fontSize: 15,
                        ),
                      ),
                      Icon(
                        LucideIcons.calendar,
                        size: 18,
                        color: isDark
                            ? AppColors.darkIconSecondary
                            : Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Location / Link".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ), // 🟢 Dynamic Text
                decoration: InputDecoration(
                  hintText: "E.g., Floor 5, Jobber City HQ or Zoom Link"
                      .tr, // 🟢 Added .tr
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextHint
                        : Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkInputBackground
                      : Colors.white, // 🟢 Dynamic BG
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.success),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Update Message (Optional)".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 3,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ), // 🟢 Dynamic Text
                decoration: InputDecoration(
                  hintText: "E.g., We have changed the location to..."
                      .tr, // 🟢 Added .tr
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextHint
                        : Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkInputBackground
                      : Colors.white, // 🟢 Dynamic BG
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.success),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Cancel".tr, // 🟢 Added .tr
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedDate == null || _selectedTime == null) {
                          Get.snackbar(
                            "Required".tr, // 🟢 Added .tr
                            "Please select both date and time"
                                .tr, // 🟢 Added .tr
                            backgroundColor: isDark
                                ? AppColors.error.withValues(alpha: 0.15)
                                : Colors.red.shade50,
                            colorText: isDark
                                ? Colors.redAccent
                                : Colors.red.shade700,
                          );
                          return;
                        }
                        if (_locationController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Required".tr, // 🟢 Added .tr
                            "Please provide a location".tr, // 🟢 Added .tr
                            backgroundColor: isDark
                                ? AppColors.error.withValues(alpha: 0.15)
                                : Colors.red.shade50,
                            colorText: isDark
                                ? Colors.redAccent
                                : Colors.red.shade700,
                          );
                          return;
                        }

                        final scheduleDateTime = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                          _selectedTime!.hour,
                          _selectedTime!.minute,
                        );

                        Get.back();

                        controller.updateApplicantStatus(
                          widget.applicant.applicationId,
                          'interview',
                          interviewSchedule: {
                            'date': scheduleDateTime.toUtc().toIso8601String(),
                            'location': _locationController.text.trim(),
                          },
                          feedback: _messageController.text.trim().isEmpty
                              ? null
                              : _messageController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Save Changes".tr, // 🟢 Added .tr
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
