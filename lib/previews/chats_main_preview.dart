import 'package:flutter/material.dart';

// ⚠️ លោកអ្នកអាច Uncomment បន្ទាត់ខាងក្រោមនៅពេលចង់ភ្ជាប់អេក្រង់ Chat ពិតប្រាកដ
// import 'package:jobber_city/screens/role/employer/conversation_list/conversation_list_view.dart';

class ChatsMainView extends StatelessWidget {
  const ChatsMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // ចំនួន Tabs ទាំង ២
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            'Communications', // ដាក់ឈ្មោះរួម ព្រោះមានទាំង Chat និង Interview
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFF4F7DF7),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF4F7DF7),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            tabs: [
              Tab(text: 'Messages'),
              Tab(text: 'Interviews'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // ទីតាំងទី ១៖ អេក្រង់សារ (ពេលប្រើពិតប្រាកដ ជំនួសដោយ ConversationListView())
            Center(
              child: Text(
                "Conversation List (Chat) Goes Here",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            // ទីតាំងទី ២៖ UI Preview សម្រាប់បញ្ជីការសម្ភាសន៍
            _InterviewListPreview(),
          ],
        ),
      ),
    );
  }
}

// ========================================================
// 🎨 UI Preview សម្រាប់ Interview (មិនទាន់ភ្ជាប់ Controller)
// ========================================================

class _InterviewListPreview extends StatefulWidget {
  const _InterviewListPreview();

  @override
  State<_InterviewListPreview> createState() => _InterviewListPreviewState();
}

class _InterviewListPreviewState extends State<_InterviewListPreview> {
  // ប្រើសម្រាប់ប្តូរ Tab តូចៗ (Upcoming / Past)
  bool isUpcomingTab = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🎯 1. របារជ្រើសរើស Upcoming / Past
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: _buildSubTab('Upcoming', true)),
                Expanded(child: _buildSubTab('Past', false)),
              ],
            ),
          ),
        ),

        // 🎯 2. បញ្ជីទិន្នន័យគំរូ (Mock Data)
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: isUpcomingTab ? 2 : 1, // ទិន្នន័យសាកល្បង
            separatorBuilder: (_, __) =>
                Divider(height: 1, indent: 82, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              if (isUpcomingTab) {
                return _MockInterviewTile(
                  name: index == 0 ? 'Rofath Sles' : 'Sokha Chea',
                  jobTitle: 'Senior Flutter Developer',
                  dateStr: index == 0 ? 'Today, 2:30 PM' : 'Aug 25, 10:00 AM',
                  status: index == 0 ? 'Live Now' : 'Scheduled',
                  statusColor: index == 0
                      ? const Color(0xFF10B981)
                      : const Color(0xFF4F7DF7),
                );
              } else {
                return const _MockInterviewTile(
                  name: 'William Anderson',
                  jobTitle: 'UI/UX Designer',
                  dateStr: 'Yesterday, 9:00 AM',
                  status: 'Completed',
                  statusColor: Colors.grey,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubTab(String label, bool isUpcoming) {
    final isSelected = isUpcomingTab == isUpcoming;
    return GestureDetector(
      onTap: () => setState(() => isUpcomingTab = isUpcoming),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? const Color(0xFF4F7DF7) : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}

// 🎯 កាតគំរូសម្រាប់បង្ហាញការសម្ភាសន៍នីមួយៗ
class _MockInterviewTile extends StatelessWidget {
  final String name;
  final String jobTitle;
  final String dateStr;
  final String status;
  final Color statusColor;

  const _MockInterviewTile({
    required this.name,
    required this.jobTitle,
    required this.dateStr,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // សម្រាប់ធ្វើតេស្តការចុច
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Clicked on $name')));
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // រូបតំណាង (Avatar)
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4F7DF7).withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF4F7DF7),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // ព័ត៌មានលម្អិត
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Badge បង្ហាញស្ថានភាព
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jobTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF4F7DF7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.event_rounded,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '30 min',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
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
