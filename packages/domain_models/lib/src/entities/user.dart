import 'package:equatable/equatable.dart';
import '../value_objects/identifiers.dart';
import '../value_objects/phone_number.dart';

class User extends Equatable {
  final UserId id;
  final PhoneNumber phoneNumber;
  final String displayName;
  final String? bio;
  final String? photoUrl;
  final bool notificationsEnabled;
  final DateTime? lastSeenAt;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.displayName,
    this.bio,
    this.photoUrl,
    this.notificationsEnabled = true,
    this.lastSeenAt,
    required this.createdAt,
  });

  User copyWith({
    String? displayName,
    String? bio,
    String? photoUrl,
    bool? notificationsEnabled,
    DateTime? lastSeenAt,
  }) {
    return User(
      id: id,
      phoneNumber: phoneNumber,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        displayName,
        bio,
        photoUrl,
        notificationsEnabled,
        lastSeenAt,
        createdAt,
      ];
}
