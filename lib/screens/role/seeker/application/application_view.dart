import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_application_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/my_application_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'application_binding.dart';
part 'application_controller.dart';

class ApplicationView extends GetView<ApplicationViewController> {
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'My Applications',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            tabs: [
              // 🎯 រុំ Obx លើ Text នីមួយៗដើម្បីឲ្យចំនួន (Count) លោតដោយស្វ័យប្រវត្តិ
              Tab(
                child: Obx(
                  () => Text('Pending (${controller.pendingApps.length})'),
                ),
              ),
              Tab(
                child: Obx(
                  () => Text('Interview (${controller.interviewApps.length})'),
                ),
              ),
              Tab(
                child: Obx(
                  () => Text('Closed (${controller.closedApps.length})'),
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
                emptyMessage: "No pending applications",
              ),
              _buildApplicationList(
                apps: controller.interviewApps,
                emptyMessage: "No interviews scheduled yet",
              ),
              _buildApplicationList(
                apps: controller.closedApps,
                emptyMessage: "No closed applications",
              ),
            ],
          );
        }),
      ),
    );
  }

  // 🎯 អនុគមន៍ _buildApplicationList រក្សាទុកដូចដើម
  Widget _buildApplicationList({
    required List<MyApplicationModel> apps,
    required String emptyMessage,
  }) {
    if (apps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.folderOpen, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return _buildApplicationCard(app);
      },
    );
  }

  // ពណ៌ត្រូវបានបែងចែកត្រឹមត្រូវតាម Status ទាំង ៦ រួចរាល់ហើយ
  Widget _buildApplicationCard(MyApplicationModel app) {
    Color statusColor;
    Color statusBgColor;
    String displayStatus = app.status.capitalizeFirst ?? app.status;

    switch (app.status.toLowerCase()) {
      case 'pending':
      case 'reviewed':
      case 'shortlisted':
        statusColor = Colors.orange.shade700;
        statusBgColor = Colors.orange.shade50;
        break;
      case 'interview':
        statusColor = AppColors.success;
        statusBgColor = AppColors.success.withValues(alpha: 0.1);
        break;
      case 'rejected':
        statusColor = Colors.red.shade700;
        statusBgColor = Colors.red.shade50;
        break;
      case 'hired':
        statusColor = Colors.green.shade700;
        statusBgColor = Colors.green.shade50;
        break;
      default:
        statusColor = Colors.grey.shade700;
        statusBgColor = Colors.grey.shade100;
    }

    final daysAgo = DateTime.now().difference(app.appliedAt).inDays;
    final appliedDateText = daysAgo == 0
        ? "Applied Today"
        : "Applied $daysAgo days ago";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                child: (app.companyLogo != null && app.companyLogo!.isNotEmpty)
                    ? Image.network(
                        app.companyLogo!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          LucideIcons.building,
                          color: Colors.grey.shade400,
                        ),
                      )
                    : Icon(LucideIcons.building, color: Colors.grey.shade400),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.jobTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
                        color: Colors.grey.shade600,
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
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
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
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        appliedDateText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
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
    );
  }
}
