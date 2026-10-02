import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/user_profile_controller.dart';
import 'test_ids.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final UserId? userId;
  final VoidCallback onBack;

  const UserProfileScreen({
    super.key,
    this.userId,
    required this.onBack,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _showQrCodeDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        key: const Key(UserProfileTestIds.qrDialog),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ChatSpacing.large),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatText(
                context.tr('profile.my_qr_code'),
                variant: ChatTextVariant.titleMedium,
              ),
              const SizedBox(height: ChatSpacing.large),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: ChatIcon(
                    Icons.qr_code_2_rounded,
                    size: 140,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: ChatSpacing.medium),
              ChatText(
                user?.displayName ?? '',
                variant: ChatTextVariant.bodyMedium,
              ),
              const SizedBox(height: ChatSpacing.large),
              ChatTappable(
                testId: const Key('profile.close_qr_button'),
                onTap: () => Navigator.of(dialogContext).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ChatSpacing.large,
                    vertical: ChatSpacing.small,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ChatText(
                    context.tr('common.cancel'),
                    variant: ChatTextVariant.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProfileControllerProvider(widget.userId));
    final theme = Theme.of(context);

    // Sync text controllers with loaded user if fields are empty
    if (_nameController.text.isEmpty && state.displayName.isNotEmpty) {
      _nameController.text = state.displayName;
    }
    if (_bioController.text.isEmpty && state.bio.isNotEmpty) {
      _bioController.text = state.bio;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: ChatTappable(
          testId: const Key(UserProfileTestIds.backButton),
          onTap: widget.onBack,
          child: const Padding(
            padding: EdgeInsets.all(ChatSpacing.small),
            child: ChatIcon(Icons.arrow_back_rounded, size: 24),
          ),
        ),
        title: ChatText(
          context.tr('profile.title'),
          variant: ChatTextVariant.titleLarge,
        ),
        actions: [
          ChatTappable(
            testId: const Key(UserProfileTestIds.qrCodeButton),
            onTap: () => _showQrCodeDialog(context, state.user),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: ChatSpacing.small),
              child: ChatIcon(Icons.qr_code_rounded, size: 24),
            ),
          ),
          const SizedBox(width: ChatSpacing.xSmall),
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(ChatSpacing.large),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: ChatSpacing.medium),
                        Center(
                          child: ChatTappable(
                            testId: const Key(UserProfileTestIds.avatarPicker),
                            onTap: () {
                              // Avatar selection mock or URL picker
                              ref
                                  .read(userProfileControllerProvider(widget.userId).notifier)
                                  .setAvatarUrl('https://images.unsplash.com/photo-1534528741775-53994a69daeb');
                            },
                            child: Stack(
                              children: [
                                ChatAvatar(
                                  displayName: state.displayName.isEmpty
                                      ? 'User'
                                      : state.displayName,
                                  avatarUrl: state.avatarUrl,
                                  size: 100,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const ChatIcon(
                                      Icons.camera_alt_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: ChatSpacing.xSmall),
                        ChatText(
                          context.tr('profile.change_photo'),
                          variant: ChatTextVariant.bodySmall,
                        ),
                        const SizedBox(height: ChatSpacing.xLarge),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ChatText(
                            context.tr('profile.display_name_label'),
                            variant: ChatTextVariant.labelLarge,
                          ),
                        ),
                        const SizedBox(height: ChatSpacing.xSmall),
                        TextField(
                          key: const Key(UserProfileTestIds.nameInput),
                          controller: _nameController,
                          onChanged: (val) {
                            ref
                                .read(userProfileControllerProvider(widget.userId).notifier)
                                .setDisplayName(val);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: theme.dividerColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: ChatSpacing.large),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ChatText(
                            context.tr('profile.bio_label'),
                            variant: ChatTextVariant.labelLarge,
                          ),
                        ),
                        const SizedBox(height: ChatSpacing.xSmall),
                        TextField(
                          key: const Key(UserProfileTestIds.bioInput),
                          controller: _bioController,
                          maxLines: 3,
                          onChanged: (val) {
                            ref
                                .read(userProfileControllerProvider(widget.userId).notifier)
                                .setBio(val);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: theme.dividerColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: ChatSpacing.xLarge),
                        ChatTappable(
                          testId: const Key(UserProfileTestIds.saveButton),
                          onTap: state.isSaving
                              ? null
                              : () {
                                  ref
                                      .read(userProfileControllerProvider(widget.userId).notifier)
                                      .saveChanges();
                                },
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: state.isSaving
                                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                                  : theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: state.isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : ChatText(
                                    context.tr('profile.save_button'),
                                    variant: ChatTextVariant.labelLarge,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
