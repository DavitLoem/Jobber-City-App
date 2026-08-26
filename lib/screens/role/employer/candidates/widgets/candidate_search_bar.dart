import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/core/utils/excel_export_helper.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/utils/pdf_export_helper.dart';
import '../candidates_view.dart';

class CandidateSearchBar extends GetView<CandidatesViewController> {
  final TextEditingController searchCtrl;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const CandidateSearchBar({
    super.key,
    required this.searchCtrl,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkInputBackground
                    : Colors.white, // 🟢 Dynamic BG
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : Colors.grey.shade200,
                ),
              ),
              child: TextField(
                controller: searchCtrl,
                onChanged: onChanged,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ), // 🟢 Dynamic Input Text
                decoration: InputDecoration(
                  hintText: "Search candidates, skills...".tr, // 🟢 Added .tr
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextHint
                        : Colors.grey.shade400, // 🟢 Dynamic Hint Text
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    color: isDark
                        ? AppColors.darkIconSecondary
                        : Colors.grey.shade400,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  suffixIcon: searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            LucideIcons.xCircle,
                            color: isDark
                                ? AppColors.darkIconSecondary
                                : Colors.grey.shade400,
                            size: 18,
                          ),
                          onPressed: () {
                            searchCtrl.clear();
                            onClear();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceElevated
                  : Colors.white, // 🟢 Dynamic Popup Base
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
              ),
            ),
            child: Obx(() {
              final String currentVal = controller.currentSort.value;

              return PopupMenuButton<String>(
                icon: Icon(
                  LucideIcons.arrowUpDown,
                  color: isDark
                      ? AppColors.darkIconSecondary
                      : Colors.grey.shade700,
                  size: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : Colors.transparent,
                  ),
                ),
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : Colors.white, // 🟢 Dynamic Menu List BG
                elevation: 4,
                position: PopupMenuPosition.under,
                onSelected: (String value) {
                  controller.changeSortOption(value);
                },
                itemBuilder: (BuildContext context) => [
                  _buildPopupItem(
                    'newest',
                    'Newest Applied'.tr, // 🟢 Added .tr
                    LucideIcons.clock,
                    currentVal,
                    isDark,
                  ),
                  _buildPopupItem(
                    'name_asc',
                    'Name (A-Z)'.tr, // 🟢 Added .tr
                    LucideIcons.aArrowDown,
                    currentVal,
                    isDark,
                  ),
                  _buildPopupItem(
                    'interview_asc',
                    'Nearest Interview'.tr, // 🟢 Added .tr
                    LucideIcons.calendarClock,
                    currentVal,
                    isDark,
                  ),
                ],
              );
            }),
          ),
          const SizedBox(width: 8),

          InkWell(
            onTap: () {
              if (controller.selectedJobId.value.isEmpty) return;
              if (controller.applicants.isEmpty) {
                Get.snackbar(
                  "Empty".tr, // 🟢 Added .tr
                  "No candidates to export.".tr, // 🟢 Added .tr
                  backgroundColor: isDark
                      ? Colors.orangeAccent.withValues(alpha: 0.15)
                      : Colors.orange.shade50,
                  colorText: isDark
                      ? Colors.orangeAccent
                      : Colors.orange.shade900,
                );
                return;
              }

              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBackground
                        : Colors.white, // 🟢 Dynamic Export Sheet BG
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Export Candidates".tr, // 🟢 Added .tr
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.error.withValues(alpha: 0.15)
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            LucideIcons.fileText,
                            color: isDark ? Colors.redAccent : Colors.redAccent,
                          ),
                        ),
                        title: Text(
                          "Export as PDF".tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ), // 🟢 Added .tr
                        subtitle: Text(
                          "Best for printing interview scorecards"
                              .tr, // 🟢 Added .tr
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Colors.grey,
                          ),
                        ),
                        onTap: () {
                          Get.back();
                          _processExport(controller, 'pdf', isDark);
                        },
                      ),
                      Divider(
                        height: 1,
                        color: isDark
                            ? AppColors.darkDivider
                            : Colors.grey.shade200,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.success.withValues(alpha: 0.15)
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            LucideIcons.table,
                            color: isDark ? Colors.greenAccent : Colors.green,
                          ),
                        ),
                        title: Text(
                          "Export as Excel".tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ), // 🟢 Added .tr
                        subtitle: Text(
                          "Best for filtering and data analysis"
                              .tr, // 🟢 Added .tr
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Colors.grey,
                          ),
                        ),
                        onTap: () {
                          Get.back();
                          _processExport(controller, 'excel', isDark);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.downloadCloud,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(
    String value,
    String text,
    IconData icon,
    String currentVal,
    bool isDark,
  ) {
    final bool isSelected = value == currentVal;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? (isDark ? Colors.blueAccent : AppColors.primary)
                : (isDark ? AppColors.darkIconSecondary : Colors.grey.shade600),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? (isDark ? Colors.blueAccent : AppColors.primary)
                  : (isDark
                        ? Colors.white
                        : Colors.black87), // 🟢 Dynamic Item Label
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processExport(
    CandidatesViewController controller,
    String type,
    bool isDark,
  ) async {
    final activeStatus = controller.tabs[controller.tabController.index];
    final jobTitle = controller.selectedJobDisplayName;

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    try {
      final exportData = await controller.applicantService.getJobApplicants(
        jobId: controller.selectedJobId.value,
        status: activeStatus,
        searchKeyword: searchCtrl.text,
        sortBy: controller.currentSort.value,
        isExport: true,
      );

      Get.back();

      if (exportData.isEmpty) {
        Get.snackbar(
          "Empty".tr, // 🟢 Added .tr
          "No candidates found.".tr, // 🟢 Added .tr
          backgroundColor: isDark
              ? Colors.orangeAccent.withValues(alpha: 0.15)
              : Colors.orange.shade50,
          colorText: isDark ? Colors.orangeAccent : Colors.orange.shade900,
        );
        return;
      }

      if (type == 'pdf') {
        await PdfExportHelper.generateAndPreviewCandidatesPdf(
          applicants: exportData,
          status: activeStatus,
          jobTitle: jobTitle,
        );
      } else if (type == 'excel') {
        await ExcelExportHelper.generateAndDownloadCandidatesExcel(
          applicants: exportData,
          status: activeStatus,
          jobTitle: jobTitle,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Failed to generate report.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
    }
  }
}
