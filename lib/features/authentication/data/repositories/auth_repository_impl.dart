import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  // Primary authentication methods (first factor)
  @override
  Future<Either<AuthFailure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return Right(userModel.toEntity());
    } on firebase_auth.FirebaseAuthMultiFactorException {
      // MFA required - let this exception bubble up to be handled in the presentation layer
      rethrow;
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Unknown error occurred', e.code));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, User>> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmailAndPassword(
        email,
        password,
      );
      return Right(userModel.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Unknown error occurred', e.code));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  // MFA methods (second factor)
  @override
  Future<Either<AuthFailure, void>> enrollPhoneNumberForMfa(
    String phoneNumber,
  ) async {
    try {
      await _remoteDataSource.enrollPhoneNumberForMfa(phoneNumber);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Unknown error occurred', e.code));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, User>> verifyMfaWithSms(String smsCode) async {
    try {
      final userModel = await _remoteDataSource.verifyMfaWithSms(smsCode);
      return Right(userModel.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Unknown error occurred', e.code));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, firebase_auth.MultiFactorResolver?>>
  handleMfaRequired(
    firebase_auth.FirebaseAuthMultiFactorException exception,
  ) async {
    try {
      final resolver = await _remoteDataSource.handleMfaRequired(exception);
      return Right(resolver);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Unknown error occurred', e.code));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  // Legacy phone auth methods (for backward compatibility)
  @override
  Future<Either<AuthFailure, void>> sendOtp(String phoneNumber) async {
    try {
      await _remoteDataSource.sendOtp(phoneNumber);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Unknown error occurred', e.code));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, User>> verifyOtp(String otp) async {
    try {
      final userModel = await _remoteDataSource.verifyOtp(otp);
      return Right(userModel.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Unknown error occurred', e.code));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  // Common methods
  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Unknown error occurred', e.code));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, User?>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return Right(userModel?.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Unknown error occurred', e.code));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((userModel) {
      return userModel?.toEntity();
    });
  }
}
