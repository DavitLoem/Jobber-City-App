import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/token_storage.dart';

import '../../../../core/api/services/interview_service.dart';
import '../../../../models/interview_models.dart';

part 'interview_detail_controller.dart';

class InterviewDetailView extends GetView<InterviewDetailViewController> {
  const InterviewDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        elevation: 0,
        title: Text(
          'Interview Details'.tr, // 🟢 Added .tr
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title Text
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title Icon
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.interview.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final interview = controller.interview.value;
        if (interview == null) {
          return Center(
            child: Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'Interview not found.'.tr, // 🟢 Added .tr
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.textTertiary,
              ), // 🟢 Dynamic Subtext
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OtherPartyCard(interview: interview, isDark: isDark),
              const SizedBox(height: 16),
              _InfoCard(interview: interview, isDark: isDark),
              if (interview.notes != null && interview.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _NotesCard(notes: interview.notes!, isDark: isDark),
              ],
              if (interview.status == 'cancelled' &&
                  interview.cancelReason != null &&
                  interview.cancelReason!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _CancelReasonCard(
                  reason: interview.cancelReason!,
                  isDark: isDark,
                ),
              ],
              const SizedBox(height: 24),
              const _ActionButtons(),
            ],
          ),
        );
      }),
    );
  }
}

class _OtherPartyCard extends StatelessWidget {
  final InterviewModel interview;
  final bool isDark; // 🟢 Pass Theme State

  const _OtherPartyCard({required this.interview, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final other = interview.otherParty;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.darkCardBorder
              : AppColors.cardBorder.withValues(alpha: 0.6),
        ), // 🟢 Dynamic Border
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.primaryLight, // 🟢 Dynamic Avatar BG
            ),
            clipBehavior: Clip.hardEdge,
            child: other.avatarUrl != null && other.avatarUrl!.trim().isNotEmpty
                ? Image.network(
                    other.avatarUrl!.trim(),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _fallback(other.name),
                  )
                : _fallback(other.name),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  other.name,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : AppColors.textPrimary, // 🟢 Dynamic Title
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  other.role == 'employer'
                      ? 'Employer'.tr
                      : 'Candidate'.tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textTertiary, // 🟢 Dynamic Subtext
                  ),
                ),
                if (interview.jobTitle != null &&
                    interview.jobTitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    interview.jobTitle!,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark
                          ? Colors.blueAccent
                          : AppColors.primary, // 🟢 Dynamic Job Title
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _StatusPill(status: interview.status, isDark: isDark),
        ],
      ),
    );
  }

  Widget _fallback(String name) => Center(
    child: Text(
      name.isNotEmpty ? name[0].toUpperCase() : '?',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: AppColors.primary,
      ),
    ),
  );
}

class _StatusPill extends StatelessWidget {
  final String status;
  final bool isDark; // 🟢 Pass Theme State

  const _StatusPill({required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'scheduled' => ('Scheduled'.tr, AppColors.primary), // 🟢 Added .tr
      'ongoing' => ('Live Now'.tr, AppColors.success), // 🟢 Added .tr
      'completed' => (
        'Completed'.tr,
        isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
      ), // 🟢 Added .tr & Dynamic Color
      'cancelled' => ('Cancelled'.tr, AppColors.error), // 🟢 Added .tr
      'no_show' => ('No-show'.tr, AppColors.error), // 🟢 Added .tr
      _ => (
        status.tr,
        isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
      ), // 🟢 Fallback Translate
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: isDark ? 0.15 : 0.12,
        ), // 🟢 Visibility bump in dark mode
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final InterviewModel interview;
  final bool isDark; // 🟢 Pass Theme State

  const _InfoCard({required this.interview, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.darkCardBorder
              : AppColors.cardBorder.withValues(alpha: 0.6),
        ), // 🟢 Dynamic Border
      ),
      child: Column(
        children: [
          _row(
            Icons.event_rounded,
            'Date'.tr, // 🟢 Added .tr
            _formatFullDate(interview.scheduledAt),
          ),
          const SizedBox(height: 14),
          _row(
            Icons.schedule_rounded,
            'Time'.tr, // 🟢 Added .tr
            _formatTime(interview.scheduledAt),
          ),
          const SizedBox(height: 14),
          _row(
            Icons.timer_outlined,
            'Duration'.tr, // 🟢 Added .tr
            '@dur minutes'.trParams({
              'dur': interview.durationMinutes.toString(),
            }), // 🟢 Added .trParams
          ),
          const SizedBox(height: 14),
          _row(
            Icons.videocam_outlined,
            'Platform'.tr,
            'Video call (Jitsi Meet)'.tr,
          ), // 🟢 Added .tr
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.primaryLight.withValues(
                    alpha: 0.5,
                  ), // 🟢 Dynamic Icon BG
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textTertiary, // 🟢 Dynamic Label Color
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isDark
                ? Colors.white
                : AppColors.textPrimary, // 🟢 Dynamic Value Color
          ),
        ),
      ],
    );
  }
}

