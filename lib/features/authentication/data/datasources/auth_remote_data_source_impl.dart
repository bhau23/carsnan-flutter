import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';

import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._firebaseAuth);

  final firebase_auth.FirebaseAuth _firebaseAuth;
  String? _verificationId;
  firebase_auth.MultiFactorResolver? _mfaResolver;

  // Primary authentication methods (first factor)
  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw firebase_auth.FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found after sign in.',
        );
      }

      return UserModel.fromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthMultiFactorException catch (e) {
      // Store MFA resolver for later use
      _mfaResolver = e.resolver;
      rethrow; // Let the presentation layer handle MFA flow
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found after sign up.',
      );
    }

    return UserModel.fromFirebaseUser(user);
  }

  // MFA methods (second factor)
  @override
  Future<void> enrollPhoneNumberForMfa(String phoneNumber) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'User must be signed in to enroll MFA.',
      );
    }

    final multiFactorSession = await user.multiFactor.getSession();
    final completer = Completer<void>();

    // Start phone verification for MFA enrollment
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      multiFactorSession: multiFactorSession,
      verificationCompleted:
          (firebase_auth.PhoneAuthCredential credential) async {
            try {
              final multiFactorAssertion = firebase_auth
                  .PhoneMultiFactorGenerator.getAssertion(credential);
              await user.multiFactor.enroll(multiFactorAssertion);
              completer.complete();
            } catch (e) {
              completer.completeError(e);
            }
          },
      verificationFailed: (firebase_auth.FirebaseAuthException e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        completer.complete();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );

    return completer.future;
  }

  @override
  Future<UserModel> verifyMfaWithSms(String smsCode) async {
    if (_mfaResolver == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'no-mfa-resolver',
        message: 'No MFA resolver available. Please sign in first.',
      );
    }

    if (_verificationId == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'invalid-verification-id',
        message: 'No verification ID found. Please request SMS first.',
      );
    }

    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    final multiFactorAssertion =
        firebase_auth.PhoneMultiFactorGenerator.getAssertion(credential);
    final userCredential = await _mfaResolver!.resolveSignIn(
      multiFactorAssertion,
    );
    final user = userCredential.user;

    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found after MFA verification.',
      );
    }

    // Clear resolver after successful verification
    _mfaResolver = null;
    _verificationId = null;

    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<firebase_auth.MultiFactorResolver?> handleMfaRequired(
    firebase_auth.FirebaseAuthMultiFactorException exception,
  ) async {
    _mfaResolver = exception.resolver;

    // Get the phone number hint from enrolled factors
    final phoneFactorInfo = exception.resolver.hints
        .whereType<firebase_auth.PhoneMultiFactorInfo>()
        .firstOrNull;

    if (phoneFactorInfo != null) {
      final completer = Completer<void>();

      // Send SMS to the enrolled phone number
      await _firebaseAuth.verifyPhoneNumber(
        multiFactorInfo: phoneFactorInfo,
        multiFactorSession: exception.resolver.session,
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
              // Auto-verification (rare on most devices)
              try {
                final multiFactorAssertion = firebase_auth
                    .PhoneMultiFactorGenerator.getAssertion(credential);
                await exception.resolver.resolveSignIn(multiFactorAssertion);
                completer.complete();
              } catch (e) {
                completer.completeError(e);
              }
            },
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          completer.completeError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          completer.complete();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );

      await completer.future;
    }

    return _mfaResolver;
  }

  // Legacy phone auth methods (for backward compatibility)
  @override
  Future<void> sendOtp(String phoneNumber) async {
    final completer = Completer<void>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted:
          (firebase_auth.PhoneAuthCredential credential) async {
            // Auto-verification completed, sign in the user
            await _firebaseAuth.signInWithCredential(credential);
            completer.complete();
          },
      verificationFailed: (firebase_auth.FirebaseAuthException e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        completer.complete();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );

    return completer.future;
  }

  @override
  Future<UserModel> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'invalid-verification-id',
        message: 'No verification ID found. Please send OTP first.',
      );
    }

    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found after verification.',
      );
    }

    return UserModel.fromFirebaseUser(user);
  }

  // Common methods
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _verificationId = null;
    _mfaResolver = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }
}
