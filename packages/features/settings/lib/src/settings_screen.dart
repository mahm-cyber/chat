import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/settings_controller.dart';
import 'test_ids.dart';

class SettingsScreen extends ConsumerWidget {
  final VoidCallback onBack;
  final VoidCallback onLoggedOut;

  const SettingsScreen({
    super.key,
    required this.onBack,
    required this.onLoggedOut,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsControllerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: ChatTappable(
          testId: const Key(SettingsTestIds.backButton),
          onTap: onBack,
          child: const Padding(
            padding: EdgeInsets.all(ChatSpacing.small),
            child: ChatIcon(Icons.arrow_back_rounded, size: 24),
          ),
        ),
        title: ChatText(
          context.tr('settings.title'),
          variant: ChatTextVariant.titleLarge,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(ChatSpacing.medium),
          children: [
            // Appearance section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ChatSpacing.small,
                vertical: ChatSpacing.xSmall,
              ),
              child: ChatText(
                context.tr('settings.theme_label'),
                variant: ChatTextVariant.titleMedium,
              ),
            ),
            const SizedBox(height: ChatSpacing.small),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  _ThemeOptionTile(
                    testId: SettingsTestIds.themeSystem,
                    title: context.tr('settings.theme_system'),
                    icon: Icons.brightness_auto_rounded,
                    isSelected: themeMode == ThemeMode.system,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.system);
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 56,
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                  _ThemeOptionTile(
                    testId: SettingsTestIds.themeLight,
                    title: context.tr('settings.theme_light'),
                    icon: Icons.light_mode_rounded,
                    isSelected: themeMode == ThemeMode.light,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.light);
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 56,
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                  _ThemeOptionTile(
                    testId: SettingsTestIds.themeDark,
                    title: context.tr('settings.theme_dark'),
                    icon: Icons.dark_mode_rounded,
                    isSelected: themeMode == ThemeMode.dark,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.dark);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: ChatSpacing.large),

            // Notifications section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ChatSpacing.small,
                vertical: ChatSpacing.xSmall,
              ),
              child: ChatText(
                context.tr('settings.notifications_label'),
                variant: ChatTextVariant.titleMedium,
              ),
            ),
            const SizedBox(height: ChatSpacing.small),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.5),
                ),
              ),
              child: ChatTappable(
                testId: const Key(SettingsTestIds.notificationToggle),
                onTap: () {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .toggleNotifications();
                },
                child: Padding(
                  padding: const EdgeInsets.all(ChatSpacing.medium),
                  child: Row(
                    children: [
                      const ChatIcon(
                        Icons.notifications_active_rounded,
                        size: 24,
                      ),
                      const SizedBox(width: ChatSpacing.medium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChatText(
                              context.tr('settings.notifications_label'),
                              variant: ChatTextVariant.bodyMedium,
                            ),
                            ChatText(
                              context.tr('settings.notifications_subtitle'),
                              variant: ChatTextVariant.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: state.notificationsEnabled,
                        onChanged: (_) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .toggleNotifications();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: ChatSpacing.xLarge),

            // Logout action
            ChatTappable(
              testId: const Key(SettingsTestIds.logoutButton),
              onTap: state.isLoggingOut
                  ? null
                  : () async {
                      final ok = await ref
                          .read(settingsControllerProvider.notifier)
                          .logout();
                      if (ok) {
                        onLoggedOut();
                      }
                    },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: ChatPalette.coralRose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ChatPalette.coralRose.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: state.isLoggingOut
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: ChatPalette.coralRose,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ChatIcon(
                              Icons.logout_rounded,
                              color: ChatPalette.coralRose,
                              size: 20,
                            ),
                            const SizedBox(width: ChatSpacing.small),
                            ChatText(
                              context.tr('settings.logout_button'),
                              variant: ChatTextVariant.labelLarge,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String testId;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.testId,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChatTappable(
      testId: Key(testId),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ChatSpacing.medium,
          vertical: ChatSpacing.small,
        ),
        child: Row(
          children: [
            ChatIcon(icon, size: 22),
            const SizedBox(width: ChatSpacing.medium),
            Expanded(
              child: ChatText(
                title,
                variant: ChatTextVariant.bodyMedium,
              ),
            ),
            if (isSelected)
              ChatIcon(
                Icons.check_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
