import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class ChatRoomState extends Equatable {
  final List<Message> messages;
  final bool isPartnerTyping;
  final bool isSending;
  final String? errorMessageKey;

  const ChatRoomState({
    this.messages = const [],
    this.isPartnerTyping = false,
    this.isSending = false,
    this.errorMessageKey,
  });

  ChatRoomState copyWith({
    List<Message>? messages,
    bool? isPartnerTyping,
    bool? isSending,
    String? errorMessageKey,
    bool clearError = false,
  }) {
    return ChatRoomState(
      messages: messages ?? this.messages,
      isPartnerTyping: isPartnerTyping ?? this.isPartnerTyping,
      isSending: isSending ?? this.isSending,
      errorMessageKey: clearError ? null : (errorMessageKey ?? this.errorMessageKey),
    );
  }

  @override
  List<Object?> get props => [
        messages,
        isPartnerTyping,
        isSending,
        errorMessageKey,
      ];
}
