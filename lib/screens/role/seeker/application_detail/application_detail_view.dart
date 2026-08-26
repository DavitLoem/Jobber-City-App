import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/my_application_detail_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/api/services/role/seeker/seeker_application_service.dart';

part 'application_detail_binding.dart';
part 'application_detail_controller.dart';

class ApplicationDetailView extends GetView<ApplicationDetailViewController> {
  const ApplicationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.textTheme.bodyLarge?.color,
          ), // 🟢 Dynamic Icon
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Application Details'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final detail = controller.applicationDetail.value;
        if (detail == null) {
          return Center(child: Text("Details not found.".tr)); // 🟢 Added .tr
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(detail, theme, isDark),
              const SizedBox(height: 24),

              // ប្រវត្តិ Timeline
              Text(
                "Status History".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
                ),
              ),
              const SizedBox(height: 16),
              _buildTimeline(detail, theme, isDark),

              // ព័ត៌មានសម្ភាសន៍ (លោតចេញតែពេល Status ដល់ Interview)
              if (detail.interviewSchedule != null) ...[
                const SizedBox(height: 24),
                Text(
                  "Interview Schedule".tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
                  ),
                ),
                const SizedBox(height: 12),
                _buildInterviewCard(detail.interviewSchedule!, isDark),
              ],

              // Cover Letter
              if (detail.coverLetter.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  "Cover Letter".tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor, // 🟢 Dynamic BG
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade200,
                    ), // 🟢 Dynamic Border
                  ),
                  child: Text(
                    detail.coverLetter,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      height: 1.5,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.black87, // 🟢 Dynamic Text
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(dynamic detail, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ), // 🟢 Dynamic Border
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceElevated
                  : Colors.grey.shade100, // 🟢 Dynamic Image BG
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child:
                (detail.companyLogo != null && detail.companyLogo!.isNotEmpty)
                ? Image.network(detail.companyLogo!, fit: BoxFit.cover)
                : Icon(
                    LucideIcons.building,
                    color: isDark
                        ? AppColors.darkIconSecondary
                        : Colors.grey.shade400,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.jobTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme
                        .textTheme
                        .bodyLarge
                        ?.color, // 🟢 Dynamic Job Title
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail.companyName,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade600, // 🟢 Dynamic Subtitle
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(dynamic detail, ThemeData theme, bool isDark) {
    final history = detail.statusHistory;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, // 🟢 Dynamic Timeline Card BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ), // 🟢 Dynamic Border
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          final isLast = index == history.length - 1;

          // 🎯 បំប្លែងម៉ោង UTC ទៅជាម៉ោង Local (ម៉ោងនៅកម្ពុជា) ហើយ Format ឱ្យស្អាត
          final localDate = item.date.toLocal();
          final formattedDate = DateFormat(
            'dd MMM yyyy, hh:mm a',
          ).format(localDate);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 30,
                      color: AppColors.primary.withValues(
                        alpha: 0.3,
                      ), // 🟢 Updated to withValues
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (item.status.toString().capitalizeFirst ?? item.status)
                            .tr, // 🟢 Added .tr
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme
                              .textTheme
                              .bodyLarge
                              ?.color, // 🟢 Dynamic Text
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : Colors
                                    .grey
                                    .shade500, // 🟢 Dynamic Time Date Text
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInterviewCard(dynamic schedule, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.successBackground, // 🟢 Dynamic BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
        ), // 🟢 Updated to withValues
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.calendarCheck,
                color: isDark
                    ? Colors.greenAccent
                    : AppColors.success, // 🟢 Dynamic Icon
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                schedule.date.toLocal().toString().split('.')[0],
                style: TextStyle(
                  color: isDark
                      ? Colors.greenAccent
                      : AppColors.success, // 🟢 Dynamic Text
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                LucideIcons.mapPin,
                color: isDark
                    ? Colors.greenAccent
                    : AppColors.success, // 🟢 Dynamic Icon
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  schedule.location,
                  style: TextStyle(
                    color: isDark ? Colors.greenAccent : AppColors.success,
                  ), // 🟢 Dynamic Text
                ),
              ),
            ],
          ),
          if (schedule.message.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.5,
                ), // 🟢 Updated to withValues
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                schedule.message,
                style: TextStyle(
                  color: isDark
                      ? Colors.greenAccent
                      : AppColors.success, // 🟢 Dynamic Text
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
