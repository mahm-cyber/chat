import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

enum WebChatIconType {
  send,
  search,
  attach,
  check,
  doubleCheck,
  settings,
  profile,
  phone,
  moon,
  sun,
  bell,
  logout,
}

class ChatIcon extends StatelessComponent {
  final WebChatIconType type;
  final int size;
  final String? className;
  final String? testId;

  const ChatIcon(
    this.type, {
    this.size = 20,
    this.className,
    this.testId,
    super.key,
  });

  const ChatIcon.send({
    int size = 20,
    String? className,
    String? testId,
    Key? key,
  }) : this(
          WebChatIconType.send,
          size: size,
          className: className,
          testId: testId,
          key: key,
        );

  const ChatIcon.search({
    int size = 20,
    String? className,
    String? testId,
    Key? key,
  }) : this(
          WebChatIconType.search,
          size: size,
          className: className,
          testId: testId,
          key: key,
        );

  const ChatIcon.check({
    int size = 16,
    String? className,
    String? testId,
    Key? key,
  }) : this(
          WebChatIconType.check,
          size: size,
          className: className,
          testId: testId,
          key: key,
        );

  const ChatIcon.doubleCheck({
    int size = 16,
    String? className,
    String? testId,
    Key? key,
  }) : this(
          WebChatIconType.doubleCheck,
          size: size,
          className: className,
          testId: testId,
          key: key,
        );

  String _getSvgPath() {
    switch (type) {
      case WebChatIconType.send:
        return 'M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z';
      case WebChatIconType.search:
        return 'M21 21l-4.35-4.35M19 11a8 8 0 11-16 0 8 8 0 0116 0z';
      case WebChatIconType.attach:
        return 'M21.44 11.05l-9.19 9.19a6 6 0 01-8.49-8.49l9.19-9.19a4 4 0 015.66 5.66l-9.2 9.19a2 2 0 01-2.83-2.83l8.49-8.48';
      case WebChatIconType.check:
        return 'M20 6L9 17l-5-5';
      case WebChatIconType.doubleCheck:
        return 'M18 6L7 17l-5-5m16 0l-7 7';
      case WebChatIconType.settings:
        return 'M12 15a3 3 0 100-6 3 3 0 000 6z';
      case WebChatIconType.profile:
        return 'M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2m8-10a4 4 0 100-8 4 4 0 000 8z';
      case WebChatIconType.phone:
        return 'M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 16.92z';
      case WebChatIconType.moon:
        return 'M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z';
      case WebChatIconType.sun:
        return 'M12 1v2m0 18v2M4.22 4.22l1.42 1.42m12.72 12.72l1.42 1.42M1 12h2m18 0h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42M12 7a5 5 0 100 10 5 5 0 000-10z';
      case WebChatIconType.bell:
        return 'M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9m-4.27 13a2 2 0 01-3.46 0';
      case WebChatIconType.logout:
        return 'M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4m7 14l5-5-5-5m5 5H9';
    }
  }

  @override
  Component build(BuildContext context) {
    return svg(
      classes: className ?? 'inline-block text-current',
      attributes: {
        if (testId != null) 'data-testid': testId!,
        'width': '$size',
        'height': '$size',
        'viewBox': '0 0 24 24',
        'fill': 'none',
        'stroke': 'currentColor',
        'stroke-width': '2',
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
      },
      [
        path([], attributes: {'d': _getSvgPath()}),
      ],
    );
  }
}
