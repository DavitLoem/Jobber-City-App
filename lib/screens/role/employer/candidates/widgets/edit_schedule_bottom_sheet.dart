import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // 🎯 អនុគមន៍សម្រាប់ទាញទិន្នន័យចាស់មកបំពេញក្នុង Form
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Edit Interview Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Updating schedule for ${widget.applicant.fullName}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // ── 1. Date & Time ──
              const Text(
                "Interview Date & Time",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        _selectedDate ??
                        DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 1),
                    ), // អនុញ្ញាតឱ្យរើសថ្ងៃចាស់បន្តិចបាន
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      // ignore: use_build_context_synchronously
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
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null || _selectedTime == null
                            ? "Select Date & Time"
                            : "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year} at ${_selectedTime!.format(context)}",
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.grey.shade600
                              : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                      Icon(
                        LucideIcons.calendar,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── 2. Location / Link ──
              const Text(
                "Location / Link",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: "E.g., Floor 5, Jobber City HQ or Zoom Link",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF10B981)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── 3. Message ──
              const Text(
                "Update Message (Optional)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "E.g., We have changed the location to...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF10B981)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Action Buttons ──
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey.shade600,
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
                            "Required",
                            "Please select both date and time",
                            backgroundColor: Colors.red.shade50,
                            colorText: Colors.red.shade700,
                          );
                          return;
                        }
                        if (_locationController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Required",
                            "Please provide a location",
                            backgroundColor: Colors.red.shade50,
                            colorText: Colors.red.shade700,
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

                        Get.back(); // បិទ Bottom Sheet

                        // 🎯 ហៅអនុគមន៍ update (មិនមែន bulk ទេ ព្រោះកែតែម្នាក់)
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
                        backgroundColor: const Color(0xFF10B981),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
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
