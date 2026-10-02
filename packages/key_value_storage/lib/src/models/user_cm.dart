class UserCM {
  final String id;
  final String phoneNumber;
  final String displayName;
  final String? bio;
  final String? photoUrl;
  final bool notificationsEnabled;
  final String? lastSeenAt;
  final String createdAt;

  const UserCM({
    required this.id,
    required this.phoneNumber,
    required this.displayName,
    this.bio,
    this.photoUrl,
    this.notificationsEnabled = true,
    this.lastSeenAt,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'phoneNumber': phoneNumber,
        'displayName': displayName,
        'bio': bio,
        'photoUrl': photoUrl,
        'notificationsEnabled': notificationsEnabled,
        'lastSeenAt': lastSeenAt,
        'createdAt': createdAt,
      };

  factory UserCM.fromJson(Map<String, dynamic> json) => UserCM(
        id: json['id'] as String,
        phoneNumber: json['phoneNumber'] as String,
        displayName: json['displayName'] as String,
        bio: json['bio'] as String?,
        photoUrl: json['photoUrl'] as String?,
        notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
        lastSeenAt: json['lastSeenAt'] as String?,
        createdAt: json['createdAt'] as String,
      );
}
