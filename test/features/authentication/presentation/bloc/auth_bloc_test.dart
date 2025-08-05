import 'package:bloc_test/bloc_test.dart';
import 'package:carsnan/core/errors/failures.dart';
import 'package:carsnan/features/authentication/domain/entities/user.dart';
import 'package:carsnan/features/authentication/domain/usecases/enroll_mfa_usecase.dart';
import 'package:carsnan/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:carsnan/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:carsnan/features/authentication/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:carsnan/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:carsnan/features/authentication/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:carsnan/features/authentication/domain/usecases/verify_mfa_usecase.dart';
import 'package:carsnan/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_event.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockSignInWithEmailUseCase extends Mock
    implements SignInWithEmailUseCase {}

class MockSignUpWithEmailUseCase extends Mock
    implements SignUpWithEmailUseCase {}

class MockEnrollMfaUseCase extends Mock implements EnrollMfaUseCase {}

class MockVerifyMfaUseCase extends Mock implements VerifyMfaUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockSendOtpUseCase mockSendOtpUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockSignInWithEmailUseCase mockSignInWithEmailUseCase;
  late MockSignUpWithEmailUseCase mockSignUpWithEmailUseCase;
  late MockEnrollMfaUseCase mockEnrollMfaUseCase;
  late MockVerifyMfaUseCase mockVerifyMfaUseCase;

  setUp(() {
    mockSendOtpUseCase = MockSendOtpUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockSignInWithEmailUseCase = MockSignInWithEmailUseCase();
    mockSignUpWithEmailUseCase = MockSignUpWithEmailUseCase();
    mockEnrollMfaUseCase = MockEnrollMfaUseCase();
    mockVerifyMfaUseCase = MockVerifyMfaUseCase();

    authBloc = AuthBloc(
      mockSendOtpUseCase,
      mockVerifyOtpUseCase,
      mockSignOutUseCase,
      mockGetCurrentUserUseCase,
      mockSignInWithEmailUseCase,
      mockSignUpWithEmailUseCase,
      mockEnrollMfaUseCase,
      mockVerifyMfaUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  const tPhoneNumber = '+1234567890';
  const tOtp = '123456';
  const tUser = User(
    uid: 'test-uid',
    phoneNumber: '+1234567890',
    displayName: 'Test User',
  );

  group('AuthBloc', () {
    test('initial state should be Initial', () {
      expect(authBloc.state, const Initial());
    });

    group('SendOtp', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Loading, OtpSent] when SendOtp is successful',
        build: () {
          when(
            () => mockSendOtpUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SendOtp(phoneNumber: tPhoneNumber)),
        expect: () => [const Loading(), const OtpSent()],
        verify: (_) {
          verify(() => mockSendOtpUseCase(tPhoneNumber)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Error] when SendOtp fails',
        build: () {
          when(
            () => mockSendOtpUseCase(any()),
          ).thenAnswer((_) async => const Left(AuthFailure('Network error')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SendOtp(phoneNumber: tPhoneNumber)),
        expect: () => [const Loading(), const Error(message: 'Network error')],
        verify: (_) {
          verify(() => mockSendOtpUseCase(tPhoneNumber)).called(1);
        },
      );
    });

    group('VerifyOtp', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Authenticated] when VerifyOtp is successful',
        build: () {
          when(
            () => mockVerifyOtpUseCase(any()),
          ).thenAnswer((_) async => const Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const VerifyOtp(otp: tOtp)),
        expect: () => [const Loading(), const Authenticated(user: tUser)],
        verify: (_) {
          verify(() => mockVerifyOtpUseCase(tOtp)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Error] when VerifyOtp fails',
        build: () {
          when(
            () => mockVerifyOtpUseCase(any()),
          ).thenAnswer((_) async => const Left(AuthFailure('Invalid OTP')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const VerifyOtp(otp: tOtp)),
        expect: () => [const Loading(), const Error(message: 'Invalid OTP')],
        verify: (_) {
          verify(() => mockVerifyOtpUseCase(tOtp)).called(1);
        },
      );
    });

    group('SignOut', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Unauthenticated] when SignOut is successful',
        build: () {
          when(
            () => mockSignOutUseCase(),
          ).thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SignOut()),
        expect: () => [const Loading(), const Unauthenticated()],
        verify: (_) {
          verify(() => mockSignOutUseCase()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Error] when SignOut fails',
        build: () {
          when(
            () => mockSignOutUseCase(),
          ).thenAnswer((_) async => const Left(AuthFailure('Sign out failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SignOut()),
        expect: () => [
          const Loading(),
          const Error(message: 'Sign out failed'),
        ],
        verify: (_) {
          verify(() => mockSignOutUseCase()).called(1);
        },
      );
    });

    group('CheckAuthStatus', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Authenticated] when user is logged in',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => const Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [const Loading(), const Authenticated(user: tUser)],
        verify: (_) {
          verify(() => mockGetCurrentUserUseCase()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Unauthenticated] when no user is logged in',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [const Loading(), const Unauthenticated()],
        verify: (_) {
          verify(() => mockGetCurrentUserUseCase()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Loading, Error] when CheckAuthStatus fails',
        build: () {
          when(() => mockGetCurrentUserUseCase()).thenAnswer(
            (_) async => const Left(AuthFailure('Auth check failed')),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const Loading(),
          const Error(message: 'Auth check failed'),
        ],
        verify: (_) {
          verify(() => mockGetCurrentUserUseCase()).called(1);
        },
      );
    });
  });
}
