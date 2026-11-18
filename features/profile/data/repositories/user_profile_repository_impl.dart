import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bookhub2/features/profile/domain/entities/user_profile.dart';
import 'package:bookhub2/features/profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<UserProfile> getProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      return UserProfile.empty(uid);
    }

    return UserProfile.fromMap(doc.data() ?? {}, uid);
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> updates) async {
    await _firestore.collection('users').doc(uid).set(
      updates,
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteProfile(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  @override
  Future<List<Map<String, dynamic>>> getLibrary(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('library')
        .orderBy('purchasedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }
}
