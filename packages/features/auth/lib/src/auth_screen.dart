import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/auth_controller.dart';
import 'notifiers/auth_state.dart';
import 'test_ids.dart';

class AuthScreen extends ConsumerStatefulWidget {
  final VoidCallback onAuthenticated;

  const AuthScreen({
    super.key,
    required this.onAuthenticated,
  });

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ChatSpacing.large),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: ChatIcon(
                          Icons.chat_bubble_outline_rounded,
                          size: 36,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: ChatSpacing.large),
                  Center(
                    child: ChatText(
                      context.tr(
                        state.step == AuthStep.phone
                            ? 'auth.welcome_title'
                            : 'auth.verify_title',
                      ),
                      variant: ChatTextVariant.titleLarge,
                    ),
                  ),
                  const SizedBox(height: ChatSpacing.xSmall),
                  Center(
                    child: ChatText(
                      context.tr(
                        state.step == AuthStep.phone
                            ? 'auth.phone_subtitle'
                            : 'auth.verify_subtitle',
                      ),
                      variant: ChatTextVariant.bodyMedium,
                    ),
                  ),
                  if (state.errorMessageKey != null) ...[
                    const SizedBox(height: ChatSpacing.medium),
                    _ErrorBanner(
                      message: context.tr(state.errorMessageKey!),
                    ),
                  ],
                  const SizedBox(height: ChatSpacing.xLarge),
                  if (state.step == AuthStep.phone)
                    _PhoneStepView(
                      phoneController: _phoneController,
                      isLoading: state.isLoading,
                      onPhoneChanged: (val) {
                        ref.read(authControllerProvider.notifier).setPhoneNumber(val);
                      },
                      onSendOtp: () async {
                        final success = await ref
                            .read(authControllerProvider.notifier)
                            .sendOtp();
                        if (success) {
                          _otpController.clear();
                        }
                      },
                    )
                  else
                    _OtpStepView(
                      otpController: _otpController,
                      phoneNumber: state.phoneNumber,
                      isLoading: state.isLoading,
                      onVerifyOtp: () async {
                        final user = await ref
                            .read(authControllerProvider.notifier)
                            .verifyOtp(_otpController.text);
                        if (user != null && mounted) {
                          widget.onAuthenticated();
                        }
                      },
                      onResendOtp: () {
                        ref.read(authControllerProvider.notifier).resendOtp();
                      },
                      onChangePhone: () {
                        ref.read(authControllerProvider.notifier).changePhone();
                      },
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

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ChatSpacing.small),
      decoration: BoxDecoration(
        color: ChatPalette.coralRose.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ChatPalette.coralRose.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const ChatIcon(
            Icons.error_outline_rounded,
            color: ChatPalette.coralRose,
            size: 20,
          ),
          const SizedBox(width: ChatSpacing.small),
          Expanded(
            child: ChatText(
              message,
              variant: ChatTextVariant.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneStepView extends StatelessWidget {
  final TextEditingController phoneController;
  final bool isLoading;
  final ValueChanged<String> onPhoneChanged;
  final VoidCallback onSendOtp;

  const _PhoneStepView({
    required this.phoneController,
    required this.isLoading,
    required this.onPhoneChanged,
    required this.onSendOtp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChatText(
          context.tr('auth.phone_label'),
          variant: ChatTextVariant.labelLarge,
        ),
        const SizedBox(height: ChatSpacing.xSmall),
        TextField(
          key: const Key(AuthTestIds.phoneInput),
          controller: phoneController,
          keyboardType: TextInputType.phone,
          onChanged: onPhoneChanged,
          decoration: InputDecoration(
            hintText: '+1 555 123 4567',
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.dividerColor,
              ),
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: ChatSpacing.small),
              child: ChatIcon(Icons.phone_rounded, size: 20),
            ),
          ),
        ),
        const SizedBox(height: ChatSpacing.large),
        ChatTappable(
          testId: const Key(AuthTestIds.sendOtpButton),
          onTap: isLoading ? null : onSendOtp,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isLoading
                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                  : theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : ChatText(
                    context.tr('auth.send_code_button'),
                    variant: ChatTextVariant.labelLarge,
                  ),
          ),
        ),
      ],
    );
  }
}

class _OtpStepView extends StatelessWidget {
  final TextEditingController otpController;
  final String phoneNumber;
  final bool isLoading;
  final VoidCallback onVerifyOtp;
  final VoidCallback onResendOtp;
  final VoidCallback onChangePhone;

  const _OtpStepView({
    required this.otpController,
    required this.phoneNumber,
    required this.isLoading,
    required this.onVerifyOtp,
    required this.onResendOtp,
    required this.onChangePhone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key(AuthTestIds.otpInput),
          controller: otpController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '123456',
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.dividerColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: ChatSpacing.large),
        ChatTappable(
          testId: const Key(AuthTestIds.verifyOtpButton),
          onTap: isLoading ? null : onVerifyOtp,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isLoading
                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                  : theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : ChatText(
                    context.tr('auth.verify_title'),
                    variant: ChatTextVariant.labelLarge,
                  ),
          ),
        ),
        const SizedBox(height: ChatSpacing.medium),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: ChatSpacing.xSmall,
          children: [
            ChatTappable(
              testId: const Key(AuthTestIds.changePhoneButton),
              onTap: onChangePhone,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: ChatSpacing.xSmall,
                  horizontal: ChatSpacing.small,
                ),
                child: ChatText(
                  context.tr('auth.change_phone'),
                  variant: ChatTextVariant.bodySmall,
                ),
              ),
            ),
            ChatTappable(
              testId: const Key(AuthTestIds.resendButton),
              onTap: onResendOtp,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: ChatSpacing.xSmall,
                  horizontal: ChatSpacing.small,
                ),
                child: ChatText(
                  context.tr('auth.resend_code'),
                  variant: ChatTextVariant.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
