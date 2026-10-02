import 'package:domain_models/domain_models.dart';
import 'package:flutter/widgets.dart';

class ChatLocalizationsScope extends InheritedWidget {
  final ILocalizationRepository? repository;
  final Map<String, String> translations;

  const ChatLocalizationsScope({
    this.repository,
    this.translations = const {},
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
    if (scope.repository != null) {
      return scope.repository!.translate(key, parameters: parameters);
    }
    String text = scope.translations[key] ?? key;
    if (parameters != null) {
      parameters.forEach((paramKey, value) {
        text = text.replaceAll('{$paramKey}', value);
      });
    }
    return text;
  }
}
