import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/chat/chat_rest_service.dart';
import 'package:jobber_city/core/api/services/chat/chat_ws_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/chat_model.dart';
import 'package:jobber_city/models/interview_models.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/shared/chat/chat_room/widgets/chat_input_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import 'widgets/message_bubble.dart';
import 'widgets/typing_indicator.dart';

part 'chat_room_binding.dart';
part 'chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomViewController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: _buildAppBar(context, theme, isDark),
      body: Obx(() {
        if (controller.isSettingUp.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.setupError.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    color: AppColors.error,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.setupError.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                    ), // 🟢 Dynamic Text
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(child: _buildMessageList(theme, isDark)),

            Obx(() {
              if (!controller.isOtherPartyTyping.value) {
                return const SizedBox.shrink();
              }
              return const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TypingIndicator(),
                ),
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

  Widget _buildMessageList(ThemeData theme, bool isDark) {
    return Obx(() {
      if (controller.isLoadingHistory.value && controller.messages.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
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
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.primaryLight, // 🟢 Dynamic BG
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Say hello to @name 👋'.trParams({
                    // 🟢 Added .trParams
                    'name': controller.args.otherPartyName.split(' ').first,
                  }),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                  ),
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
        itemCount:
            controller.messages.length +
            (controller.hasMoreHistory.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.messages.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            );
          }

          final message = controller.messages[index];
          final isMine = message.senderId == controller.currentUserId;

          final previous = index < controller.messages.length - 1
              ? controller.messages[index + 1]
              : null;
          final next = index > 0 ? controller.messages[index - 1] : null;

          final isFirstInGroup =
              previous == null ||
              previous.senderId != message.senderId ||
              !_isSameDay(previous.createdAt, message.createdAt);
          final isLastInGroup =
              next == null ||
              next.senderId != message.senderId ||
              !_isSameDay(next.createdAt, message.createdAt);

          final showDateHeader =
              previous == null ||
              !_isSameDay(previous.createdAt, message.createdAt);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDateHeader)
                _DateHeader(
                  date: message.createdAt,
                  isDark: isDark,
                ), // 🟢 Passed Theme State
              MessageBubble(
                message: message,
                isMine: isMine,
                isFirstInGroup: isFirstInGroup,
                isLastInGroup: isLastInGroup,
              ),
            ],
          );
        },
      );
    });
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          LucideIcons.arrowLeft,
          color: theme.textTheme.bodyLarge?.color,
        ), // 🟢 Dynamic Icon
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.darkSurfaceElevated
                  : AppColors.primaryLight, // 🟢 Dynamic BG
            ),
            clipBehavior: Clip.hardEdge,
            child:
                controller.args.otherPartyAvatarUrl != null &&
                    controller.args.otherPartyAvatarUrl!.isNotEmpty
                ? Image.network(
                    controller.args.otherPartyAvatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _avatarFallback(),
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
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
                  ),
                ),
                Text(
                  (controller.args.otherPartyRole.capitalizeFirst ?? 'User')
                      .tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textTertiary, // 🟢 Dynamic Subtext
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (controller.args.otherPartyRole == 'seeker')
          IconButton(
            icon: const Icon(
              Icons.videocam_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: () {
              Get.toNamed(
                AppRoutes.scheduleInterview,
                arguments: ScheduleInterviewArgs(
                  seekerUserId: controller.currentUserId ?? '',
                  seekerName: controller.args.otherPartyName,
                  seekerAvatarUrl: controller.args.otherPartyAvatarUrl,
                ),
              );
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _avatarFallback() {
    final name = controller.args.otherPartyName;
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;
  final bool isDark; // 🟢 Added isDark
  const _DateHeader({required this.date, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(
                    alpha: 0.15,
                  ), // 🟢 Overlay adjustments for dark mode
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _formatDateHeader(date),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _formatDateHeader(DateTime date) {
  final now = DateTime.now();
  if (_isSameDay(date, now)) return 'Today'.tr; // 🟢 Added .tr

  final yesterday = now.subtract(const Duration(days: 1));
  if (_isSameDay(date, yesterday)) return 'Yesterday'.tr; // 🟢 Added .tr

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1].tr} ${date.day}, ${date.year}'; // 🟢 Added .tr to Month String
}