class _NotesCard extends StatelessWidget {
  final String notes;
  final bool isDark; // 🟢 Pass Theme State

  const _NotesCard({required this.notes, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkCardBorder
              : AppColors.cardBorder.withValues(alpha: 0.6),
        ), // 🟢 Dynamic Border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white
                  : AppColors.textPrimary, // 🟢 Dynamic Text
            ),
          ),
          const SizedBox(height: 8),
          Text(
            notes,
            style: TextStyle(
              fontSize: 13.5,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary, // 🟢 Dynamic Text
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelReasonCard extends StatelessWidget {
  final String reason;
  final bool isDark; // 🟢 Pass Theme State

  const _CancelReasonCard({required this.reason, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.06), // 🟢 Dynamic BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.error,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Cancellation reason: @reason'.trParams({
                'reason': reason,
              }), // 🟢 Added .trParams
              style: TextStyle(
                fontSize: 12.5,
                color: isDark
                    ? Colors.redAccent
                    : AppColors.error, // 🟢 Dynamic Text
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends GetView<InterviewDetailViewController> {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Obx(() {
      final interview = controller.interview.value;
      if (interview == null) return const SizedBox.shrink();

      final children = <Widget>[];

      if (interview.isJoinable) {
        children.add(
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: controller.isJoining.value
                  ? null
                  : controller.joinInterview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                disabledBackgroundColor: isDark
                    ? AppColors.darkSurfaceElevated
                    : Colors.grey.shade300, // 🟢 Dynamic Disabled BG
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: controller.isJoining.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.videocam_rounded, color: Colors.white),
              label: Text(
                interview.status == 'ongoing'
                    ? 'Rejoin Interview'
                          .tr // 🟢 Added .tr
                    : 'Join Interview'.tr, // 🟢 Added .tr
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }

      if (interview.status == 'ongoing' && controller.isEmployer.value) {
        children.add(const SizedBox(height: 10));
        children.add(
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: controller.isUpdating.value
                  ? null
                  : controller.markCompleted,
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark
                    ? Colors.blueAccent
                    : AppColors.primary, // 🟢 Dynamic Foreground
                side: BorderSide(
                  color: isDark ? Colors.blueAccent : AppColors.primary,
                ), // 🟢 Dynamic Border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Mark as Completed'.tr, // 🟢 Added .tr
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      }

      if (interview.status == 'scheduled' && controller.isEmployer.value) {
        children.add(const SizedBox(height: 10));
        children.add(
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: controller.isUpdating.value
                  ? null
                  : () => controller.showRescheduleSheet(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark
                    ? Colors.white
                    : AppColors.textPrimary, // 🟢 Dynamic Foreground
                side: BorderSide(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
                ), // 🟢 Dynamic Border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.edit_calendar_outlined, size: 18),
              label: Text(
                'Reschedule'.tr, // 🟢 Added .tr
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      }

      if (interview.isCancellable) {
        children.add(const SizedBox(height: 10));
        children.add(
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: controller.isUpdating.value
                  ? null
                  : () => controller.showCancelSheet(context),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(
                'Cancel Interview'.tr, // 🟢 Added .tr
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      }

      return Column(children: children);
    });
  }
}

String _formatFullDate(DateTime dt) {
  final localDt = dt.toLocal();
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[localDt.month - 1].tr} ${localDt.day}, ${localDt.year}'; // 🟢 Added .tr to Month String
}

String _formatTime(DateTime dt) {
  final localDt = dt.toLocal();
  final hour = localDt.hour % 12 == 0 ? 12 : localDt.hour % 12;
  final minute = localDt.minute.toString().padLeft(2, '0');
  final period = localDt.hour >= 12 ? 'PM'.tr : 'AM'.tr; // 🟢 Added .tr
  return '$hour:$minute $period';
}
