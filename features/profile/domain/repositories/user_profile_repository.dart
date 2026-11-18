import 'package:bookhub2/features/profile/domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getProfile(String uid);

  Future<void> updateProfile(String uid, Map<String, dynamic> updates);

  Future<void> deleteProfile(String uid);

  Future<List<Map<String, dynamic>>> getLibrary(String uid);
}
