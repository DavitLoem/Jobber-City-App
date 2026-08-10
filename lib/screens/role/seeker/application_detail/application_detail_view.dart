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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Application Details',
          style: TextStyle(
            color: Colors.black87,
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
          return const Center(child: Text("Details not found."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(detail),
              const SizedBox(height: 24),

              // ប្រវត្តិ Timeline
              const Text(
                "Status History",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTimeline(detail),

              // ព័ត៌មានសម្ភាសន៍ (លោតចេញតែពេល Status ដល់ Interview)
              if (detail.interviewSchedule != null) ...[
                const SizedBox(height: 24),
                const Text(
                  "Interview Schedule",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildInterviewCard(detail.interviewSchedule!),
              ],

              // Cover Letter
              if (detail.coverLetter.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  "Cover Letter",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    detail.coverLetter,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(height: 1.5, color: Colors.black87),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(dynamic detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child:
                (detail.companyLogo != null && detail.companyLogo!.isNotEmpty)
                ? Image.network(detail.companyLogo!, fit: BoxFit.cover)
                : Icon(LucideIcons.building, color: Colors.grey.shade400),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.jobTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail.companyName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
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

  Widget _buildTimeline(dynamic detail) {
    final history = detail.statusHistory;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero, // 🎯 លុប Padding ដើមរបស់ ListView ចោល
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
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  // 🎯 លក្ខខណ្ឌឆ្លាតវៃ៖ បើជា Status ចុងក្រោយគេ គឺឱ្យ Padding ខាងក្រោម = 0
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.status.toString().capitalizeFirst ?? item.status,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate, // 🎯 បង្ហាញម៉ោងដែលបាន Format រួច
                        style: TextStyle(
                          color: Colors.grey.shade500,
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

  Widget _buildInterviewCard(dynamic schedule) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.calendarCheck,
                color: AppColors.success,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                schedule.date.toLocal().toString().split('.')[0],
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.mapPin,
                color: AppColors.success,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  schedule.location,
                  style: const TextStyle(color: AppColors.success),
                ),
              ),
            ],
          ),
          if (schedule.message.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                schedule.message,
                style: const TextStyle(
                  color: AppColors.success,
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
