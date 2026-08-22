import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/chat/chat_models.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  final bool showTail;
  const MessageBubble({super.key, required this.message, required this.isMine, this.showTail = true});

  @override
  Widget build(BuildContext context) {
    final isFailed = message.status == 'failed';

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: showTail ? 10 : 3,
          left: isMine ? 48 : 0,
          right: isMine ? 0 : 48,
        ),
        child: Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                // 🎯 Received bubbles need a fill that's clearly darker than
                // the screen background (lightSurfaceVariant, #F7F8FC) — a
                // near-white bubble on a near-white screen was nearly
                // invisible (esp. on a real device/screenshot), which made
                // the whole thread look unstyled even though sent/received
                // alignment was already correct.
                color: isFailed
                    ? AppColors.errorBackground
                    : (isMine ? AppColors.primary : const Color(0xFFEDEFF4)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMine || !showTail ? 16 : 4),
                  bottomRight: Radius.circular(!isMine || !showTail ? 16 : 4),
                ),
                border: isMine || isFailed ? null : Border.all(color: const Color(0xFFDADDE5)),
                boxShadow: isMine
                    ? [BoxShadow(color: AppColors.shadowLight, blurRadius: 6, offset: const Offset(0, 2))]
                    : null,
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.35,
                  color: isFailed ? AppColors.error : (isMine ? Colors.white : AppColors.textPrimary),
                ),
              ),
            ),
            if (showTail) ...[
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatBubbleTime(message.createdAt),
                    style: const TextStyle(fontSize: 10.5, color: AppColors.textTertiary),
                  ),
                  if (isMine) ...[
                    const SizedBox(width: 4),
                    _StatusIcon(message: message),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final ChatMessage message;
  const _StatusIcon({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.status == 'failed') {
      return const Icon(Icons.error_outline_rounded, size: 13, color: AppColors.error);
    }
    if (message.isPending || message.status == 'sending') {
      return const SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.textTertiary),
      );
    }
    if (message.status == 'read') {
      return const Icon(Icons.done_all_rounded, size: 14, color: AppColors.primary);
    }
    // 'sent' / 'delivered' (server persisted it, just not confirmed read yet)
    return const Icon(Icons.done_rounded, size: 14, color: AppColors.textTertiary);
  }
}

String _formatBubbleTime(DateTime dt) {
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}
