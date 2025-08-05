import 'package:carsnan/core/errors/failures.dart';
import 'package:carsnan/features/authentication/domain/repositories/auth_repository.dart';
import 'package:carsnan/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SendOtpUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SendOtpUseCase(mockAuthRepository);
  });

  const tPhoneNumber = '+1234567890';

  test(
    'should call repository to send OTP when phone number is provided',
    () async {
      // arrange
      when(
        () => mockAuthRepository.sendOtp(any()),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(tPhoneNumber);

      // assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.sendOtp(tPhoneNumber));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test('should return failure when repository returns failure', () async {
    // arrange
    const tFailure = AuthFailure('Network error');
    when(
      () => mockAuthRepository.sendOtp(any()),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tPhoneNumber);

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepository.sendOtp(tPhoneNumber));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
