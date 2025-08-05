import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignUpWithEmailUseCase {
  const SignUpWithEmailUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<AuthFailure, User>> call(String email, String password) async {
    return await _authRepository.signUpWithEmailAndPassword(email, password);
  }
}
