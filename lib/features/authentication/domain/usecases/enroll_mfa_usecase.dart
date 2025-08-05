import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class EnrollMfaUseCase {
  const EnrollMfaUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<AuthFailure, void>> call(String phoneNumber) async {
    return await _authRepository.enrollPhoneNumberForMfa(phoneNumber);
  }
}
