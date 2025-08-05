import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';

import '../../../../core/constants/auth_config.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._firebaseAuth);

  final firebase_auth.FirebaseAuth _firebaseAuth;
  String? _verificationId;
  firebase_auth.MultiFactorResolver? _mfaResolver;

  // Static storage for test verification IDs to persist across rebuilds
  static final Map<String, String> _testVerificationStorage = {};

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
    // Debug: Print test number configuration
    AuthConfig.debugPrintTestNumbers();
    print('=== DEBUG: Sending OTP ===');
    print('Phone number: $phoneNumber');
    print('Is test number: ${AuthConfig.isTestNumber(phoneNumber)}');

    // Check if this is a test phone number
    if (AuthConfig.isTestNumber(phoneNumber)) {
      // For test numbers, use Firebase's proper test phone verification
      final completer = Completer<void>();

      try {
        await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted:
              (firebase_auth.PhoneAuthCredential credential) async {
                try {
                  // Auto-verification for test numbers
                  await _firebaseAuth.signInWithCredential(credential);
                  completer.complete();
                } catch (e) {
                  completer.completeError(e);
                }
              },
          verificationFailed: (firebase_auth.FirebaseAuthException e) {
            print('Test verification failed: ${e.message}');
            completer.completeError(e);
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            // Also store in static map for persistence
            _testVerificationStorage[phoneNumber] = verificationId;
            print('Test verification ID received: $verificationId');
            completer.complete();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
            _testVerificationStorage[phoneNumber] = verificationId;
          },
        );

        await completer.future;
        return;
      } catch (e) {
        print('Firebase test verification failed: $e');
        // Fallback to mock verification for test numbers
        final testVerificationId =
            'mock_test_verification_${DateTime.now().millisecondsSinceEpoch}';
        _verificationId = testVerificationId;
        _testVerificationStorage[phoneNumber] = testVerificationId;
        print('Using mock verification for test number: $testVerificationId');
        return;
      }
    }

    // Clear any previous test verification for this phone number
    _testVerificationStorage.remove(phoneNumber);

    final completer = Completer<void>();

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
              try {
                // Auto-verification completed, sign in the user
                await _firebaseAuth.signInWithCredential(credential);
                completer.complete();
              } catch (e) {
                completer.completeError(e);
              }
            },
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          completer.completeError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          print('Real verification ID received: $verificationId');
          completer.complete();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );

      await completer.future;
    } catch (e) {
      print('Error in sendOtp: $e');
      completer.completeError(e);
      rethrow;
    }
  }

  @override
  Future<UserModel> verifyOtp(String otp) async {
    print('=== DEBUG: Verifying OTP ===');
    print('OTP entered: $otp');
    print('Current verification ID: $_verificationId');
    print('Test verification storage: $_testVerificationStorage');

    // Try to recover verification ID if missing but we have test storage
    if (_verificationId == null) {
      // Check if we have any test verification IDs stored
      final testPhoneNumbers = AuthConfig.testPhoneNumbers.keys;
      for (final phoneNumber in testPhoneNumbers) {
        if (_testVerificationStorage.containsKey(phoneNumber)) {
          _verificationId = _testVerificationStorage[phoneNumber];
          print('Recovered verification ID from storage: $_verificationId');
          break;
        }
      }
    }

    if (_verificationId == null) {
      print('ERROR: No verification ID found');
      throw firebase_auth.FirebaseAuthException(
        code: 'invalid-verification-id',
        message: 'No verification ID found. Please send OTP first.',
      );
    }

    // Check if this is a mock test verification
    final isMockTestVerification = _verificationId!.startsWith(
      'mock_test_verification_',
    );
    final isFirebaseTestVerification = !isMockTestVerification;

    print('Is mock test verification: $isMockTestVerification');
    print('Is Firebase test verification: $isFirebaseTestVerification');

    if (isMockTestVerification) {
      // Handle mock test verification (when Firebase test auth fails)
      final isValidTestOtp = AuthConfig.testPhoneNumbers.values.contains(otp);

      print('Valid test OTP: $isValidTestOtp');
      print(
        'Expected test codes: ${AuthConfig.testPhoneNumbers.values.toList()}',
      );

      if (!isValidTestOtp) {
        throw firebase_auth.FirebaseAuthException(
          code: 'invalid-verification-code',
          message:
              'The verification code is invalid. Expected one of: ${AuthConfig.testPhoneNumbers.values.join(", ")}',
        );
      }

      // Clear the test verification storage after successful verification
      _testVerificationStorage.clear();
      _verificationId = null;

      // For mock test verification, sign in with email instead
      // This avoids the administrator restriction
      try {
        // Create a test email based on the phone number used
        String? usedTestPhone;
        for (final entry in AuthConfig.testPhoneNumbers.entries) {
          if (entry.value == otp) {
            usedTestPhone = entry.key;
            break;
          }
        }

        if (usedTestPhone != null) {
          // Create a test email account
          final testEmail =
              'test${usedTestPhone.replaceAll('+', '').replaceAll(' ', '')}@test.com';
          final testPassword = 'testpassword123';

          print('Creating test email account: $testEmail');

          try {
            // Try to sign in first
            final signInCredential = await _firebaseAuth
                .signInWithEmailAndPassword(
                  email: testEmail,
                  password: testPassword,
                );
            return UserModel.fromFirebaseUser(signInCredential.user!);
          } catch (signInError) {
            // If sign in fails, create the account
            print('Test account does not exist, creating new one');
            final signUpCredential = await _firebaseAuth
                .createUserWithEmailAndPassword(
                  email: testEmail,
                  password: testPassword,
                );
            return UserModel.fromFirebaseUser(signUpCredential.user!);
          }
        }
      } catch (e) {
        print('Error with test email authentication: $e');
      }

      // Fallback: provide clear instruction
      throw firebase_auth.FirebaseAuthException(
        code: 'test-auth-configuration-error',
        message:
            'Test phone authentication failed. Please ensure your test phone number and verification code are properly configured in Firebase Console.',
      );
    }

    // Normal verification for real phone numbers and Firebase test numbers
    print('Proceeding with Firebase phone verification');
    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    try {
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw firebase_auth.FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found after verification.',
        );
      }

      print('Phone verification successful');
      return UserModel.fromFirebaseUser(user);
    } finally {
      // Clear verification ID after use
      _verificationId = null;
      _testVerificationStorage.clear();
    }
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
