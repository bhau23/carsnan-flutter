import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);
  Future<void> deleteUserProfile(String userId);
}

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
        id: userId,
        name: 'John Doe',
        email: 'john.doe@example.com',
        mobile: '+1 (555) 123-4567',
        address: '1234 Golden Street, Premium District, Luxury City, LC 90210',
        avatarUrl: null,
        dateOfBirth: DateTime(1992, 3, 15),
        gender: 'Male',
      );
    }
    
    return _profiles[userId]!;
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    _profiles[profile.id] = profile;
    return profile;
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    _profiles.remove(userId);
  }
}
