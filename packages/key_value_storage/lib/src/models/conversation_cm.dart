import 'message_cm.dart';

class ConversationCM {
  final String id;
  final String user1Id;
  final String user2Id;
  final MessageCM? lastMessage;
  final int unreadCount;
  final String createdAt;
  final String updatedAt;

  const ConversationCM({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user1Id': user1Id,
        'user2Id': user2Id,
        'lastMessage': lastMessage?.toJson(),
        'unreadCount': unreadCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory ConversationCM.fromJson(Map<String, dynamic> json) => ConversationCM(
        id: json['id'] as String,
        user1Id: json['user1Id'] as String,
        user2Id: json['user2Id'] as String,
        lastMessage: json['lastMessage'] != null
            ? MessageCM.fromJson(json['lastMessage'] as Map<String, dynamic>)
            : null,
        unreadCount: json['unreadCount'] as int? ?? 0,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
      );
}
