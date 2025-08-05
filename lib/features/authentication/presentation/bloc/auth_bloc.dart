import 'package:bloc/bloc.dart';
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
  ) : super(const Initial()) {
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

  // Email/Password authentication handlers
  Future<void> _onSignInWithEmail(
    SignInWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const Loading());

    try {
      final result = await _signInWithEmailUseCase(event.email, event.password);

      result.fold(
        (failure) => emit(Error(message: failure.message)),
        (user) => emit(Authenticated(user: user)),
      );
    } on firebase_auth.FirebaseAuthMultiFactorException catch (e) {
      // MFA is required - trigger MFA flow
      add(HandleMfaRequired(exception: e));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const Loading());

    final result = await _signUpWithEmailUseCase(event.email, event.password);

    result.fold(
      (failure) => emit(Error(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  // MFA handlers
  Future<void> _onHandleMfaRequired(
    HandleMfaRequired event,
    Emitter<AuthState> emit,
  ) async {
    emit(const Loading());

    // Handle the MFA requirement by triggering SMS to enrolled phone
    // This will be handled in the data source, so we just emit MFA required state
    emit(const MfaRequired());
  }

  Future<void> _onVerifyMfa(VerifyMfa event, Emitter<AuthState> emit) async {
    emit(const Loading());

    final result = await _verifyMfaUseCase(event.smsCode);

    result.fold(
      (failure) => emit(Error(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onEnrollMfa(EnrollMfa event, Emitter<AuthState> emit) async {
    emit(const Loading());

    final result = await _enrollMfaUseCase(event.phoneNumber);

    result.fold(
      (failure) => emit(Error(message: failure.message)),
      (_) => emit(const MfaEnrolled()),
    );
  }

  // Legacy phone auth handlers
  Future<void> _onSendOtp(SendOtp event, Emitter<AuthState> emit) async {
    emit(const Loading());

    final result = await _sendOtpUseCase(event.phoneNumber);

    result.fold(
      (failure) => emit(Error(message: failure.message)),
      (_) => emit(const OtpSent()),
    );
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(const Loading());

    final result = await _verifyOtpUseCase(event.otp);

    result.fold(
      (failure) => emit(Error(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  // Common handlers
  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(const Loading());

    final result = await _signOutUseCase();

    result.fold(
      (failure) => emit(Error(message: failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const Loading());

    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) => emit(Error(message: failure.message)),
      (user) => user != null
          ? emit(Authenticated(user: user))
          : emit(const Unauthenticated()),
    );
  }
}
