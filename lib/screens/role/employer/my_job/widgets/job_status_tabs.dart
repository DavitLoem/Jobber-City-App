import 'package:flutter/material.dart';

class JobStatusTabs extends StatelessWidget {
  // បញ្ជីឈ្មោះ Tab (ឧ. ['All (35)', 'Active (15)', 'Paused (5)', 'Draft (2)'])
  final List<String> tabs;
  // Tab ដែលកំពុងត្រូវបានជ្រើសរើសបច្ចុប្បន្ន
  final String selectedTab;
  // មុខងារពេលចុចលើ Tab ណាមួយ
  final ValueChanged<String> onTabChanged;

  const JobStatusTabs({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 👈 អនុញ្ញាតឱ្យអូសទៅឆ្វេងស្តាំបាន
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // លាក់របារ Scroll ខាងក្រោម
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == selectedTab;

          return Padding(
            padding: const EdgeInsets.only(right: 10), // ចន្លោះរវាងប៊ូតុងនីមួយៗ
            child: InkWell(
              onTap: () => onTabChanged(tab),
              borderRadius: BorderRadius.circular(20), // ឱ្យរាងមូលស្អាតពេលចុច
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  // ពណ៌ផ្ទៃ: បើចុចយកពណ៌ខៀវ បើមិនចុចយកពណ៌ស
                  color: isSelected ? const Color(0xFF4f7df7) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    // ពណ៌បន្ទាត់ជុំវិញ
                    color: isSelected
                        ? const Color(0xFF4f7df7)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    // ពណ៌អក្សរ: បើចុចយកពណ៌ស បើមិនចុចយកពណ៌ប្រផេះ
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
