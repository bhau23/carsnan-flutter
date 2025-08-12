import 'package:injectable/injectable.dart';

import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetUserProfileUseCase {
  final ProfileRepository repository;

  const GetUserProfileUseCase(this.repository);

  Future<UserProfile> call(String userId) async {
    return await repository.getUserProfile(userId);
  }
}
