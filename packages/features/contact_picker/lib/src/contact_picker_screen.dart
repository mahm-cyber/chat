import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/contact_picker_controller.dart';
import 'test_ids.dart';

class ContactPickerScreen extends ConsumerWidget {
  final void Function(User user) onSelectUser;
  final VoidCallback onBack;

  const ContactPickerScreen({
    super.key,
    required this.onSelectUser,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactPickerControllerProvider);
    final theme = Theme.of(context);
    final users = state.filteredUsers;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: ChatTappable(
          testId: const Key(ContactPickerTestIds.backButton),
          onTap: onBack,
          child: const Padding(
            padding: EdgeInsets.all(ChatSpacing.small),
            child: ChatIcon(Icons.arrow_back_rounded, size: 24),
          ),
        ),
        title: ChatText(
          context.tr('contacts.title'),
          variant: ChatTextVariant.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(ChatSpacing.medium),
              child: Column(
                children: [
                  TextField(
                    key: const Key(ContactPickerTestIds.searchInput),
                    onChanged: (val) {
                      ref
                          .read(contactPickerControllerProvider.notifier)
                          .setSearchQuery(val);
                    },
                    decoration: InputDecoration(
                      hintText: context.tr('contacts.search_placeholder'),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      prefixIcon: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ChatSpacing.small),
                        child: ChatIcon(Icons.search_rounded, size: 20),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: ChatSpacing.small),
                  Row(
                    children: [
                      Expanded(
                        child: ChatTappable(
                          testId: const Key(
                              ContactPickerTestIds.syncContactsButton),
                          onTap: state.isSyncing
                              ? null
                              : () {
                                  ref
                                      .read(contactPickerControllerProvider
                                          .notifier)
                                      .syncDeviceContacts([
                                    '+15551112233',
                                    '+15554445566',
                                  ]);
                                },
                          child: Container(
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: state.isSyncing
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ChatIcon(
                                        Icons.sync_rounded,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: ChatSpacing.xSmall),
                                      ChatText(
                                        context.tr('contacts.sync_button'),
                                        variant: ChatTextVariant.labelMedium,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: ChatSpacing.small),
                      Expanded(
                        child: ChatTappable(
                          testId: const Key(ContactPickerTestIds.inviteButton),
                          onTap: () {
                            // Invite friends action
                          },
                          child: Container(
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const ChatIcon(
                                  Icons.share_rounded,
                                  size: 16,
                                ),
                                const SizedBox(width: ChatSpacing.xSmall),
                                ChatText(
                                  context.tr('contacts.invite_button'),
                                  variant: ChatTextVariant.labelMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : users.isEmpty
                      ? Center(
                          key: const Key(ContactPickerTestIds.emptyView),
                          child: Padding(
                            padding: const EdgeInsets.all(ChatSpacing.large),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChatIcon(
                                  Icons.people_outline_rounded,
                                  size: 48,
                                  color: theme.disabledColor,
                                ),
                                const SizedBox(height: ChatSpacing.small),
                                ChatText(
                                  context.tr('contacts.empty'),
                                  variant: ChatTextVariant.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: users.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            indent: 68,
                            color: theme.dividerColor.withValues(alpha: 0.5),
                          ),
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return _ContactTile(
                              user: user,
                              onTap: () => onSelectUser(user),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const _ContactTile({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChatTappable(
      testId: Key(ContactPickerTestIds.contactItem(user.id.value)),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ChatSpacing.medium,
          vertical: ChatSpacing.small,
        ),
        child: Row(
          children: [
            ChatAvatar(
              displayName: user.displayName,
              avatarUrl: user.avatarUrl,
              isOnline: user.isOnline,
              size: 48,
            ),
            const SizedBox(width: ChatSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChatText(
                    user.displayName,
                    variant: ChatTextVariant.titleMedium,
                  ),
                  ChatText(
                    user.phoneNumber.value,
                    variant: ChatTextVariant.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
