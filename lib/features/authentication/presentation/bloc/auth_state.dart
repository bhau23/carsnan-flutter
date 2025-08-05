import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.otpSent() = OtpSent;
  const factory AuthState.mfaRequired() = MfaRequired;
  const factory AuthState.mfaEnrolled() = MfaEnrolled;
  const factory AuthState.authenticated({required User user}) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.error({required String message}) = Error;
}
