import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class ChatAvatar extends StatelessComponent {
  final String name;
  final String? imageUrl;
  final int size;
  final bool isOnline;
  final bool showOnlineIndicator;
  final String? testId;

  const ChatAvatar({
    required this.name,
    this.imageUrl,
    this.size = 40,
    this.isOnline = false,
    this.showOnlineIndicator = false,
    this.testId,
    super.key,
  });

  String _getInitials(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.length >= 2
        ? trimmed.substring(0, 2).toUpperCase()
        : trimmed[0].toUpperCase();
  }

  @override
  Component build(BuildContext context) {
    final initials = _getInitials(name);

    return div(
      classes: 'relative inline-flex items-center justify-center shrink-0 rounded-full',
      attributes: {
        if (testId != null) 'data-testid': testId!,
        'style': 'width: ${size}px; height: ${size}px;',
      },
      [
        if (imageUrl != null && imageUrl!.isNotEmpty)
          img(
            src: imageUrl!,
            alt: name,
            classes: 'rounded-full object-cover w-full h-full',
          )
        else
          div(
            classes:
                'w-full h-full rounded-full bg-indigo-600 text-white font-semibold text-sm flex items-center justify-center uppercase select-none',
            [text(initials)],
          ),
        if (showOnlineIndicator)
          span(
            classes:
                'absolute bottom-0 right-0 block h-2.5 w-2.5 rounded-full ring-2 ring-white dark:ring-zinc-900 ${isOnline ? 'bg-emerald-500' : 'bg-slate-400'}',
            [],
          ),
      ],
    );
  }
}
