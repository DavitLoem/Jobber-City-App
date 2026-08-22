import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomPreview extends StatelessWidget {
  const ChatRoomPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 ទិន្នន័យសិប្បនិម្មិត (Mock Data) សម្រាប់មើលទម្រង់ UI
    final List<Map<String, dynamic>> mockMessages = [
      {
        "text": "សួស្តី! តើបេក្ខជននៅចាប់អារម្មណ៍ការងារនេះដែរឬទេ?",
        "isMe": false, // ផ្ញើមកពី Employer
        "time": "10:30 AM",
      },
      {
        "text": "បាទ/ចាស សួស្តី! ខ្ញុំពិតជាចាប់អារម្មណ៍ខ្លាំងមែនទែន។",
        "isMe": true, // យើងជាអ្នកផ្ញើ (Seeker)
        "time": "10:32 AM",
      },
      {
        "text": "តើអាចឱ្យខ្ញុំដឹងពីកាលវិភាគសម្ភាសន៍បានទេ?",
        "isMe": true,
        "time": "10:32 AM",
      },
      {
        "text":
            "ប្រាកដណាស់ យើងនឹងកំណត់កាលវិភាគនៅសប្តាហ៍ក្រោយ។ លម្អិតខ្ញុំនឹងផ្ញើជូនបន្តិចទៀត។",
        "isMe": false,
        "time": "10:35 AM",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // ពណ៌ Background រាងប្រផេះស្រាល
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            // រូប Profile Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: const NetworkImage(
                "https://ui-avatars.com/api/?name=Tech+Company&background=random",
              ),
            ),
            const SizedBox(width: 12),
            // ឈ្មោះ និង Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tech Company",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Online",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 🎯 ផ្នែកបង្ហាញសារ (Messages List)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockMessages.length,
              itemBuilder: (context, index) {
                final msg = mockMessages[index];
                return ChatBubblePreview(
                  text: msg['text'],
                  isMe: msg['isMe'],
                  time: msg['time'],
                );
              },
            ),
          ),

          // 🎯 ផ្នែកសម្រាប់វាយអក្សរ (Input Field)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "វាយសារនៅទីនេះ...",
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 🎯 Widget សម្រាប់ស្នាមពពុះសារ (Chat Bubble)
// លោកអ្នកអាចកាត់វាទៅដាក់ក្នុង folder `widgets/` ពេលក្រោយបាន
// ==========================================
class ChatBubblePreview extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const ChatBubblePreview({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            width:
                MediaQuery.of(context).size.width *
                0.75, // កុំឱ្យអក្សរវែងពេញអេក្រង់
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // បង្ហាញម៉ោង
          Text(
            time,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
