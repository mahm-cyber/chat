/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:chat_client/src/protocol/chat/chat_event.dart' as _irlig1jj;
import 'package:chat_client/src/protocol/chat/conversation.dart' as _ibx6f4yw;
import 'package:chat_client/src/protocol/chat/message.dart' as _i0cjlmz7;
import 'package:chat_client/src/protocol/localization/translation_bundle.dart'
    as _iprbig6p;
import 'package:chat_client/src/protocol/users/app_user.dart' as _izmwkj1b;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// {@category Endpoint}
class EndpointAuth extends _isc.EndpointRef {
  EndpointAuth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Authenticates or registers a user via verified Firebase phone credentials
  _ida.Future<_izmwkj1b.AppUser> authenticateWithFirebasePhone({
    required String firebaseUid,
    required String phoneNumber,
    String? displayName,
  }) => caller.callServerEndpoint<_izmwkj1b.AppUser>(
    'auth',
    'authenticateWithFirebasePhone',
    {
      'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
    },
  );

  _ida.Future<bool> signOut() => caller.callServerEndpoint<bool>(
    'auth',
    'signOut',
    {},
  );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointChat extends _isc.EndpointRef {
  EndpointChat(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'chat';

  /// Fetches an existing 1-on-1 conversation or creates a new one
  _ida.Future<_ibx6f4yw.ConversationModel> getOrCreateConversation({
    required int currentUserId,
    required int recipientId,
  }) => caller.callServerEndpoint<_ibx6f4yw.ConversationModel>(
    'chat',
    'getOrCreateConversation',
    {
      'currentUserId': currentUserId,
      'recipientId': recipientId,
    },
  );

  /// Lists all conversations where the user is a participant
  _ida.Future<List<_ibx6f4yw.ConversationModel>> getConversations(int userId) =>
      caller.callServerEndpoint<List<_ibx6f4yw.ConversationModel>>(
        'chat',
        'getConversations',
        {'userId': userId},
      );

  /// Fetches historical messages for a given conversation
  _ida.Future<List<_i0cjlmz7.MessageModel>> getMessages({
    required int conversationId,
    int? limit,
  }) => caller.callServerEndpoint<List<_i0cjlmz7.MessageModel>>(
    'chat',
    'getMessages',
    {
      'conversationId': conversationId,
      'limit': limit,
    },
  );

  /// Sends a message and broadcasts it in real-time over the conversation channel
  _ida.Future<_i0cjlmz7.MessageModel> sendMessage({
    required int conversationId,
    required int senderId,
    required int recipientId,
    required String content,
    List<String>? attachmentUrls,
  }) => caller.callServerEndpoint<_i0cjlmz7.MessageModel>(
    'chat',
    'sendMessage',
    {
      'conversationId': conversationId,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'attachmentUrls': attachmentUrls,
    },
  );

  /// Marks a message as delivered
  _ida.Future<void> markMessageDelivered({
    required int messageId,
    required int conversationId,
    required int senderId,
  }) => caller.callServerEndpoint<void>(
    'chat',
    'markMessageDelivered',
    {
      'messageId': messageId,
      'conversationId': conversationId,
      'senderId': senderId,
    },
  );

  /// Marks a message as read
  _ida.Future<void> markMessageRead({
    required int messageId,
    required int conversationId,
    required int senderId,
  }) => caller.callServerEndpoint<void>(
    'chat',
    'markMessageRead',
    {
      'messageId': messageId,
      'conversationId': conversationId,
      'senderId': senderId,
    },
  );

  /// Broadcasts typing indicator event
  _ida.Future<void> sendTypingEvent({
    required int conversationId,
    required int senderId,
    required bool isTyping,
  }) => caller.callServerEndpoint<void>(
    'chat',
    'sendTypingEvent',
    {
      'conversationId': conversationId,
      'senderId': senderId,
      'isTyping': isTyping,
    },
  );

  /// Real-time stream of incoming messages, delivery updates, and typing events
  _ida.Stream<_irlig1jj.ChatEvent> watchConversation(int conversationId) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_irlig1jj.ChatEvent>,
        _irlig1jj.ChatEvent
      >(
        'chat',
        'watchConversation',
        {'conversationId': conversationId},
        {},
      );
}

/// {@category Endpoint}
class EndpointLocalization extends _isc.EndpointRef {
  EndpointLocalization(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'localization';

  /// Returns localized translation dictionary for given [locale]
  _ida.Future<_iprbig6p.TranslationBundle> getTranslations({
    required String locale,
    int? clientVersion,
  }) => caller.callServerEndpoint<_iprbig6p.TranslationBundle>(
    'localization',
    'getTranslations',
    {
      'locale': locale,
      'clientVersion': clientVersion,
    },
  );
}

/// {@category Endpoint}
class EndpointUser extends _isc.EndpointRef {
  EndpointUser(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  /// Fetches a user profile by ID
  _ida.Future<_izmwkj1b.AppUser?> getProfile(int userId) =>
      caller.callServerEndpoint<_izmwkj1b.AppUser?>(
        'user',
        'getProfile',
        {'userId': userId},
      );

  /// Updates profile details (display name, bio, photo URL)
  _ida.Future<_izmwkj1b.AppUser?> updateProfile({
    required int userId,
    String? displayName,
    String? bio,
    String? photoUrl,
  }) => caller.callServerEndpoint<_izmwkj1b.AppUser?>(
    'user',
    'updateProfile',
    {
      'userId': userId,
      'displayName': displayName,
      'bio': bio,
      'photoUrl': photoUrl,
    },
  );

  /// Toggles push notifications setting
  _ida.Future<_izmwkj1b.AppUser?> toggleNotifications({
    required int userId,
    required bool enabled,
  }) => caller.callServerEndpoint<_izmwkj1b.AppUser?>(
    'user',
    'toggleNotifications',
    {
      'userId': userId,
      'enabled': enabled,
    },
  );

  /// Searches for registered users by phone number or display name
  _ida.Future<List<_izmwkj1b.AppUser>> searchUsers(String query) =>
      caller.callServerEndpoint<List<_izmwkj1b.AppUser>>(
        'user',
        'searchUsers',
        {'query': query},
      );

  /// Matches device contacts (phone numbers) against registered users
  _ida.Future<List<_izmwkj1b.AppUser>> syncContacts(
    List<String> phoneNumbers,
  ) => caller.callServerEndpoint<List<_izmwkj1b.AppUser>>(
    'user',
    'syncContacts',
    {'phoneNumbers': phoneNumbers},
  );

  /// Returns a secure upload description path for uploading an avatar photo
  _ida.Future<String?> getAvatarUploadDescription(String fileName) =>
      caller.callServerEndpoint<String?>(
        'user',
        'getAvatarUploadDescription',
        {'fileName': fileName},
      );

  /// Resolves the public URL for a given storage path
  _ida.Future<String> getPublicAvatarUrl(String path) =>
      caller.callServerEndpoint<String>(
        'user',
        'getPublicAvatarUrl',
        {'path': path},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    auth = EndpointAuth(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    chat = EndpointChat(this);
    localization = EndpointLocalization(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointAuth auth;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointChat chat;

  late final EndpointLocalization localization;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'auth': auth,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'chat': chat,
    'localization': localization,
    'user': user,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
