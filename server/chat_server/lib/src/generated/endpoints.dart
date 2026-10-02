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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/auth_endpoint.dart' as _iiznyhpe;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../chat/chat_endpoint.dart' as _i3w57des;
import '../localization/localization_endpoint.dart' as _i9ubmq0q;
import '../users/user_endpoint.dart' as _ibe74724;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'auth': _iiznyhpe.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'chat': _i3w57des.ChatEndpoint()
        ..initialize(
          server,
          'chat',
          null,
        ),
      'localization': _i9ubmq0q.LocalizationEndpoint()
        ..initialize(
          server,
          'localization',
          null,
        ),
      'user': _ibe74724.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['auth'] = _is.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'authenticateWithFirebasePhone': _is.MethodConnector(
          name: 'authenticateWithFirebasePhone',
          params: {
            'firebaseUid': _is.ParameterDescription(
              name: 'firebaseUid',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'phoneNumber': _is.ParameterDescription(
              name: 'phoneNumber',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _iiznyhpe.AuthEndpoint)
                  .authenticateWithFirebasePhone(
                    session,
                    firebaseUid: params['firebaseUid'],
                    phoneNumber: params['phoneNumber'],
                    displayName: params['displayName'],
                  ),
        ),
        'signOut': _is.MethodConnector(
          name: 'signOut',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _iiznyhpe.AuthEndpoint).signOut(
                session,
              ),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['chat'] = _is.EndpointConnector(
      name: 'chat',
      endpoint: endpoints['chat']!,
      methodConnectors: {
        'getOrCreateConversation': _is.MethodConnector(
          name: 'getOrCreateConversation',
          params: {
            'currentUserId': _is.ParameterDescription(
              name: 'currentUserId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'recipientId': _is.ParameterDescription(
              name: 'recipientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['chat'] as _i3w57des.ChatEndpoint)
                  .getOrCreateConversation(
                    session,
                    currentUserId: params['currentUserId'],
                    recipientId: params['recipientId'],
                  ),
        ),
        'getConversations': _is.MethodConnector(
          name: 'getConversations',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['chat'] as _i3w57des.ChatEndpoint)
                  .getConversations(
                    session,
                    params['userId'],
                  ),
        ),
        'getMessages': _is.MethodConnector(
          name: 'getMessages',
          params: {
            'conversationId': _is.ParameterDescription(
              name: 'conversationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['chat'] as _i3w57des.ChatEndpoint).getMessages(
                    session,
                    conversationId: params['conversationId'],
                    limit: params['limit'],
                  ),
        ),
        'sendMessage': _is.MethodConnector(
          name: 'sendMessage',
          params: {
            'conversationId': _is.ParameterDescription(
              name: 'conversationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'senderId': _is.ParameterDescription(
              name: 'senderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'recipientId': _is.ParameterDescription(
              name: 'recipientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'attachmentUrls': _is.ParameterDescription(
              name: 'attachmentUrls',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['chat'] as _i3w57des.ChatEndpoint).sendMessage(
                    session,
                    conversationId: params['conversationId'],
                    senderId: params['senderId'],
                    recipientId: params['recipientId'],
                    content: params['content'],
                    attachmentUrls: params['attachmentUrls'],
                  ),
        ),
        'markMessageDelivered': _is.MethodConnector(
          name: 'markMessageDelivered',
          params: {
            'messageId': _is.ParameterDescription(
              name: 'messageId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'conversationId': _is.ParameterDescription(
              name: 'conversationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'senderId': _is.ParameterDescription(
              name: 'senderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['chat'] as _i3w57des.ChatEndpoint)
                  .markMessageDelivered(
                    session,
                    messageId: params['messageId'],
                    conversationId: params['conversationId'],
                    senderId: params['senderId'],
                  ),
        ),
        'markMessageRead': _is.MethodConnector(
          name: 'markMessageRead',
          params: {
            'messageId': _is.ParameterDescription(
              name: 'messageId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'conversationId': _is.ParameterDescription(
              name: 'conversationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'senderId': _is.ParameterDescription(
              name: 'senderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['chat'] as _i3w57des.ChatEndpoint).markMessageRead(
                    session,
                    messageId: params['messageId'],
                    conversationId: params['conversationId'],
                    senderId: params['senderId'],
                  ),
        ),
        'sendTypingEvent': _is.MethodConnector(
          name: 'sendTypingEvent',
          params: {
            'conversationId': _is.ParameterDescription(
              name: 'conversationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'senderId': _is.ParameterDescription(
              name: 'senderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'isTyping': _is.ParameterDescription(
              name: 'isTyping',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['chat'] as _i3w57des.ChatEndpoint).sendTypingEvent(
                    session,
                    conversationId: params['conversationId'],
                    senderId: params['senderId'],
                    isTyping: params['isTyping'],
                  ),
        ),
        'watchConversation': _is.MethodStreamConnector(
          name: 'watchConversation',
          params: {
            'conversationId': _is.ParameterDescription(
              name: 'conversationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['chat'] as _i3w57des.ChatEndpoint)
                  .watchConversation(
                    session,
                    params['conversationId'],
                  ),
        ),
      },
    );
    connectors['localization'] = _is.EndpointConnector(
      name: 'localization',
      endpoint: endpoints['localization']!,
      methodConnectors: {
        'getTranslations': _is.MethodConnector(
          name: 'getTranslations',
          params: {
            'locale': _is.ParameterDescription(
              name: 'locale',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'clientVersion': _is.ParameterDescription(
              name: 'clientVersion',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['localization'] as _i9ubmq0q.LocalizationEndpoint)
                      .getTranslations(
                        session,
                        locale: params['locale'],
                        clientVersion: params['clientVersion'],
                      ),
        ),
      },
    );
    connectors['user'] = _is.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getProfile': _is.MethodConnector(
          name: 'getProfile',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _ibe74724.UserEndpoint).getProfile(
                    session,
                    params['userId'],
                  ),
        ),
        'updateProfile': _is.MethodConnector(
          name: 'updateProfile',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'bio': _is.ParameterDescription(
              name: 'bio',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'photoUrl': _is.ParameterDescription(
              name: 'photoUrl',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _ibe74724.UserEndpoint).updateProfile(
                    session,
                    userId: params['userId'],
                    displayName: params['displayName'],
                    bio: params['bio'],
                    photoUrl: params['photoUrl'],
                  ),
        ),
        'toggleNotifications': _is.MethodConnector(
          name: 'toggleNotifications',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'enabled': _is.ParameterDescription(
              name: 'enabled',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _ibe74724.UserEndpoint)
                  .toggleNotifications(
                    session,
                    userId: params['userId'],
                    enabled: params['enabled'],
                  ),
        ),
        'searchUsers': _is.MethodConnector(
          name: 'searchUsers',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _ibe74724.UserEndpoint).searchUsers(
                    session,
                    params['query'],
                  ),
        ),
        'syncContacts': _is.MethodConnector(
          name: 'syncContacts',
          params: {
            'phoneNumbers': _is.ParameterDescription(
              name: 'phoneNumbers',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _ibe74724.UserEndpoint).syncContacts(
                    session,
                    params['phoneNumbers'],
                  ),
        ),
        'getAvatarUploadDescription': _is.MethodConnector(
          name: 'getAvatarUploadDescription',
          params: {
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _ibe74724.UserEndpoint)
                  .getAvatarUploadDescription(
                    session,
                    params['fileName'],
                  ),
        ),
        'getPublicAvatarUrl': _is.MethodConnector(
          name: 'getPublicAvatarUrl',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _ibe74724.UserEndpoint)
                  .getPublicAvatarUrl(
                    session,
                    params['path'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
