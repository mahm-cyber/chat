class MessageCM {
  final String id;
  final String conversationId;
  final String senderId;
  final String recipientId;
  final String text;
  final List<String> attachments;
  final String status;
  final String sentAt;
  final String? deliveredAt;
  final String? readAt;

  const MessageCM({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.recipientId,
    required this.text,
    this.attachments = const [],
    required this.status,
    required this.sentAt,
    this.deliveredAt,
    this.readAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'recipientId': recipientId,
        'text': text,
        'attachments': attachments,
        'status': status,
        'sentAt': sentAt,
        'deliveredAt': deliveredAt,
        'readAt': readAt,
      };

  factory MessageCM.fromJson(Map<String, dynamic> json) => MessageCM(
        id: json['id'] as String,
        conversationId: json['conversationId'] as String,
        senderId: json['senderId'] as String,
        recipientId: json['recipientId'] as String,
        text: json['text'] as String,
        attachments: (json['attachments'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        status: json['status'] as String,
        sentAt: json['sentAt'] as String,
        deliveredAt: json['deliveredAt'] as String?,
        readAt: json['readAt'] as String?,
      );
}
