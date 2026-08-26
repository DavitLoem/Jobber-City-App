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
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
        appBar: AppBar(
          backgroundColor:
              theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
          elevation: 0,
          title: Text(
            'My Applications'.tr, // 🟢 Added .tr
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark
                ? AppColors.darkTextHint
                : Colors.grey, // 🟢 Dynamic Unselected Label
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            tabs: [
              Tab(
                child: Obx(
                  () => Text(
                    '@label (@count)'.trParams({
                      // 🟢 Added .trParams
                      'label': 'Pending'.tr,
                      'count': controller.pendingApps.length.toString(),
                    }),
                  ),
                ),
              ),
              Tab(
                child: Obx(
                  () => Text(
                    '@label (@count)'.trParams({
                      // 🟢 Added .trParams
                      'label': 'Interview'.tr,
                      'count': controller.interviewApps.length.toString(),
                    }),
                  ),
                ),
              ),
              Tab(
                child: Obx(
                  () => Text(
                    '@label (@count)'.trParams({
                      // 🟢 Added .trParams
                      'label': 'Closed'.tr,
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

          return TabBarView(
            children: [
              _buildApplicationList(
                apps: controller.pendingApps,
                emptyMessage: "No pending applications".tr, // 🟢 Added .tr
                context: context,
                isDark: isDark,
                theme: theme,
              ),
              _buildApplicationList(
                apps: controller.interviewApps,
                emptyMessage: "No interviews scheduled yet".tr, // 🟢 Added .tr
                context: context,
                isDark: isDark,
                theme: theme,
              ),
              _buildApplicationList(
                apps: controller.closedApps,
                emptyMessage: "No closed applications".tr, // 🟢 Added .tr
                context: context,
                isDark: isDark,
                theme: theme,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildApplicationList({
    required List<MyApplicationModel> apps,
    required String emptyMessage,
    required BuildContext context,
    required bool isDark,
    required ThemeData theme,
  }) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await controller.fetchApplications();
      },
      child: apps.isEmpty
          ? SingleChildScrollView(
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
                        color: isDark
                            ? AppColors.darkIconSecondary
                            : Colors.grey.shade300, // 🟢 Dynamic Icon
                      ),
                      const SizedBox(height: 16),
                      Text(
                        emptyMessage, // Translated from parent
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : Colors.grey.shade500, // 🟢 Dynamic Text
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                return _buildApplicationCard(app, isDark, theme);
              },
            ),
    );
  }

  Widget _buildApplicationCard(
    MyApplicationModel app,
    bool isDark,
    ThemeData theme,
  ) {
    Color statusColor;
    Color statusBgColor;
    String displayStatus =
        app.status.capitalizeFirst?.tr ?? app.status.tr; // 🟢 Added .tr

    switch (app.status.toLowerCase()) {
      case 'pending':
      case 'reviewed':
      case 'shortlisted':
        statusColor = isDark ? Colors.orangeAccent : Colors.orange.shade700;
        statusBgColor = isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange.shade50; // 🟢 Dynamic Color
        break;
      case 'interview':
        statusColor = isDark ? Colors.greenAccent : AppColors.success;
        statusBgColor = isDark
            ? Colors.greenAccent.withValues(alpha: 0.15)
            : AppColors.success.withValues(alpha: 0.1); // 🟢 Dynamic Color
        break;
      case 'rejected':
        statusColor = isDark ? Colors.redAccent : Colors.red.shade700;
        statusBgColor = isDark
            ? Colors.redAccent.withValues(alpha: 0.15)
            : Colors.red.shade50; // 🟢 Dynamic Color
        break;
      case 'hired':
        statusColor = isDark ? Colors.greenAccent : Colors.green.shade700;
        statusBgColor = isDark
            ? Colors.greenAccent.withValues(alpha: 0.15)
            : Colors.green.shade50; // 🟢 Dynamic Color
      default:
        statusColor = isDark
            ? AppColors.darkTextSecondary
            : Colors.grey.shade700;
        statusBgColor = isDark
            ? AppColors.darkSurfaceElevated
            : Colors.grey.shade100; // 🟢 Dynamic Color
    }

    final daysAgo = DateTime.now().difference(app.appliedAt).inDays;
    final appliedDateText = daysAgo == 0
        ? "Applied Today"
              .tr // 🟢 Added .tr
        : "Applied @days days ago".trParams({
            'days': daysAgo.toString(),
          }); // 🟢 Added .trParams

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.applicationDetail, arguments: app.applicationId);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor, // 🟢 Dynamic Card BG
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? AppColors.darkCardBorder
                : Colors.grey.shade200, // 🟢 Dynamic Border
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.2 : 0.02,
              ), // 🟢 Dynamic Shadow
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
                        ? AppColors.darkSurfaceElevated
                        : Colors.grey.shade100, // 🟢 Dynamic Logo BG
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
                          color: theme
                              .textTheme
                              .bodyLarge
                              ?.color, // 🟢 Dynamic Title
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
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : Colors.grey.shade600, // 🟢 Dynamic Subtitle
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
              color: isDark
                  ? AppColors.darkDivider
                  : const Color(0xFFEEEEEE), // 🟢 Dynamic Divider
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
                              ? AppColors.darkIconSecondary
                              : Colors.grey.shade500, // 🟢 Dynamic Sub-icon
                        ),
                        const SizedBox(width: 4),
                        Text(
                          appliedDateText,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : Colors.grey.shade600, // 🟢 Dynamic Sub-text
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
                    displayStatus,
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
