import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<UserProfile> updateUserProfile(UserProfile profile);
  Future<void> deleteUserProfile(String userId);
}
