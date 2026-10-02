import 'package:flutter/material.dart';

class ChatTappable extends StatelessWidget {
  final Key testId;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final BorderRadius? borderRadius;
  final HitTestBehavior behavior;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const ChatTappable({
    required this.testId,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.behavior = HitTestBehavior.opaque,
    this.padding,
    this.backgroundColor,
  }) : super(key: testId);

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }
    if (backgroundColor != null) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: content,
      );
    }

    return Semantics(
      button: true,
      enabled: onTap != null || onLongPress != null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: borderRadius,
        child: content,
      ),
    );
  }
}
