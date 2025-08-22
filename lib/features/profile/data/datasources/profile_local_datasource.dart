import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);
  Future<void> deleteUserProfile(String userId);
  Future<UserProfileModel> createUserProfile(firebase_auth.User user);
}

abstract class ProfileFirestoreDataSource {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);
  Future<void> deleteUserProfile(String userId);
  Future<UserProfileModel> createUserProfile(firebase_auth.User user);
}

@Injectable(as: ProfileFirestoreDataSource)
class ProfileFirestoreDataSourceImpl implements ProfileFirestoreDataSource {
  final FirebaseFirestore _firestore;

  ProfileFirestoreDataSourceImpl(this._firestore);

  @override
  Future<UserProfileModel> createUserProfile(firebase_auth.User user) async {
    final profile = UserProfileModel.fromFirebaseUser(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(profile.toJson());

    return profile;
  }

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    
    if (!doc.exists) {
      throw Exception('User profile not found');
    }
    
    return UserProfileModel.fromJson(doc.data()!);
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .update(profile.toJson());
    
    return profile;
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}

@Injectable(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  // For now, we'll use a simple in-memory storage
  // In a real app, you'd use SharedPreferences, Hive, or SQLite
  static final Map<String, UserProfileModel> _profiles = {};

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data if no profile exists
    if (!_profiles.containsKey(userId)) {
      _profiles[userId] = UserProfileModel(
        uid: userId,
        displayName: 'John Doe',
        email: 'john.doe@example.com',
        phoneNumber: '+1 (555) 123-4567',
        address: '1234 Golden Street, Premium District, Luxury City, LC 90210',
        photoURL: null,
        dateOfBirth: DateTime(1992, 3, 15),
        gender: 'Male',
        role: 'client',
        isProfileComplete: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
    }

    return _profiles[userId]!;
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    _profiles[profile.uid] = profile;
    return profile;
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    _profiles.remove(userId);
  }

  @override
  Future<UserProfileModel> createUserProfile(firebase_auth.User user) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final profile = UserProfileModel.fromFirebaseUser(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );

    _profiles[user.uid] = profile;
    return profile;
  }
}
