import 'package:bloc/bloc.dart';
import 'package:carsnan/features/authentication/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';

import '../../domain/usecases/enroll_mfa_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';
import '../../domain/usecases/verify_mfa_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../../profile/domain/usecases/get_user_profile_usecase.dart';
import '../../../profile/domain/usecases/update_user_profile_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._sendOtpUseCase,
    this._verifyOtpUseCase,
    this._signOutUseCase,
    this._getCurrentUserUseCase,
    this._signInWithEmailUseCase,
    this._signUpWithEmailUseCase,
    this._enrollMfaUseCase,
    this._verifyMfaUseCase,
    this._getUserProfileUseCase,
    this._createUserProfileUseCase,
    this._updateUserProfileUseCase,
  ) : super(const AuthState.initial()) {
    // Email/Password authentication events
    on<SignInWithEmail>(_onSignInWithEmail);
    on<SignUpWithEmail>(_onSignUpWithEmail);

    // MFA events
    on<HandleMfaRequired>(_onHandleMfaRequired);
    on<VerifyMfa>(_onVerifyMfa);
    on<EnrollMfa>(_onEnrollMfa);

    // Legacy phone auth events
    on<SendOtp>(_onSendOtp);
    on<VerifyOtp>(_onVerifyOtp);

    // Profile completion events
    on<CheckProfileCompletion>(_onCheckProfileCompletion);
    on<CompleteProfile>(_onCompleteProfile);

    // Common events
    on<SignOut>(_onSignOut);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final EnrollMfaUseCase _enrollMfaUseCase;
  final VerifyMfaUseCase _verifyMfaUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final CreateUserProfileUseCase _createUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  // Email/Password authentication handlers
  Future<void> _onSignInWithEmail(
    SignInWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    try {
      final result = await _signInWithEmailUseCase.call(
        event.email,
        event.password,
      );

      result.fold(
        (failure) => emit(AuthState.error(message: failure.message)),
        (user) {
          // For existing users, check if profile is complete
          add(CheckProfileCompletion(user: user));
        },
      );
    } on firebase_auth.FirebaseAuthMultiFactorException catch (e) {
      // MFA is required - trigger MFA flow
      add(HandleMfaRequired(exception: e));
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _signUpWithEmailUseCase.call(
      event.email,
      event.password,
    );

    result.fold((failure) => emit(AuthState.error(message: failure.message)), (
      user,
    ) {
      // For new users, check if profile needs completion
      add(CheckProfileCompletion(user: user));
    });
  }

  // MFA handlers
  Future<void> _onHandleMfaRequired(
    HandleMfaRequired event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    // Handle the MFA requirement by triggering SMS to enrolled phone
    // This will be handled in the data source, so we just emit MFA required state
    emit(const AuthState.mfaRequired());
  }

  Future<void> _onVerifyMfa(VerifyMfa event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await _verifyMfaUseCase.call(event.smsCode);

    result.fold((failure) => emit(AuthState.error(message: failure.message)), (
      user,
    ) {
      // After MFA verification, check if profile is complete
      add(CheckProfileCompletion(user: user));
    });
  }

  Future<void> _onEnrollMfa(EnrollMfa event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await _enrollMfaUseCase.call(event.phoneNumber);

    result.fold(
      (failure) => emit(AuthState.error(message: failure.message)),
      (_) => emit(const AuthState.mfaEnrolled()),
    );
  }

  // Legacy phone auth handlers
  Future<void> _onSendOtp(SendOtp event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await _sendOtpUseCase.call(event.phoneNumber);

    result.fold(
      (failure) => emit(AuthState.error(message: failure.message)),
      (_) => emit(const AuthState.otpSent()),
    );
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await _verifyOtpUseCase.call(event.otp);

    result.fold((failure) => emit(AuthState.error(message: failure.message)), (
      user,
    ) {
      // After OTP verification, check if profile is complete
      add(CheckProfileCompletion(user: user));
    });
  }

  // Common handlers
  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await _signOutUseCase.call();

    result.fold(
      (failure) => emit(AuthState.error(message: failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _getCurrentUserUseCase.call();

    result.fold((failure) => emit(AuthState.error(message: failure.message)), (
      user,
    ) {
      if (user != null) {
        // User is signed in, check if profile is complete
        add(CheckProfileCompletion(user: user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> _onCheckProfileCompletion(
    CheckProfileCompletion event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());

      // Get user profile from Firestore
      final userProfileResult = await _getUserProfileUseCase.call(
        event.user.uid,
      );

      userProfileResult.fold(
        (failure) {
          // Profile doesn't exist, user needs to complete profile
          emit(AuthState.profileIncomplete(user: event.user));
        },
        (userProfile) {
          // Check if profile is complete
          if (userProfile.isProfileComplete) {
            emit(AuthState.authenticated(user: event.user));
          } else {
            emit(AuthState.profileIncomplete(user: event.user));
          }
        },
      );
    } catch (e) {
      emit(AuthState.error(message: 'Failed to check profile completion: $e'));
    }
  }

  Future<void> _onCompleteProfile(
    CompleteProfile event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());

      // Create new user profile in Firestore
      final createResult = await _createUserProfileUseCase.call(
        event.userProfile,
      );

      createResult.fold(
        (failure) {
          emit(
            AuthState.error(
              message: 'Failed to create profile: ${failure.message}',
            ),
          );
        },
        (_) {
          // Profile created successfully, authenticate the user
          final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

          if (currentUser != null) {
            final localUser = User(
              uid: currentUser.uid,
              phoneNumber: currentUser.phoneNumber ?? "",
            );
            emit(AuthState.authenticated(user: localUser));
          } else {
            emit(
              const AuthState.error(
                message: 'User not found after profile creation',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(AuthState.error(message: 'Failed to complete profile: $e'));
    }
  }
}
