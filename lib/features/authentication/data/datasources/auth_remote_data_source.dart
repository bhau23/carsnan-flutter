import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  // Primary authentication methods (first factor)
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(String email, String password);

  // MFA methods (second factor)
  Future<void> enrollPhoneNumberForMfa(String phoneNumber);
  Future<UserModel> verifyMfaWithSms(String smsCode);
  Future<firebase_auth.MultiFactorResolver?> handleMfaRequired(
    firebase_auth.FirebaseAuthMultiFactorException exception,
  );

  // Legacy phone auth methods (for backward compatibility if needed)
  Future<void> sendOtp(String phoneNumber);
  Future<UserModel> verifyOtp(String otp);

  // Common methods
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}
