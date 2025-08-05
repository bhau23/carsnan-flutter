import 'package:carsnan/core/errors/failures.dart';
import 'package:carsnan/features/authentication/domain/entities/user.dart';
import 'package:carsnan/features/authentication/domain/repositories/auth_repository.dart';
import 'package:carsnan/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentUserUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUserUseCase(mockAuthRepository);
  });

  const tUser = User(
    uid: 'test-uid',
    phoneNumber: '+1234567890',
    displayName: 'Test User',
  );

  test('should return current user when user is logged in', () async {
    // arrange
    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => const Right(tUser));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(tUser));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return null when no user is logged in', () async {
    // arrange
    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(null));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when getting current user fails', () async {
    // arrange
    const tFailure = AuthFailure('Failed to get current user');
    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
