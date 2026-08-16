import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/utils/excel_export_helper.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/utils/pdf_export_helper.dart';
import '../candidates_view.dart'; // Import controller របស់អ្នក

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // ── ប្រអប់ Search ──
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: searchCtrl,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: "Search candidates, skills...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  suffixIcon: searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            LucideIcons.xCircle,
                            color: Colors.grey.shade400,
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

          // ── 🟢 ប៊ូតុង Sort Option (Popup Menu) ──
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Obx(() {
              final String currentVal = controller.currentSort.value;

              return PopupMenuButton<String>(
                icon: Icon(
                  LucideIcons.arrowUpDown,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                elevation: 4,
                position: PopupMenuPosition.under,
                onSelected: (String value) {
                  controller.changeSortOption(value);
                },
                itemBuilder: (BuildContext context) => [
                  _buildPopupItem(
                    'newest',
                    'Newest Applied',
                    LucideIcons.clock,
                    currentVal,
                  ),
                  _buildPopupItem(
                    'name_asc',
                    'Name (A-Z)',
                    LucideIcons.aArrowDown,
                    currentVal,
                  ),
                  _buildPopupItem(
                    'interview_asc',
                    'Nearest Interview',
                    LucideIcons.calendarClock,
                    currentVal,
                  ),
                ],
              );
            }),
          ),
          const SizedBox(width: 8),

          // ── 🟢 ប៊ូតុង Export PDF (បាន Update ថ្មី) ──
          // ── 🟢 ប៊ូតុង Export (បាន Update ឱ្យមានជម្រើសរើស) ──
          InkWell(
            onTap: () {
              if (controller.selectedJobId.value.isEmpty) return;
              if (controller.applicants.isEmpty) {
                Get.snackbar(
                  "Empty",
                  "No candidates to export.",
                  backgroundColor: Colors.orange.shade50,
                  colorText: Colors.orange.shade900,
                );
                return;
              }

              // លោតផ្ទាំង Bottom Sheet ឱ្យ HR ជ្រើសរើសប្រភេទ File
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Export Candidates",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ជម្រើស PDF
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            LucideIcons.fileText,
                            color: Colors.redAccent,
                          ),
                        ),
                        title: const Text("Export as PDF"),
                        subtitle: const Text(
                          "Best for printing interview scorecards",
                        ),
                        onTap: () {
                          Get.back(); // បិទ Bottom Sheet
                          _processExport(controller, 'pdf'); // ហៅអនុគមន៍ទាញយក
                        },
                      ),
                      const Divider(height: 1),
                      // ជម្រើស Excel
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            LucideIcons.table,
                            color: Colors.green,
                          ),
                        ),
                        title: const Text("Export as Excel"),
                        subtitle: const Text(
                          "Best for filtering and data analysis",
                        ),
                        onTap: () {
                          Get.back(); // បិទ Bottom Sheet
                          _processExport(controller, 'excel'); // ហៅអនុគមន៍ទាញយក
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
                color: const Color(0xFF4f7df7),
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

  // អនុគមន៍ជំនួយគូរ Menu Item ឱ្យស្អាត
  PopupMenuItem<String> _buildPopupItem(
    String value,
    String text,
    IconData icon,
    String currentVal,
  ) {
    final bool isSelected = value == currentVal;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? const Color(0xFF4f7df7) : Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? const Color(0xFF4f7df7) : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 អនុគមន៍ជំនួយសម្រាប់ហៅ API តែម្តង តែអាច Export ចេញជា ២ ទម្រង់ខុសគ្នា
  Future<void> _processExport(
    CandidatesViewController controller,
    String type,
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

      Get.back(); // បិទ Loading Dialog

      if (exportData.isEmpty) {
        Get.snackbar(
          "Empty",
          "No candidates found.",
          backgroundColor: Colors.orange.shade50,
          colorText: Colors.orange.shade900,
        );
        return;
      }

      // បែងចែកប្រភេទ File ទៅកាន់ Helper រៀងៗខ្លួន
      if (type == 'pdf') {
        await PdfExportHelper.generateAndPreviewCandidatesPdf(
          applicants: exportData,
          status: activeStatus,
          jobTitle: jobTitle,
        );
      } else if (type == 'excel') {
        // កុំភ្លេច Import ExcelExportHelper នៅខាងលើផង
        await ExcelExportHelper.generateAndDownloadCandidatesExcel(
          // 🟢 ហៅឈ្មោះថ្មីនេះ
          applicants: exportData,
          status: activeStatus,
          jobTitle: jobTitle,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Failed to generate report.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    }
  }
}
