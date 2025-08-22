import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetUserProfileUseCase {
  final ProfileRepository repository;

  const GetUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call(String userId) async {
    try {
      final result = await repository.getUserProfile(userId);
      return Right(result);
    } catch (e) {
      return Left(
        GeneralFailure('Failed to get user profile: ${e.toString()}'),
      );
    }
  }
}
