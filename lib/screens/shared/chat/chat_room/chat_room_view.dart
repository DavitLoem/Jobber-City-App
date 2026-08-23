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
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceVariant,
      appBar: _buildAppBar(context),
      body: Obx(() {
        // ១. បង្ហាញ Loading ពេលកំពុងបង្កើតបន្ទប់ឆាត
        if (controller.isSettingUp.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // ២. បង្ហាញ Error ពេលចូលអត់បាន
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
                  ),
                ],
              ),
            ),
          );
        }

        // ៣. បង្ហាញ Chat Room ពេញលេញ
        return Column(
          children: [
            Expanded(child: _buildMessageList()),

            // 🎯 សញ្ញា Typing Indicator
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

            // 🎯 Widget វាយអក្សរដ៏ស្រស់ស្អាត
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
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
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
                  'Say hello to ${controller.args.otherPartyName.split(' ').first} 👋',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        reverse: true, // index 0 គឺនៅខាងក្រោមគេបង្អស់ (សារថ្មីបំផុត)
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

          // previous = សារចាស់ជាង (នៅខាងលើ) | next = សារថ្មីជាង (នៅខាងក្រោម)
          final previous = index < controller.messages.length - 1
              ? controller.messages[index + 1]
              : null;
          final next = index > 0 ? controller.messages[index - 1] : null;

          // 🎯 Logic ចាត់ក្រុមដូច Telegram
          // វាជាសារដំបូងនៃក្រុម (First in group) លុះត្រាតែគ្មានសារចាស់ជាងនេះ ឬសារចាស់ជារបស់អ្នកផ្សេង ឬឆ្លងថ្ងៃ
          final isFirstInGroup =
              previous == null ||
              previous.senderId != message.senderId ||
              !_isSameDay(previous.createdAt, message.createdAt);
          // វាជាសារចុងក្រោយនៃក្រុម (Last in group) លុះត្រាតែគ្មានសារថ្មីជាងនេះ ឬសារថ្មីជារបស់អ្នកផ្សេង ឬឆ្លងថ្ងៃ
          final isLastInGroup =
              next == null ||
              next.senderId != message.senderId ||
              !_isSameDay(next.createdAt, message.createdAt);

          // បង្ហាញថ្ងៃខែ នៅពីលើសារដំបូងនៃថ្ងៃនីមួយៗ
          final showDateHeader =
              previous == null ||
              !_isSameDay(previous.createdAt, message.createdAt);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDateHeader) _DateHeader(date: message.createdAt),
              MessageBubble(
                message: message,
                isMine: isMine,
                isFirstInGroup: isFirstInGroup, // 🎯 បោះទិន្នន័យនេះទៅ Bubble
                isLastInGroup: isLastInGroup, // 🎯 បោះទិន្នន័យនេះទៅ Bubble
              ),
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
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
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                // 🎯 ប្រើ Role ដើម្បីបង្ហាញជំនួសការប្រើ Live ព្រោះ Controller ថ្មីប្រើ WsService
                Text(
                  controller.args.otherPartyRole.capitalizeFirst ?? 'User',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // ឆែកមើលបើ otherPartyRole គឺ seeker មានន័យថាយើងកំពុងប្រើ App ក្នុងនាម Employer
        if (controller.args.otherPartyRole == 'seeker')
          IconButton(
            icon: const Icon(
              Icons.videocam_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: () {
              // ហៅទៅអេក្រង់ Schedule Interview ជាមួយទិន្នន័យស្រាប់ៗ[cite: 15]
              Get.toNamed(
                AppRoutes.scheduleInterview,
                arguments: ScheduleInterviewArgs(
                  seekerUserId:
                      controller.currentUserId ??
                      '', // ជំនួសដោយ Seeker ID ពិតប្រាកដពី Chat args
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

// ===============================================
// WIDGETS ជំនួយសម្រាប់ Date Header
// ===============================================

class _DateHeader extends StatelessWidget {
  final DateTime date;
  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.15),
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
  if (_isSameDay(date, now)) return 'Today';

  final yesterday = now.subtract(const Duration(days: 1));
  if (_isSameDay(date, yesterday)) return 'Yesterday';

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
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
