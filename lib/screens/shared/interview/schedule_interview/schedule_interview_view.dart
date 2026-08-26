import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/interview_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/interview_models.dart';
import 'package:jobber_city/routes/app_routes.dart';

part 'schedule_interview_binding.dart';
part 'schedule_interview_controller.dart';

class ScheduleInterviewView extends GetView<ScheduleInterviewViewController> {
  const ScheduleInterviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Icon
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Schedule Interview'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CandidateCard(
              args: controller.args,
              isDark: isDark,
            ), // 🟢 Passed Theme state
            const SizedBox(height: 28),

            Text(
              'Interview Date'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => _PickerField(
                icon: Icons.event_rounded,
                value: controller.selectedDate.value != null
                    ? _formatDate(controller.selectedDate.value!)
                    : 'Select a date'.tr, // 🟢 Added .tr
                isDark: isDark,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        controller.selectedDate.value ??
                        DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) controller.selectedDate.value = picked;
                },
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Interview Time'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => _PickerField(
                icon: Icons.schedule_rounded,
                value: controller.selectedTime.value != null
                    ? controller.selectedTime.value!.format(context)
                    : 'Select a time'.tr, // 🟢 Added .tr
                isDark: isDark,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime:
                        controller.selectedTime.value ?? TimeOfDay.now(),
                  );
                  if (picked != null) controller.selectedTime.value = picked;
                },
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Duration'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 10,
                children: [15, 30, 45, 60].map((mins) {
                  final isSelected = controller.durationMinutes.value == mins;
                  return ChoiceChip(
                    label: Text(
                      '@mins min'.trParams({'mins': mins.toString()}),
                    ), // 🟢 Added .trParams
                    selected: isSelected,
                    onSelected: (_) => controller.durationMinutes.value = mins,
                    selectedColor: isDark
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.primaryLight, // 🟢 Dynamic Selection Color
                    labelStyle: TextStyle(
                      color: isSelected
                          ? (isDark
                                ? Colors.blueAccent
                                : AppColors.primary) // 🟢 Dynamic Selected Text
                          : (isDark
                                ? AppColors.darkTextSecondary
                                : Colors.black54), // 🟢 Dynamic Unselected Text
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceElevated
                        : Colors.grey.shade50, // 🟢 Dynamic Unselected BG
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                                ? AppColors.darkCardBorder
                                : Colors.grey.shade200), // 🟢 Dynamic Border
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Notes (Optional)'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.notesController,
              maxLines: 3,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
              ), // 🟢 Dynamic Input Text
              decoration: InputDecoration(
                hintText: 'E.g., Please prepare a short portfolio walkthrough.'
                    .tr, // 🟢 Added .tr
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                ), // 🟢 Dynamic Hint Text
                filled: true,
                fillColor: isDark
                    ? AppColors.darkInputBackground
                    : Colors.grey.shade50, // 🟢 Dynamic Input Field BG
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : Colors.grey.shade200,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : Colors.grey.shade200,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.primaryLight.withValues(
                        alpha: 0.5,
                      ), // 🟢 Dynamic Box BG
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.videocam_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'A private video call link will be generated automatically — no extra app needed on either side.'
                          .tr, // 🟢 Added .tr
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey.shade700, // 🟢 Dynamic Subtext
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: isDark
                        ? AppColors.darkSurfaceElevated
                        : Colors.grey.shade300, // 🟢 Dynamic Disabled BG
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Schedule Interview'.tr, // 🟢 Added .tr
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final ScheduleInterviewArgs args;
  final bool isDark; // 🟢 Added Theme Flag

  const _CandidateCard({required this.args, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Candidate Card BG
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ), // 🟢 Dynamic Border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.02,
            ), // 🟢 Dynamic Shadow
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: isDark
                ? AppColors.darkInputBackground
                : Colors.grey.shade200, // 🟢 Dynamic Avatar BG
            backgroundImage:
                args.seekerAvatarUrl != null &&
                    args.seekerAvatarUrl!.trim().isNotEmpty
                ? NetworkImage(args.seekerAvatarUrl!.trim())
                : null,
            child:
                args.seekerAvatarUrl == null ||
                    args.seekerAvatarUrl!.trim().isEmpty
                ? Text(
                    args.seekerName.isNotEmpty
                        ? args.seekerName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args.seekerName,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : Colors.black87, // 🟢 Dynamic Text
                  ),
                ),
                if (args.jobTitle != null && args.jobTitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'For: @job'.trParams({
                      'job': args.jobTitle!,
                    }), // 🟢 Added .trParams
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : Colors.grey.shade600, // 🟢 Dynamic Subtext
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final IconData icon;
  final String value;
  final bool isDark; // 🟢 Added Theme Flag
  final VoidCallback onTap;

  const _PickerField({
    required this.icon,
    required this.value,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.grey.shade300,
          ), // 🟢 Dynamic Border
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Value Text
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.darkIconSecondary : Colors.grey,
            ), // 🟢 Dynamic Chevron
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime dt) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[dt.month - 1].tr} ${dt.day}, ${dt.year}'; // 🟢 Added .tr to Month String
}
