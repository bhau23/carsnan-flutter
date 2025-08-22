import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  const UpdateUserProfileUseCase(this.repository);

  Future<UserProfile> call(UserProfile profile) async {
    return await repository.updateUserProfile(profile);
  }
}

@injectable
class CreateUserProfileUseCase {
  final ProfileRepository repository;

  const CreateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call(UserProfile userProfile) async {
    try {
      final result = await repository.updateUserProfile(userProfile);
      return Right(result);
    } catch (e) {
      return Left(
        GeneralFailure('Failed to create user profile: ${e.toString()}'),
      );
    }
  }
}
