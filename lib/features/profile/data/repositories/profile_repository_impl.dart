import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/user_profile_model.dart';

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
}
