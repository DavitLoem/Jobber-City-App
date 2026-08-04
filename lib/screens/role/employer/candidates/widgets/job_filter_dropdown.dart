import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../candidates_view.dart';

class JobFilterDropdown extends GetView<CandidatesViewController> {
  const JobFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.briefcase, size: 20, color: Colors.grey.shade500),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedJobId.value.isNotEmpty
                        ? controller.selectedJobId.value
                        : 'all',
                    isExpanded: true,
                    icon: Icon(
                      LucideIcons.chevronDown,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text("All Jobs")),
                      // Map ទិន្នន័យ Job ពិតប្រាកដរបស់អ្នកនៅទីនេះ
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedJobId.value = value;
                        controller.fetchApplicants(); // ហៅ API សារថ្មី
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
