import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendOtpUseCase {
  const SendOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<AuthFailure, void>> call(String phoneNumber) async {
    return await _repository.sendOtp(phoneNumber);
  }
}
