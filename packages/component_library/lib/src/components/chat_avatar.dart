import 'package:flutter/material.dart';
import '../theme/chat_palette.dart';
import 'chat_text.dart';

class ChatAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final bool isOnline;
  final bool showOnlineIndicator;
  final Key? testId;

  const ChatAvatar({
    required this.name,
    this.imageUrl,
    this.size = 44.0,
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

  Color _getBackgroundColor(String input) {
    const colors = [
      ChatPalette.indigo500,
      ChatPalette.indigo600,
      ChatPalette.indigo700,
      ChatPalette.slate600,
      ChatPalette.slate700,
    ];
    final hash = input.codeUnits.fold(0, (prev, elem) => prev + elem);
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final resolvedTestId = testId ?? key ?? Key('avatar_$name');
    final initials = _getInitials(name);
    final bgColor = _getBackgroundColor(name);

    Widget avatarContent;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarContent = ClipOval(
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(initials, bgColor),
        ),
      );
    } else {
      avatarContent = _buildFallback(initials, bgColor);
    }

    if (!showOnlineIndicator) {
      return SizedBox(
        key: resolvedTestId,
        width: size,
        height: size,
        child: avatarContent,
      );
    }

    final indicatorSize = (size * 0.28).clamp(8.0, 14.0);

    return SizedBox(
      key: resolvedTestId,
      width: size,
      height: size,
      child: Stack(
        children: [
          avatarContent,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: isOnline ? ChatPalette.emerald500 : ChatPalette.slate400,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallback(String initials, Color bgColor) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: ChatText.titleSmall(
        initials,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
