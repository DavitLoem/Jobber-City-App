import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/previews/chat_room_preview.dart';

class ConversationListPreview extends StatelessWidget {
  const ConversationListPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 ទិន្នន័យសិប្បនិម្មិត (Mock Data) សម្រាប់បញ្ជីឆាត
    final List<Map<String, dynamic>> mockConversations = [
      {
        "name": "Tech Company",
        "avatarUrl":
            "https://ui-avatars.com/api/?name=Tech+Company&background=0D8ABC&color=fff",
        "lastMessage":
            "ប្រាកដណាស់ យើងនឹងកំណត់កាលវិភាគនៅសប្តាហ៍ក្រោយ។ លម្អិតខ្ញុំនឹងផ្ញើជូនបន្តិចទៀត។",
        "time": "10:35 AM",
        "unreadCount": 2,
        "isOnline": true,
      },
      {
        "name": "Sopheap Developer",
        "avatarUrl":
            "https://ui-avatars.com/api/?name=Sopheap+Dev&background=random",
        "lastMessage": "តើប្រាក់ខែគោលសម្រាប់តំណែងនេះប៉ុន្មានដែរ?",
        "time": "ម្សិលមិញ",
        "unreadCount": 0,
        "isOnline": false,
      },
      {
        "name": "Global Tech Bank",
        "avatarUrl":
            "https://ui-avatars.com/api/?name=Global+Bank&background=random",
        "lastMessage": "សូមផ្ញើប្រវត្តិរូបសង្ខេប (CV) របស់អ្នកមកម្តងទៀតមក។",
        "time": "ច័ន្ទ",
        "unreadCount": 1,
        "isOnline": true,
      },
      {
        "name": "Kompheak Design",
        "avatarUrl":
            "https://ui-avatars.com/api/?name=Kompheak+Design&background=random",
        "lastMessage": "អរគុណសម្រាប់ឱកាសនេះ!",
        "time": "12 Aug",
        "unreadCount": 0,
        "isOnline": false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Messages",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: mockConversations.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              itemCount: mockConversations.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade200,
                indent: 80, // កាត់បន្ទាត់ត្រឹមក្រោយរូប Avatar
              ),
              itemBuilder: (context, index) {
                final convo = mockConversations[index];
                return ConversationTilePreview(
                  name: convo['name'],
                  avatarUrl: convo['avatarUrl'],
                  lastMessage: convo['lastMessage'],
                  time: convo['time'],
                  unreadCount: convo['unreadCount'],
                  isOnline: convo['isOnline'],
                  onTap: () {
                    // 🎯 ចុចនៅទីនេះដើម្បីលោតទៅអេក្រង់ ChatRoom មុននោះ
                    Get.to(() => const ChatRoomPreview());
                    // Get.snackbar("បើកឆាត", "លោតទៅឆាតជាមួយ ${convo['name']}");
                  },
                );
              },
            ),
    );
  }

  // 🎯 បង្ហាញ UI ពេលគ្មានអ្នកឆាតសោះ
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            "No messages yet",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "When you connect with employers or job seekers,\nyour chats will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 🎯 Widget សម្រាប់ Item បញ្ជីឆាតនីមួយៗ
// ==========================================
class ConversationTilePreview extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final VoidCallback onTap;

  const ConversationTilePreview({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread = unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 🎯 រូប Avatar និងសញ្ញា Online
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: Colors.grey.shade200,
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // 🎯 ឈ្មោះ និងសារចុងក្រោយ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isUnread
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isUnread ? Colors.black87 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // បើវែងពេកចេញសញ្ញា ...
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // 🎯 ម៉ោង និងចំនួនសារមិនទាន់អាន (Badge)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnread ? Colors.blue : Colors.grey.shade500,
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 6),
                if (isUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue, // ពណ៌ Badge (ប្តូរតាម Theme បាន)
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount > 99 ? "99+" : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20), // រក្សាកម្ពស់កុំឱ្យ UI រង្គើ
              ],
            ),
          ],
        ),
      ),
    );
  }
}
