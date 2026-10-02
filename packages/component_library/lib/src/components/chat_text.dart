import 'package:flutter/material.dart';

enum ChatTextVariant {
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
}

class ChatText extends StatelessWidget {
  final String text;
  final Key? testId;
  final ChatTextVariant variant;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  const ChatText(
    this.text, {
    this.testId,
    this.variant = ChatTextVariant.bodyMedium,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    super.key,
  });

  const ChatText.headlineSmall(
    this.text, {
    this.testId,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    super.key,
  }) : variant = ChatTextVariant.headlineSmall;

  const ChatText.titleLarge(
    this.text, {
    this.testId,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    super.key,
  }) : variant = ChatTextVariant.titleLarge;

  const ChatText.titleMedium(
    this.text, {
    this.testId,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    super.key,
  }) : variant = ChatTextVariant.titleMedium;

  const ChatText.titleSmall(
    this.text, {
    this.testId,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    super.key,
  }) : variant = ChatTextVariant.titleSmall;

  const ChatText.bodyLarge(
    this.text, {
    this.testId,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    super.key,
  }) : variant = ChatTextVariant.bodyLarge;

  const ChatText.bodyMedium(
    this.text, {
    this.testId,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    super.key,
  }) : variant = ChatTextVariant.bodyMedium;

  const ChatText.bodySmall(
    this.text, {
    this.testId,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    super.key,
  }) : variant = ChatTextVariant.bodySmall;

  const ChatText.caption(
    this.text, {
    this.testId,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    super.key,
  }) : variant = ChatTextVariant.caption;

  TextStyle _resolveStyle(ThemeData theme) {
    TextStyle base;
    switch (variant) {
      case ChatTextVariant.headlineSmall:
        base = theme.textTheme.headlineSmall ??
            const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
        break;
      case ChatTextVariant.titleLarge:
        base = theme.textTheme.titleLarge ??
            const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
        break;
      case ChatTextVariant.titleMedium:
        base = theme.textTheme.titleMedium ??
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
        break;
      case ChatTextVariant.titleSmall:
        base = theme.textTheme.titleSmall ??
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
        break;
      case ChatTextVariant.bodyLarge:
        base = theme.textTheme.bodyLarge ??
            const TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
        break;
      case ChatTextVariant.bodyMedium:
        base = theme.textTheme.bodyMedium ??
            const TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
        break;
      case ChatTextVariant.bodySmall:
        base = theme.textTheme.bodySmall ??
            const TextStyle(fontSize: 12, fontWeight: FontWeight.normal);
        break;
      case ChatTextVariant.caption:
        base = (theme.textTheme.bodySmall ??
                const TextStyle(fontSize: 11, fontWeight: FontWeight.normal))
            .copyWith(fontSize: 11);
        break;
    }

    if (color != null) base = base.copyWith(color: color);
    if (fontWeight != null) base = base.copyWith(fontWeight: fontWeight);
    if (style != null) base = base.merge(style);

    return base;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedStyle = _resolveStyle(theme);

    return Text(
      text,
      key: testId ?? key,
      style: resolvedStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
