import 'package:auth/auth.dart';
import 'package:chat_room/chat_room.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:conversation_list/conversation_list.dart';
import 'package:domain_models/domain_models.dart';
import 'package:go_router/go_router.dart';
import 'package:settings/settings.dart';
import 'package:user_profile/user_profile.dart';

GoRouter createRouter({
  required bool isAuthenticated,
  required UserId currentUserId,
}) {
  return GoRouter(
    initialLocation: isAuthenticated ? '/conversations' : '/auth',
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => AuthScreen(
          onAuthenticated: () {
            context.go('/conversations');
          },
        ),
      ),
      GoRoute(
        path: '/conversations',
        name: 'conversations',
        builder: (context, state) => ConversationListScreen(
          onSelectConversation: (conversationId) {
            context.push('/chat/${conversationId.value}');
          },
          onNewChat: () {
            context.push('/contacts');
          },
          onOpenProfile: () {
            context.push('/profile');
          },
          onOpenSettings: () {
            context.push('/settings');
          },
        ),
      ),
      GoRoute(
        path: '/chat/:id',
        name: 'chat',
        builder: (context, state) {
          final conversationId =
              ConversationId(state.pathParameters['id'] ?? 'default');
          final partner = state.extra as User? ??
              User(
                id: UserId('partner_${conversationId.value}'),
                phoneNumber: PhoneNumber.parse('+1000000000'),
                displayName: 'Chat Partner',
                createdAt: DateTime.now(),
              );

          return ChatRoomScreen(
            conversationId: conversationId,
            currentUserId: currentUserId,
            partnerId: partner.id,
            partnerName: partner.displayName,
            partnerAvatarUrl: partner.photoUrl,
            isPartnerOnline: partner.isOnline,
            onBack: () => context.pop(),
          );
        },
      ),
      GoRoute(
        path: '/contacts',
        name: 'contacts',
        builder: (context, state) => ContactPickerScreen(
          onSelectUser: (user) {
            final convId = 'conv_${user.id.value}';
            context.pushReplacement('/chat/$convId', extra: user);
          },
          onBack: () => context.pop(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) {
          final user = state.extra as User?;
          return UserProfileScreen(
            userId: user?.id,
            onBack: () => context.pop(),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => SettingsScreen(
          onBack: () => context.pop(),
          onLoggedOut: () {
            context.go('/auth');
          },
        ),
      ),
    ],
  );
}
