import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/user_profile_model.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  const ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    return await localDataSource.getUserProfile(userId);
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    return await localDataSource.updateUserProfile(model);
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    return await localDataSource.deleteUserProfile(userId);
  }

  @override
  Future<UserProfile> createUserProfile(firebase_auth.User user) async {
    // For local datasource, we'll create a UserProfileModel from Firebase user
    final profile = UserProfileModel.fromFirebaseUser(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
    return await localDataSource.updateUserProfile(profile);
  }
}
