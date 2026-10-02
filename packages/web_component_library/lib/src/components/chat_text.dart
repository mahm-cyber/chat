import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

enum WebChatTextVariant {
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
}

class ChatText extends StatelessComponent {
  final String content;
  final WebChatTextVariant variant;
  final String? testId;
  final String? className;

  const ChatText(
    this.content, {
    this.variant = WebChatTextVariant.bodyMedium,
    this.testId,
    this.className,
    super.key,
  });

  const ChatText.headlineSmall(
    this.content, {
    this.testId,
    this.className,
    Key? key,
  })  : variant = WebChatTextVariant.headlineSmall,
        super(key: key);

  const ChatText.titleLarge(
    this.content, {
    this.testId,
    this.className,
    Key? key,
  })  : variant = WebChatTextVariant.titleLarge,
        super(key: key);

  const ChatText.titleMedium(
    this.content, {
    this.testId,
    this.className,
    Key? key,
  })  : variant = WebChatTextVariant.titleMedium,
        super(key: key);

  const ChatText.titleSmall(
    this.content, {
    this.testId,
    this.className,
    Key? key,
  })  : variant = WebChatTextVariant.titleSmall,
        super(key: key);

  const ChatText.bodyLarge(
    this.content, {
    this.testId,
    this.className,
    Key? key,
  })  : variant = WebChatTextVariant.bodyLarge,
        super(key: key);

  const ChatText.bodyMedium(
    this.content, {
    this.testId,
    this.className,
    Key? key,
  })  : variant = WebChatTextVariant.bodyMedium,
        super(key: key);

  const ChatText.bodySmall(
    this.content, {
    this.testId,
    this.className,
    Key? key,
  })  : variant = WebChatTextVariant.bodySmall,
        super(key: key);

  const ChatText.caption(
    this.content, {
    this.testId,
    this.className,
    Key? key,
  })  : variant = WebChatTextVariant.caption,
        super(key: key);

  String _getClasses() {
    String base;
    switch (variant) {
      case WebChatTextVariant.headlineSmall:
        base = 'text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-50';
        break;
      case WebChatTextVariant.titleLarge:
        base = 'text-xl font-semibold text-slate-900 dark:text-slate-50';
        break;
      case WebChatTextVariant.titleMedium:
        base = 'text-base font-semibold text-slate-900 dark:text-slate-100';
        break;
      case WebChatTextVariant.titleSmall:
        base = 'text-sm font-semibold text-slate-800 dark:text-slate-200';
        break;
      case WebChatTextVariant.bodyLarge:
        base = 'text-base font-normal text-slate-700 dark:text-slate-300';
        break;
      case WebChatTextVariant.bodyMedium:
        base = 'text-sm font-normal text-slate-700 dark:text-slate-300';
        break;
      case WebChatTextVariant.bodySmall:
        base = 'text-xs font-normal text-slate-500 dark:text-slate-400';
        break;
      case WebChatTextVariant.caption:
        base = 'text-[11px] font-normal text-slate-400 dark:text-slate-500';
        break;
    }
    return className != null ? '$base $className' : base;
  }

  @override
  Component build(BuildContext context) {
    final classes = _getClasses();
    final attributes = testId != null ? {'data-testid': testId!} : null;

    return span(
      classes: classes,
      attributes: attributes,
      [text(content)],
    );
  }
}
