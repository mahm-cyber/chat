import 'package:equatable/equatable.dart';
import '../exceptions/domain_exception.dart';

class UserId extends Equatable {
  final String value;

  const UserId._(this.value);

  factory UserId(String value) {
    if (value.trim().isEmpty) {
      throw const DomainInvariantViolationException('UserId cannot be empty.');
    }
    return UserId._(value);
  }

  @override
  String toString() => value;

  @override
  List<Object?> get props => [value];
}

class ConversationId extends Equatable {
  final String value;

  const ConversationId._(this.value);

  factory ConversationId(String value) {
    if (value.trim().isEmpty) {
      throw const DomainInvariantViolationException('ConversationId cannot be empty.');
    }
    return ConversationId._(value);
  }

  @override
  String toString() => value;

  @override
  List<Object?> get props => [value];
}

class MessageId extends Equatable {
  final String value;

  const MessageId._(this.value);

  factory MessageId(String value) {
    if (value.trim().isEmpty) {
      throw const DomainInvariantViolationException('MessageId cannot be empty.');
    }
    return MessageId._(value);
  }

  @override
  String toString() => value;

  @override
  List<Object?> get props => [value];
}
