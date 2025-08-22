import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';
import '../../../profile/domain/entities/user_profile.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  // Email/Password authentication events
  const factory AuthEvent.signInWithEmail({
    required String email,
    required String password,
  }) = SignInWithEmail;

  const factory AuthEvent.signUpWithEmail({
    required String email,
    required String password,
  }) = SignUpWithEmail;

  // MFA events
  const factory AuthEvent.handleMfaRequired({
    required firebase_auth.FirebaseAuthMultiFactorException exception,
  }) = HandleMfaRequired;

  const factory AuthEvent.verifyMfa({required String smsCode}) = VerifyMfa;

  const factory AuthEvent.enrollMfa({required String phoneNumber}) = EnrollMfa;

  // Legacy phone auth events (for backward compatibility)
  const factory AuthEvent.sendOtp({required String phoneNumber}) = SendOtp;
  const factory AuthEvent.verifyOtp({required String otp}) = VerifyOtp;

  // Profile completion events
  const factory AuthEvent.checkProfileCompletion({required User user}) = CheckProfileCompletion;
  const factory AuthEvent.completeProfile({required UserProfile userProfile}) = CompleteProfile;

  // Common events
  const factory AuthEvent.signOut() = SignOut;
  const factory AuthEvent.checkAuthStatus() = CheckAuthStatus;
}
