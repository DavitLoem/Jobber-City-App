import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/routes/app_routes.dart';

import '../../../../core/api/services/interview_service.dart';
import '../../../../models/interview_models.dart';

part 'interview_list_controller.dart';

class InterviewListView extends GetView<InterviewListViewController> {
  const InterviewListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      child: Column(
        children: [
          Obx(
            () => _FilterTabs(
              selected: controller.filter.value,
              isDark: isDark, // 🟢 Pass Theme
              onChanged: controller.setFilter,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.interviews.isEmpty) {
                return _ErrorState(
                  message: controller.errorMessage.value, // Already Translated
                  isDark: isDark, // 🟢 Pass Theme
                  onRetry: controller.fetchInterviews,
                );
              }

              final visible = controller.visibleInterviews;
              if (visible.isEmpty) {
                return _EmptyState(
                  isUpcomingTab:
                      controller.filter.value == _InterviewFilter.upcoming,
                  isDark: isDark, // 🟢 Pass Theme
                );
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                key: ValueKey(controller.filter.value),
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.fetchInterviews,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: visible.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      indent: 82,
                      color: isDark
                          ? AppColors.darkDivider
                          : AppColors.divider, // 🟢 Dynamic Divider
                    ),
                    itemBuilder: (context, index) {
                      final interview = visible[index];
                      return _InterviewTile(
                        interview: interview,
                        isDark: isDark, // 🟢 Pass Theme
                        onTap: () => controller.openInterview(interview),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

enum _InterviewFilter { upcoming, past }

class _FilterTabs extends StatelessWidget {
  final _InterviewFilter selected;
  final bool isDark; // 🟢 Added
  final ValueChanged<_InterviewFilter> onChanged;

  const _FilterTabs({
    required this.selected,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isUpcoming = selected == _InterviewFilter.upcoming;

    return Container(
      color: isDark
          ? AppColors.darkBackground
          : Colors.white, // 🟢 Dynamic Outer Wrapper
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkInputBackground
              : AppColors.lightSurfaceVariant, // 🟢 Dynamic Tab Container
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: isUpcoming
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceElevated
                        : Colors.white, // 🟢 Dynamic Highlighted Pill
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.3 : 0.05,
                        ), // 🟢 Dynamic Shadow
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(_InterviewFilter.upcoming),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isUpcoming
                              ? (isDark
                                    ? Colors.blueAccent
                                    : AppColors
                                          .primary) // 🟢 Dynamic Selected Text
                              : (isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors
                                          .textTertiary), // 🟢 Dynamic Unselected Text
                        ),
                        child: Text('Upcoming'.tr), // 🟢 Added .tr
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(_InterviewFilter.past),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: !isUpcoming
                              ? (isDark
                                    ? Colors.blueAccent
                                    : AppColors
                                          .primary) // 🟢 Dynamic Selected Text
                              : (isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors
                                          .textTertiary), // 🟢 Dynamic Unselected Text
                        ),
                        child: Text('Past'.tr), // 🟢 Added .tr
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InterviewTile extends StatelessWidget {
  final InterviewModel interview;
  final bool isDark; // 🟢 Added
  final VoidCallback onTap;

  const _InterviewTile({
    required this.interview,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final other = interview.otherParty;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isDark
            ? AppColors.darkBackground
            : Colors.white, // 🟢 Dynamic Tile BG
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(
              name: other.name,
              avatarUrl: other.avatarUrl,
              isDark: isDark,
            ), // 🟢 Passed Theme State
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          other.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary, // 🟢 Dynamic Title
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(
                        status: interview.status,
                        isDark: isDark,
                      ), // 🟢 Passed Theme State
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (interview.jobTitle != null &&
                      interview.jobTitle!.isNotEmpty) ...[
                    Text(
                      interview.jobTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark
                            ? Colors.blueAccent
                            : AppColors.primary, // 🟢 Dynamic Subtitle
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                  ],
                  Row(
                    children: [
                      Icon(
                        Icons.event_rounded,
                        size: 13,
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.textTertiary, // 🟢 Dynamic Sub-icon
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateTime(interview.scheduledAt),
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.textTertiary, // 🟢 Dynamic Text
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.timer_outlined,
                        size: 13,
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.textTertiary, // 🟢 Dynamic Sub-icon
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '@dur min'.trParams({
                          'dur': interview.durationMinutes.toString(),
                        }), // 🟢 Added .trParams
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.textTertiary, // 🟢 Dynamic Text
                        ),
                      ),
                    ],
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

class _StatusBadge extends StatelessWidget {
  final String status;
  final bool isDark; // 🟢 Added
  const _StatusBadge({required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'scheduled' => ('Scheduled'.tr, AppColors.primary), // 🟢 Added .tr
      'ongoing' => ('Live'.tr, AppColors.success), // 🟢 Added .tr
      'completed' => (
        'Completed'.tr,
        isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
      ), // 🟢 Added .tr & Dynamic
      'cancelled' => ('Cancelled'.tr, AppColors.error), // 🟢 Added .tr
      'no_show' => ('No-show'.tr, AppColors.error), // 🟢 Added .tr
      _ => (
        status,
        isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
      ), // 🟢 Fallback Dynamic
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: isDark ? 0.15 : 0.12,
        ), // 🟢 Elevated opacity on Dark
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isDark; // 🟢 Added
  const _Avatar({required this.name, this.avatarUrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.primaryLight, // 🟢 Dynamic Avatar BG
      ),
      clipBehavior: Clip.hardEdge,
      child: avatarUrl != null && avatarUrl!.trim().isNotEmpty
          ? Image.network(
              avatarUrl!.trim(),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            )
          : _fallback(),
    );
  }

  Widget _fallback() {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isUpcomingTab;
  final bool isDark; // 🟢 Added
  const _EmptyState({required this.isUpcomingTab, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.primaryLight, // 🟢 Dynamic BG
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.videocam_outlined,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isUpcomingTab
                  ? 'No upcoming interviews'.tr
                  : 'No past interviews'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : AppColors.textPrimary, // 🟢 Dynamic Text
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcomingTab
                  ? 'Scheduled video interviews will show up here.'
                        .tr // 🟢 Added .tr
                  : 'Completed and cancelled interviews will show up here.'
                        .tr, // 🟢 Added .tr
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textTertiary, // 🟢 Dynamic Subtext
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final bool isDark; // 🟢 Added
  final VoidCallback onRetry;
  const _ErrorState({
    required this.message,
    required this.isDark,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: isDark
                  ? AppColors.darkIconSecondary
                  : AppColors.textTertiary, // 🟢 Dynamic Icon
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textTertiary,
              ), // 🟢 Dynamic Text
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Try Again'.tr, // 🟢 Added .tr
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime dt) {
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
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM'.tr : 'AM'.tr; // 🟢 Added .tr
  return '${months[dt.month - 1].tr} ${dt.day}, $hour:$minute $period'; // 🟢 Added .tr for month text
}
