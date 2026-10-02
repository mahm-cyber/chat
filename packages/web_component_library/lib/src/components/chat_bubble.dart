import 'package:domain_models/domain_models.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'chat_icon.dart';
import 'chat_text.dart';

class ChatBubble extends StatelessComponent {
  final Message message;
  final bool isOutgoing;
  final String? testId;

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

  Component _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return span(
          classes: 'inline-block w-3 h-3 border-2 border-white/70 border-t-transparent rounded-full animate-spin',
          [],
        );
      case MessageStatus.sent:
        return const ChatIcon.check(size: 14, className: 'text-white/70');
      case MessageStatus.delivered:
        return const ChatIcon.doubleCheck(size: 14, className: 'text-white/70');
      case MessageStatus.read:
        return const ChatIcon.doubleCheck(size: 14, className: 'text-emerald-400');
      case MessageStatus.failed:
        return span(classes: 'text-rose-400 text-xs', [text('!')]);
    }
  }

  @override
  Component build(BuildContext context) {
    final resolvedTestId = testId ?? 'bubble_${message.id.value}';
    final bubbleClasses = isOutgoing
        ? 'bg-indigo-600 text-white rounded-2xl rounded-tr-sm ml-auto shadow-sm'
        : 'bg-slate-200 dark:bg-zinc-800 text-slate-900 dark:text-slate-100 rounded-2xl rounded-tl-sm mr-auto shadow-sm';

    final timeClasses = isOutgoing
        ? 'text-[11px] text-white/70'
        : 'text-[11px] text-slate-500 dark:text-slate-400';

    return div(
      classes: 'flex w-full my-1.5 px-3',
      attributes: {'data-testid': resolvedTestId},
      [
        div(
          classes: 'max-w-[75%] px-4 py-2.5 flex flex-col $bubbleClasses',
          [
            ChatText.bodyMedium(
              message.content.text,
              className: isOutgoing ? 'text-white' : 'text-slate-900 dark:text-slate-100',
            ),
            div(
              classes: 'flex items-center gap-1 mt-1 justify-end',
              [
                span(classes: timeClasses, [text(_formatTime(message.sentAt.toLocal()))]),
                if (isOutgoing) _buildStatusIcon(message.status),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
