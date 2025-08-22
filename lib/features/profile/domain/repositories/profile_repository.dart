import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<UserProfile> updateUserProfile(UserProfile profile);
  Future<void> deleteUserProfile(String userId);
  Future<UserProfile> createUserProfile(firebase_auth.User user);
}
