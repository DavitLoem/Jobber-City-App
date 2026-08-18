import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_application_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/my_application_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'application_binding.dart';
part 'application_controller.dart';

class ApplicationView extends GetView<ApplicationViewController> {
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            'My Applications'.tr, // 🟢 Added .tr
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark
                ? AppColors.darkTextSecondary
                : Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            tabs: [
              Tab(
                child: Obx(
                  // 🟢 Used trParams for dynamic count values
                  () => Text(
                    'Pending (@count)'.trParams({
                      'count': controller.pendingApps.length.toString(),
                    }),
                  ),
                ),
              ),
              Tab(
                child: Obx(
                  () => Text(
                    'Interview (@count)'.trParams({
                      'count': controller.interviewApps.length.toString(),
                    }),
                  ),
                ),
              ),
              Tab(
                child: Obx(
                  () => Text(
                    'Closed (@count)'.trParams({
                      'count': controller.closedApps.length.toString(),
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await controller.fetchApplications();
            },
            child: TabBarView(
              children: [
                _buildApplicationList(
                  apps: controller.pendingApps,
                  emptyMessage: "No pending applications".tr, // 🟢 Added .tr
                  context: context,
                ),
                _buildApplicationList(
                  apps: controller.interviewApps,
                  emptyMessage:
                      "No interviews scheduled yet".tr, // 🟢 Added .tr
                  context: context,
                ),
                _buildApplicationList(
                  apps: controller.closedApps,
                  emptyMessage: "No closed applications".tr, // 🟢 Added .tr
                  context: context,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildApplicationList({
    required List<MyApplicationModel> apps,
    required String emptyMessage,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (apps.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.folderOpen,
                  size: 60,
                  color: isDark ? AppColors.darkTextHint : Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  emptyMessage,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return _buildApplicationCard(app, context);
      },
    );
  }

  Widget _buildApplicationCard(MyApplicationModel app, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color statusColor;
    Color statusBgColor;
    String displayStatus = app.status.capitalizeFirst ?? app.status;

    // 🟢 Updated all Opacity to withValues
    switch (app.status.toLowerCase()) {
      case 'pending':
      case 'reviewed':
      case 'shortlisted':
        statusColor = isDark ? Colors.orangeAccent : Colors.orange.shade700;
        statusBgColor = isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange.shade50;
        break;
      case 'interview':
        statusColor = isDark ? Colors.greenAccent : AppColors.success;
        statusBgColor = isDark
            ? Colors.greenAccent.withValues(alpha: 0.15)
            : AppColors.success.withValues(alpha: 0.1);
        break;
      case 'rejected':
        statusColor = isDark ? Colors.redAccent : Colors.red.shade700;
        statusBgColor = isDark
            ? Colors.redAccent.withValues(alpha: 0.15)
            : Colors.red.shade50;
        break;
      case 'hired':
        statusColor = isDark ? Colors.greenAccent : Colors.green.shade700;
        statusBgColor = isDark
            ? Colors.greenAccent.withValues(alpha: 0.15)
            : Colors.green.shade50;
        break;
      default:
        statusColor = isDark
            ? AppColors.darkTextSecondary
            : Colors.grey.shade700;
        statusBgColor = isDark
            ? AppColors.darkSurfaceElevated
            : Colors.grey.shade100;
    }

    final daysAgo = DateTime.now().difference(app.appliedAt).inDays;

    // 🟢 Used trParams for Dynamic Date logic
    final appliedDateText = daysAgo == 0
        ? "Applied Today".tr
        : "Applied @days days ago".trParams({'days': daysAgo.toString()});

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.applicationDetail, arguments: app.applicationId);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.2 : 0.02,
              ), // 🟢 Updated to withValues
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkInputBackground
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child:
                      (app.companyLogo != null && app.companyLogo!.isNotEmpty)
                      ? Image.network(
                          app.companyLogo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            LucideIcons.building,
                            color: isDark
                                ? AppColors.darkIconSecondary
                                : Colors.grey.shade400,
                          ),
                        )
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
                        app.jobTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        app.companyName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(
              height: 1,
              color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          appliedDateText,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    displayStatus
                        .tr, // 🟢 Added .tr to automatically translate the status mapped from the API
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
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
