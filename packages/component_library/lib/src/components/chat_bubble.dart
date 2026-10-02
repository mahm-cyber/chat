import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import '../theme/chat_palette.dart';
import '../theme/chat_spacing.dart';
import 'chat_icon.dart';
import 'chat_text.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isOutgoing;
  final Key? testId;

  const ChatBubble({
    required this.message,
    required this.isOutgoing,
    this.testId,
    super.key,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          ),
        );
      case MessageStatus.sent:
        return const ChatIcon.check(
          size: 14,
          color: Colors.white70,
        );
      case MessageStatus.delivered:
        return const ChatIcon.doubleCheck(
          size: 14,
          color: Colors.white70,
        );
      case MessageStatus.read:
        return const ChatIcon.doubleCheck(
          size: 14,
          color: ChatPalette.emerald500,
        );
      case MessageStatus.failed:
        return const ChatIcon(
          Icons.error_outline_rounded,
          size: 14,
          color: ChatPalette.rose500,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedTestId =
        testId ?? key ?? Key('bubble_${message.id.value}');

    final bgColor = isOutgoing
        ? ChatPalette.indigo600
        : (isDark ? ChatPalette.zinc800 : ChatPalette.slate200);

    final textColor = isOutgoing
        ? Colors.white
        : (isDark ? ChatPalette.slate100 : ChatPalette.slate900);

    final timeColor = isOutgoing
        ? Colors.white70
        : (isDark ? ChatPalette.slate400 : ChatPalette.slate500);

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(ChatSpacing.radiusLg),
      topRight: const Radius.circular(ChatSpacing.radiusLg),
      bottomLeft: Radius.circular(isOutgoing ? ChatSpacing.radiusLg : ChatSpacing.radiusXs),
      bottomRight: Radius.circular(isOutgoing ? ChatSpacing.radiusXs : ChatSpacing.radiusLg),
    );

    return Align(
      key: resolvedTestId,
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: ChatSpacing.md,
          vertical: ChatSpacing.xs,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ChatSpacing.lg,
          vertical: ChatSpacing.sm + 2,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment:
              isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatText.bodyMedium(
              message.content.text,
              color: textColor,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatText.caption(
                  _formatTime(message.sentAt.toLocal()),
                  color: timeColor,
                ),
                if (isOutgoing) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(message.status),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
