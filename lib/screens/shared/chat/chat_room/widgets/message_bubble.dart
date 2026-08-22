import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/chat_model.dart';

import '../chat_room_view.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  final bool isFirstInGroup;
  final bool isLastInGroup;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
  });

  @override
  Widget build(BuildContext context) {
    final isFailed = message.status == 'failed';
    // 🎯 ឆែកមើលថាតើសារនេះលុបរួចឬនៅ
    final isDeleted = message.isDeletedForEveryone;

    return GestureDetector(
      // 🎯 ពេលចុចសង្កត់ ហៅ Bottom Sheet ចេញពី Controller
      onLongPress: () {
        if (!isDeleted) {
          Get.find<ChatRoomViewController>().showDeleteOptions(message);
        }
      },
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            bottom: isLastInGroup ? 10 : 2,
            left: isMine ? 48 : 0,
            right: isMine ? 0 : 48,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            // 🎯 បើលុបហើយ ដូរពណ៌ទៅជាប្រផេះស្រាល
            color: isDeleted
                ? Colors.grey.shade200
                : (isFailed
                      ? AppColors.errorBackground
                      : (isMine ? const Color(0xFF4F7DF7) : Colors.white)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMine ? 16 : (isFirstInGroup ? 16 : 4)),
              bottomLeft: Radius.circular(
                isMine ? 16 : (isLastInGroup ? 0 : 4),
              ),
              topRight: Radius.circular(
                isMine ? (isFirstInGroup ? 16 : 4) : 16,
              ),
              bottomRight: Radius.circular(
                isMine ? (isLastInGroup ? 0 : 4) : 16,
              ),
            ),
            border: (isMine || isFailed || isDeleted)
                ? null
                : Border.all(color: Colors.grey.shade200),
            boxShadow: (isMine && !isDeleted)
                ? [
                    BoxShadow(
                      color: const Color(0xFF4F7DF7).withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 0),
                child: isDeleted
                    // 🎯 បង្ហាញអក្សរ Tombstone ជំនួសអត្ថបទដើម
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.block, size: 14, color: Colors.black54),
                          SizedBox(width: 4),
                          Text(
                            "This message was deleted",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      )
                    // បង្ហាញអត្ថបទធម្មតា
                    : Text(
                        message.content,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.35,
                          color: isFailed
                              ? AppColors.error
                              : (isMine ? Colors.white : Colors.black87),
                        ),
                      ),
              ),
              // 🎯 ម៉ោងក៏ត្រូវលាក់ ឬ ប្តូរពណ៌ដែរ បើលុបហើយ
              if (!isDeleted)
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatBubbleTime(message.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: isMine
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.grey.shade500,
                        ),
                      ),
                      if (isMine) ...[
                        const SizedBox(width: 4),
                        _StatusIcon(message: message, isMine: isMine),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;

  const _StatusIcon({required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    if (message.status == 'failed') {
      return const Icon(
        Icons.error_outline_rounded,
        size: 14,
        color: Colors.redAccent,
      );
    }
    if (message.isPending || message.status == 'sending') {
      return SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: isMine ? Colors.white70 : Colors.grey,
        ),
      );
    }
    if (message.status == 'read') {
      return Icon(
        Icons.done_all_rounded,
        size: 16,
        color: isMine ? Colors.white : Colors.blue,
      );
    }
    return Icon(
      Icons.done_rounded,
      size: 16,
      color: isMine ? Colors.white70 : Colors.grey,
    );
  }
}

String _formatBubbleTime(DateTime dt) {
  DateTime localDt = dt.toLocal();

  int hour12 = localDt.hour % 12;
  if (hour12 == 0) hour12 = 12;

  final String amPm = localDt.hour >= 12 ? 'PM' : 'AM';
  final String minute = localDt.minute.toString().padLeft(2, '0');

  return '$hour12:$minute $amPm';
}
