class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String avatarUrl;
  final String phoneNumber;
  final String bio;
  final bool notificationsEnabled;
  final bool darkMode;

  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.avatarUrl = '',
    this.phoneNumber = '',
    this.bio = '',
    this.notificationsEnabled = true,
    this.darkMode = false,
  });

  factory UserProfile.empty(String uid) {
    return UserProfile(
      uid: uid,
      displayName: 'BookHub User',
      email: 'user@example.com',
    );
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid,
      displayName: (map['displayName'] as String?) ?? 'BookHub User',
      email: (map['email'] as String?) ?? 'user@example.com',
      avatarUrl: map['avatarUrl'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      darkMode: map['darkMode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'notificationsEnabled': notificationsEnabled,
      'darkMode': darkMode,
    };
  }
}
