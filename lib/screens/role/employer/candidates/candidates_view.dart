import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'candidates_binding.dart';
part 'candidates_controller.dart';

class CandidatesView extends GetView<CandidatesViewController> {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Candidates',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.search, color: Colors.black87),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // ── 🎯 ផ្នែកថ្មី៖ Job Filter Dropdown ──
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.briefcase,
                      size: 20,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value:
                              'all', // តម្លៃសាកល្បង (ក្រោយមកប្រើ controller.selectedJobId.value)
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
                            DropdownMenuItem(
                              value: 'all',
                              child: Text("All Jobs"),
                            ),
                            DropdownMenuItem(
                              value: 'job_1',
                              child: Text("Senior Flutter Developer"),
                            ),
                            DropdownMenuItem(
                              value: 'job_2',
                              child: Text("UX/UI Designer"),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── ផ្នែក TabBar ──
            Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: const Color(0xFF4f7df7),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF4f7df7),
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                dividerColor: Colors.grey.shade200,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: "New (3)"),
                  Tab(text: "Shortlisted (2)"),
                  Tab(text: "Interviewed"),
                  Tab(text: "Rejected"),
                ],
              ),
            ),

            // ── ផ្នែកបញ្ជីបេក្ខជន ──
            const Expanded(
              child: TabBarView(
                children: [
                  _CandidateList(), // New
                  _CandidateList(), // Shortlisted
                  Center(
                    child: Text(
                      "No candidates interviewed yet.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Center(
                    child: Text(
                      "No rejected candidates.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ==========================================
// ── មុខងារជំនួយសម្រាប់សង់ UI (Helper Widgets) ──
// ==========================================

class _CandidateList extends StatelessWidget {
  const _CandidateList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 3, // ចំនួនទិន្នន័យសាកល្បង
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildCandidateCard();
      },
    );
  }

  Widget _buildCandidateCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ផ្នែកខាងលើ៖ រូបថត, ឈ្មោះ, និងតួនាទី
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: const NetworkImage(
                  "https://i.pravatar.cc/150?img=11", // រូបភាពសាកល្បង
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sokmakara Chhean",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Applied for: Senior Flutter Developer",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.calendar,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Applied 2 days ago",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ផ្នែកកណ្តាល៖ ជំនាញ (Skills)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSkillChip("Flutter"),
              _buildSkillChip("Dart"),
              _buildSkillChip("3 Yrs Exp"),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ),

          // ផ្នែកខាងក្រោម៖ ប៊ូតុងសកម្មភាព (Actions)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // មុខងារទាញយក ឬមើល CV
                  },
                  icon: const Icon(LucideIcons.fileText, size: 18),
                  label: const Text("View CV"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4f7df7),
                    side: const BorderSide(color: Color(0xFF4f7df7)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // ចូលទៅកាន់ Profile លម្អិតរបស់បេក្ខជន
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4f7df7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "View Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF4f7df7),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
