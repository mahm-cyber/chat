import 'package:equatable/equatable.dart';
import '../exceptions/domain_exception.dart';

class MessageContent extends Equatable {
  final String text;
  final List<String> attachments;

  const MessageContent._({
    required this.text,
    required this.attachments,
  });

  factory MessageContent({
    required String text,
    List<String> attachments,
  }) = MessageContent.create;

  factory MessageContent.create({
    required String text,
    List<String> attachments = const [],
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty && attachments.isEmpty) {
      throw const InvalidMessageContentException('Message content cannot be empty.');
    }
    if (trimmed.length > 5000) {
      throw const InvalidMessageContentException(
        'Message text exceeds maximum allowed length of 5000 characters.',
      );
    }

    return MessageContent._(
      text: trimmed,
      attachments: List.unmodifiable(attachments),
    );
  }

  @override
  List<Object?> get props => [text, attachments];
}
