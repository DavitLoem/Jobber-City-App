import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/employer/my_job/widgets/job_card_item.dart';
import 'package:jobber_city/screens/role/employer/my_job/widgets/job_search_bar.dart';
import 'package:jobber_city/screens/role/employer/my_job/widgets/job_status_tabs.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'my_job_binding.dart';
part 'my_job_controller.dart';

class MyJobView extends GetView<MyJobViewController> {
  const MyJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ដាក់ផ្ទៃខាងក្រោយពណ៌ស
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Jobs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [_buildNewJobButton()],
      ),

      // ── ផ្គុំ Widgets ទាំង៣ បញ្ចូលគ្នា ──
      body: Column(
        children: [
          // 1. ប្រអប់ Search និង Filter
          JobSearchBar(
            searchController: TextEditingController(),
            onChanged: (val) {},
            onSortTap: () {},
          ),

          const SizedBox(height: 10),

          JobStatusTabs(
            tabs: const ['All (35)', 'Active (15)', 'Paused (5)', 'Draft (2)'],
            selectedTab: 'All (35)',
            onTabChanged: (tab) {},
          ),

          const SizedBox(height: 20),

          // 3. បញ្ជីការងារ (Job Cards List)
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: 3, // បង្ហាញ ៣កាតសាកល្បងសិន
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                // ── គូរ Static Data សម្រាប់តេស្ត UI ──
                if (index == 0) {
                  return JobCardItem(
                    title: "Senior Product Designer",
                    department: "Design",
                    location: "Remote • Global",
                    timeAgo: "2d ago",
                    status: "active",
                    isUrgent: true,
                    candidatesCount: 84,
                    onTap: () {},
                  );
                } else if (index == 1) {
                  return JobCardItem(
                    title: "Full Stack Engineer",
                    department: "Engineering",
                    location: "New York, NY",
                    timeAgo: "5d ago",
                    status: "active",
                    candidatesCount: 127,
                    onTap: () {},
                  );
                } else {
                  return JobCardItem(
                    title: "Growth Marketing Lead",
                    department: "Marketing",
                    location: "Phnom Penh",
                    timeAgo: "1w ago",
                    status: "draft",
                    candidatesCount: 0,
                    onTap: () {},
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── ប៊ូតុង + New Job (ទុកដូចដើម) ──
  InkWell _buildNewJobButton() {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.newJob);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF4f7df7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.plus, color: Colors.white, size: 18),
            const SizedBox(width: 4),
            const Text(
              'New Job',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
