import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  const UpdateUserProfileUseCase(this.repository);

  Future<UserProfile> call(UserProfile profile) async {
    return await repository.updateUserProfile(profile);
  }
}
