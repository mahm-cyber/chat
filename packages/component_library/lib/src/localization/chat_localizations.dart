import 'package:flutter/widgets.dart';
import 'package:localization_repository/localization_repository.dart';

class ChatLocalizationsScope extends InheritedWidget {
  final LocalizationRepository repository;
  final Map<String, String> translations;

  const ChatLocalizationsScope({
    required this.repository,
    required this.translations,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(ChatLocalizationsScope oldWidget) {
    return translations != oldWidget.translations ||
        repository != oldWidget.repository;
  }

  static ChatLocalizationsScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatLocalizationsScope>();
  }

  static ChatLocalizationsScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No ChatLocalizationsScope found in context');
    return scope!;
  }
}

extension ChatLocalizationExtension on BuildContext {
  String tr(String key, {Map<String, String>? parameters}) {
    final scope = ChatLocalizationsScope.maybeOf(this);
    if (scope == null) return key;
    return scope.repository.translate(key, parameters: parameters);
  }
}
