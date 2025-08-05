import 'package:carsnan/core/errors/failures.dart';
import 'package:carsnan/features/authentication/domain/entities/user.dart';
import 'package:carsnan/features/authentication/domain/repositories/auth_repository.dart';
import 'package:carsnan/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late VerifyOtpUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = VerifyOtpUseCase(mockAuthRepository);
  });

  const tOtp = '123456';
  const tUser = User(
    uid: 'test-uid',
    phoneNumber: '+1234567890',
    displayName: 'Test User',
  );

  test('should return user when OTP verification is successful', () async {
    // arrange
    when(
      () => mockAuthRepository.verifyOtp(any()),
    ).thenAnswer((_) async => const Right(tUser));

    // act
    final result = await usecase(tOtp);

    // assert
    expect(result, const Right(tUser));
    verify(() => mockAuthRepository.verifyOtp(tOtp));
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when OTP verification fails', () async {
    // arrange
    const tFailure = AuthFailure('Invalid OTP code');
    when(
      () => mockAuthRepository.verifyOtp(any()),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tOtp);

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepository.verifyOtp(tOtp));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
