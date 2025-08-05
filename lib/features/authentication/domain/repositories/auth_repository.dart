import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // Primary authentication methods (first factor)
  Future<Either<AuthFailure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<AuthFailure, User>> signUpWithEmailAndPassword(
    String email,
    String password,
  );

  // MFA methods (second factor)
  Future<Either<AuthFailure, void>> enrollPhoneNumberForMfa(String phoneNumber);
  Future<Either<AuthFailure, User>> verifyMfaWithSms(String smsCode);
  Future<Either<AuthFailure, firebase_auth.MultiFactorResolver?>>
  handleMfaRequired(firebase_auth.FirebaseAuthMultiFactorException exception);

  // Legacy phone auth methods (for backward compatibility)
  Future<Either<AuthFailure, void>> sendOtp(String phoneNumber);
  Future<Either<AuthFailure, User>> verifyOtp(String otp);

  // Common methods
  Future<Either<AuthFailure, void>> signOut();
  Future<Either<AuthFailure, User?>> getCurrentUser();
  Stream<User?> get authStateChanges;
}
