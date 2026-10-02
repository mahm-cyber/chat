
// Exceptions
export 'src/exceptions/domain_exception.dart';

// Value Objects
export 'src/value_objects/identifiers.dart';
export 'src/value_objects/message_content.dart';
export 'src/value_objects/phone_number.dart';

// Entities & Aggregates
export 'src/entities/conversation.dart';
export 'src/entities/message.dart';
export 'src/entities/user.dart';

// Repository Interfaces
export 'src/repositories/i_auth_repository.dart';
export 'src/repositories/i_chat_repository.dart';
export 'src/repositories/i_localization_repository.dart';
export 'src/repositories/i_user_repository.dart';

// Use Cases
export 'src/use_cases/get_conversations_stream_use_case.dart';
export 'src/use_cases/mark_message_read_use_case.dart';
export 'src/use_cases/send_message_use_case.dart';
export 'src/use_cases/toggle_notifications_use_case.dart';
export 'src/use_cases/update_profile_use_case.dart';
export 'src/use_cases/watch_messages_use_case.dart';
