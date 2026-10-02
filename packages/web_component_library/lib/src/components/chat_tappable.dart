import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class ChatTappable extends StatelessComponent {
  final String testId;
  final VoidCallback? onClick;
  final Component child;
  final String? className;
  final bool disabled;

  const ChatTappable({
    required this.testId,
    required this.child,
    this.onClick,
    this.className,
    this.disabled = false,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return button(
      classes: className ??
          'cursor-pointer transition duration-150 ease-in-out focus:outline-none',
      disabled: disabled,
      events: onClick != null ? {'click': (_) => onClick!()} : null,
      attributes: {
        'data-testid': testId,
        'type': 'button',
      },
      [child],
    );
  }
}
