import 'package:flutter/material.dart';

class ChatIcons {
  const ChatIcons._();

  static const IconData send = Icons.send_rounded;
  static const IconData attach = Icons.attach_file_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData doubleCheck = Icons.done_all_rounded;
  static const IconData phone = Icons.phone_rounded;
  static const IconData camera = Icons.camera_alt_rounded;
  static const IconData logout = Icons.logout_rounded;
  static const IconData moon = Icons.dark_mode_rounded;
  static const IconData sun = Icons.light_mode_rounded;
  static const IconData bell = Icons.notifications_rounded;
  static const IconData bellOff = Icons.notifications_off_rounded;
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData add = Icons.add_rounded;
  static const IconData more = Icons.more_vert_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData close = Icons.close_rounded;
}

class ChatIcon extends StatelessWidget {
  final IconData icon;
  final Key? testId;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  const ChatIcon(
    this.icon, {
    this.testId,
    this.size = 24.0,
    this.color,
    this.semanticLabel,
    super.key,
  });

  const ChatIcon.send({
    Key? testId,
    double? size = 20.0,
    Color? color,
    String? semanticLabel,
    Key? key,
  }) : this(
          ChatIcons.send,
          testId: testId,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          key: key,
        );

  const ChatIcon.search({
    Key? testId,
    double? size = 20.0,
    Color? color,
    String? semanticLabel,
    Key? key,
  }) : this(
          ChatIcons.search,
          testId: testId,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          key: key,
        );

  const ChatIcon.check({
    Key? testId,
    double? size = 16.0,
    Color? color,
    String? semanticLabel,
    Key? key,
  }) : this(
          ChatIcons.check,
          testId: testId,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          key: key,
        );

  const ChatIcon.doubleCheck({
    Key? testId,
    double? size = 16.0,
    Color? color,
    String? semanticLabel,
    Key? key,
  }) : this(
          ChatIcons.doubleCheck,
          testId: testId,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      key: testId ?? key,
      size: size,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      semanticLabel: semanticLabel,
    );
  }
}
