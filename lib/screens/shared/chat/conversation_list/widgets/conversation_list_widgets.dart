import 'package:flutter/material.dart';
import 'package:jobber_city/models/chat_model.dart';

// 🎯 ១. Widget សម្រាប់ Search Bar
class ConversationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  const ConversationSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search messages...',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade500,
            size: 22,
          ),
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// 🎯 ២. Widget សម្រាប់បង្ហាញ Chat មួយៗ
class ConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = conversation.unreadCount > 0;
    final other = conversation.otherParty;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(
              name: other.name,
              avatarUrl: other.avatarUrl,
              isOnline: other.isOnline,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          other.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: hasUnread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTimestamp(conversation.lastMessageAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread
                              ? const Color(0xFF4F7DF7)
                              : Colors.grey.shade500,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage?.isNotEmpty == true
                              ? conversation.lastMessage!
                              : 'Say hello 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: hasUnread
                                ? Colors.black87
                                : Colors.grey.shade600,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          constraints: const BoxConstraints(minWidth: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F7DF7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            conversation.unreadCount > 99
                                ? '99+'
                                : '${conversation.unreadCount}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

class _Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isOnline;

  const _Avatar({required this.name, this.avatarUrl, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4F7DF7).withValues(alpha: 0.1),
          ),
          clipBehavior: Clip.hardEdge,
          child: avatarUrl != null && avatarUrl!.isNotEmpty
              ? Image.network(
                  avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _fallback(),
                )
              : _fallback(),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _fallback() {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF4F7DF7),
        ),
      ),
    );
  }
}

class ConversationEmptyState extends StatelessWidget {
  final bool isSearching;
  const ConversationEmptyState({super.key, this.isSearching = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFF4F7DF7).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearching
                    ? Icons.search_off_rounded
                    : Icons.chat_bubble_outline_rounded,
                color: const Color(0xFF4F7DF7),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearching ? 'No messages found' : 'No conversations yet',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try searching with a different name.'
                  : 'When you message someone, it will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConversationErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ConversationErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.grey.shade400, size: 40),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F7DF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🎯 អនុគមន៍បំប្លែងម៉ោងឱ្យត្រូវស្តង់ដារ Chat ពិតប្រាកដ
// 🎯 អនុគមន៍បំប្លែងម៉ោងឱ្យត្រូវស្តង់ដារ Chat (AM/PM)
String _formatTimestamp(DateTime? dt) {
  if (dt == null) return '';

  // ១. បំប្លែងទៅម៉ោង Local សិន
  DateTime localDt = dt.toLocal();

  // 🎯 ២. ជួសជុលម៉ោងកម្ពុជា (Timezone Fix)
  // ប្រសិនបើម៉ោងនៅតែខុស (ដើរយឺតជាងកម្ពុជា ៧ម៉ោង) សូមដកសញ្ញា Comment (//) នៅខាងក្រោមចេញ ដើម្បីបង្ខំបូក ៧ម៉ោង៖
  localDt = localDt.add(const Duration(hours: 7));

  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final messageDate = DateTime(localDt.year, localDt.month, localDt.day);
  final differenceInDays = today.difference(messageDate).inDays;

  if (differenceInDays == 0) {
    // 🎯 ៣. រៀបចំទម្រង់ 12 ម៉ោង និងបន្ថែម AM/PM
    int hour12 = localDt.hour % 12;
    if (hour12 == 0) hour12 = 12; // បើត្រូវម៉ោង 0 ឫ 12 ថ្ងៃត្រង់ វានឹងលោតលេខ 12

    final String amPm = localDt.hour >= 12 ? 'PM' : 'AM';
    final String minute = localDt.minute.toString().padLeft(2, '0');

    return '$hour12:$minute $amPm'; // ឧ. 4:42 PM
  } else if (differenceInDays == 1) {
    return 'Yesterday';
  } else if (differenceInDays < 7) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[localDt.weekday - 1];
  } else {
    return '${localDt.day.toString().padLeft(2, '0')}/${localDt.month.toString().padLeft(2, '0')}/${localDt.year}';
  }
}
