import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../job_detail_view.dart';

class CompanyInfoCard extends GetView<JobDetailController> {
  const CompanyInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Obx(() {
                final logo = controller.job.value?.logoUrl ?? '';
                final name = controller.job.value?.companyName ?? 'C';
                if (logo.isNotEmpty) {
                  return Image.network(
                    logo,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _logoFallback(name),
                  );
                }
                return _logoFallback(name);
              }),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Obx(() {
              final job = controller.job.value;
              if (job == null) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.companyName,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          job.location,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          // Bookmark
          Obx(
            () => GestureDetector(
              onTap: controller.toggleSave,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    controller.job.value?.isSaved == true
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    key: ValueKey(controller.job.value?.isSaved),
                    size: 19,
                    color: controller.job.value?.isSaved == true
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoFallback(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'C',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
