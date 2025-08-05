import 'package:carsnan/core/errors/failures.dart';
import 'package:carsnan/features/authentication/domain/repositories/auth_repository.dart';
import 'package:carsnan/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignOutUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignOutUseCase(mockAuthRepository);
  });

  test('should call repository to sign out user', () async {
    // arrange
    when(
      () => mockAuthRepository.signOut(),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(null));
    verify(() => mockAuthRepository.signOut());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when sign out fails', () async {
    // arrange
    const tFailure = AuthFailure('Sign out failed');
    when(
      () => mockAuthRepository.signOut(),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepository.signOut());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
