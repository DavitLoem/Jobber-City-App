import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:jobber_city/core/api/network/chat_socket_service.dart';
import 'package:jobber_city/core/api/services/chat/chat_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/jwt_utils.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/chat/chat_models.dart';
import 'package:jobber_city/screens/shared/chat/chat_thread/widgets/chat_input_bar.dart';
import 'package:jobber_city/screens/shared/chat/chat_thread/widgets/message_bubble.dart';
import 'package:jobber_city/screens/shared/chat/chat_thread/widgets/typing_indicator.dart';

part 'chat_thread_controller.dart';

/// One-on-one conversation screen shared by both seeker and employer —
/// opened either with an existing `conversationId` (from the inbox) or with
/// just an `otherUserId` (from a "Message" button, e.g. on a candidate's
/// profile), in which case the conversation is created on the fly.
class ChatThreadView extends GetView<ChatThreadViewController> {
  const ChatThreadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceVariant,
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isSettingUp.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.setupError.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.alertCircle, color: AppColors.error, size: 40),
                  const SizedBox(height: 16),
                  Text(controller.setupError.value, textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(child: _buildMessageList()),
            Obx(() {
              if (!controller.isOtherPartyTyping.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Align(alignment: Alignment.centerLeft, child: const TypingIndicator()),
              );
            }),
            ChatInputBar(
              controller: controller.textController,
              onChanged: controller.onTextChanged,
              onSend: controller.sendMessage,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMessageList() {
    return Obx(() {
      if (controller.isLoadingHistory.value && controller.messages.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary, size: 30),
                ),
                const SizedBox(height: 16),
                Text(
                  'Say hello to ${controller.args.otherPartyName.split(' ').first} 👋',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        reverse: true,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        itemCount: controller.messages.length + (controller.hasMoreHistory.value ? 1 : 0),
        itemBuilder: (context, index) {
          // Extra trailing item (in reversed terms, this renders at the very
          // top) is the "loading more history" spinner.
          if (index == controller.messages.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
            );
          }

          final i = controller.messages.length - 1 - index;
          final message = controller.messages[i];
          final isMine = message.senderId == controller.currentUserId;

          final previous = i > 0 ? controller.messages[i - 1] : null;
          final next = i < controller.messages.length - 1 ? controller.messages[i + 1] : null;

          final showDateHeader = previous == null || !_isSameDay(previous.createdAt, message.createdAt);
          // Group consecutive bubbles from the same sender close together,
          // only show timestamp/status tail on the last one of the group.
          final showTail = next == null || next.senderId != message.senderId || !_isSameDay(next.createdAt, message.createdAt);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDateHeader) _DateHeader(date: message.createdAt),
              MessageBubble(message: message, isMine: isMine, showTail: showTail),
            ],
          );
        },
      );
    });
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLight),
            clipBehavior: Clip.hardEdge,
            child: controller.args.otherPartyAvatarUrl != null && controller.args.otherPartyAvatarUrl!.isNotEmpty
                ? Image.network(
                    controller.args.otherPartyAvatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatarFallback(),
                  )
                : _avatarFallback(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.args.otherPartyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Obx(() => Text(
                      _connectionLabel(controller.socket.status.value),
                      style: TextStyle(
                        fontSize: 11.5,
                        color: controller.socket.status.value == ChatSocketStatus.connected
                            ? AppColors.success
                            : AppColors.textTertiary,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback() {
    final name = controller.args.otherPartyName;
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;
  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(20)),
          child: Text(
            _formatDateHeader(date),
            style: const TextStyle(fontSize: 11.5, color: AppColors.textTertiary, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

String _formatDateHeader(DateTime date) {
  final now = DateTime.now();
  if (_isSameDay(date, now)) return 'Today';

  final yesterday = now.subtract(const Duration(days: 1));
  if (_isSameDay(date, yesterday)) return 'Yesterday';

  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

String _connectionLabel(ChatSocketStatus status) {
  switch (status) {
    case ChatSocketStatus.connected:
      return 'Live';
    case ChatSocketStatus.connecting:
      return 'Connecting…';
    case ChatSocketStatus.reconnecting:
      return 'Reconnecting…';
    case ChatSocketStatus.disconnected:
      return 'Offline';
  }
}
