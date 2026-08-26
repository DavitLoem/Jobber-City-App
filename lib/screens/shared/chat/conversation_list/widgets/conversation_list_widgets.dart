import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/models/chat_model.dart';

// 🎯 ១. Widget សម្រាប់ Search Bar
class ConversationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  const ConversationSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.scaffoldBackgroundColor, // 🟢 Dynamic Container BG
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
        ), // 🟢 Dynamic Text
        decoration: InputDecoration(
          hintText: 'Search messages...'.tr, // 🟢 Added .tr
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.darkTextHint
                : Colors.grey.shade500, // 🟢 Dynamic Hint
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark
                ? AppColors.darkIconSecondary
                : Colors.grey.shade500, // 🟢 Dynamic Icon
            size: 22,
          ),
          filled: true,
          fillColor: isDark
              ? AppColors.darkInputBackground
              : const Color(0xFFF8F9FA), // 🟢 Dynamic Input BG
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasUnread = conversation.unreadCount > 0;
    final other = conversation.otherParty;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
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
                            color: theme
                                .textTheme
                                .bodyLarge
                                ?.color, // 🟢 Dynamic Name Text
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTimestamp(conversation.lastMessageAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : Colors
                                          .grey
                                          .shade500), // 🟢 Dynamic Time Text
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
                              : 'Say hello 👋'.tr, // 🟢 Added .tr
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: hasUnread
                                ? (isDark ? Colors.white : Colors.black87)
                                : (isDark
                                      ? AppColors.darkTextSecondary
                                      : Colors
                                            .grey
                                            .shade600), // 🟢 Dynamic Last Msg Text
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
                            color: AppColors.primary,
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
    final theme = Theme.of(context); // 🟢 Theme Check

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
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
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.scaffoldBackgroundColor,
                  width: 2,
                ), // 🟢 Matches background cleanly
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
          color: AppColors.primary,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearching
                    ? Icons.search_off_rounded
                    : Icons.chat_bubble_outline_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearching
                  ? 'No messages found'.tr
                  : 'No conversations yet'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try searching with a different name.'
                        .tr // 🟢 Added .tr
                  : 'When you message someone, it will show up here.'
                        .tr, // 🟢 Added .tr
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade600, // 🟢 Dynamic Subtext
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: isDark
                  ? AppColors.darkIconSecondary
                  : Colors.grey.shade400,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              message, // Already translated from controller
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade600,
              ), // 🟢 Dynamic Subtext
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Try Again'.tr, // 🟢 Added .tr
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTimestamp(DateTime? dt) {
  if (dt == null) return '';

  DateTime localDt = dt.toLocal();
  localDt = localDt.add(const Duration(hours: 7));

  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final messageDate = DateTime(localDt.year, localDt.month, localDt.day);
  final differenceInDays = today.difference(messageDate).inDays;

  if (differenceInDays == 0) {
    int hour12 = localDt.hour % 12;
    if (hour12 == 0) hour12 = 12;

    final String amPm = localDt.hour >= 12 ? 'PM'.tr : 'AM'.tr; // 🟢 Added .tr
    final String minute = localDt.minute.toString().padLeft(2, '0');

    return '$hour12:$minute $amPm';
  } else if (differenceInDays == 1) {
    return 'Yesterday'.tr; // 🟢 Added .tr
  } else if (differenceInDays < 7) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[localDt.weekday - 1].tr; // 🟢 Added .tr
  } else {
    return '${localDt.day.toString().padLeft(2, '0')}/${localDt.month.toString().padLeft(2, '0')}/${localDt.year}';
  }
}
