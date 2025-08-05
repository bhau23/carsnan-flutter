import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyMfaUseCase {
  const VerifyMfaUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<AuthFailure, User>> call(String smsCode) async {
    return await _authRepository.verifyMfaWithSms(smsCode);
  }
}
