// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SignInWithEmail value)?  signInWithEmail,TResult Function( SignUpWithEmail value)?  signUpWithEmail,TResult Function( HandleMfaRequired value)?  handleMfaRequired,TResult Function( VerifyMfa value)?  verifyMfa,TResult Function( EnrollMfa value)?  enrollMfa,TResult Function( SendOtp value)?  sendOtp,TResult Function( VerifyOtp value)?  verifyOtp,TResult Function( SignOut value)?  signOut,TResult Function( CheckAuthStatus value)?  checkAuthStatus,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SignInWithEmail() when signInWithEmail != null:
return signInWithEmail(_that);case SignUpWithEmail() when signUpWithEmail != null:
return signUpWithEmail(_that);case HandleMfaRequired() when handleMfaRequired != null:
return handleMfaRequired(_that);case VerifyMfa() when verifyMfa != null:
return verifyMfa(_that);case EnrollMfa() when enrollMfa != null:
return enrollMfa(_that);case SendOtp() when sendOtp != null:
return sendOtp(_that);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case SignOut() when signOut != null:
return signOut(_that);case CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SignInWithEmail value)  signInWithEmail,required TResult Function( SignUpWithEmail value)  signUpWithEmail,required TResult Function( HandleMfaRequired value)  handleMfaRequired,required TResult Function( VerifyMfa value)  verifyMfa,required TResult Function( EnrollMfa value)  enrollMfa,required TResult Function( SendOtp value)  sendOtp,required TResult Function( VerifyOtp value)  verifyOtp,required TResult Function( SignOut value)  signOut,required TResult Function( CheckAuthStatus value)  checkAuthStatus,}){
final _that = this;
switch (_that) {
case SignInWithEmail():
return signInWithEmail(_that);case SignUpWithEmail():
return signUpWithEmail(_that);case HandleMfaRequired():
return handleMfaRequired(_that);case VerifyMfa():
return verifyMfa(_that);case EnrollMfa():
return enrollMfa(_that);case SendOtp():
return sendOtp(_that);case VerifyOtp():
return verifyOtp(_that);case SignOut():
return signOut(_that);case CheckAuthStatus():
return checkAuthStatus(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SignInWithEmail value)?  signInWithEmail,TResult? Function( SignUpWithEmail value)?  signUpWithEmail,TResult? Function( HandleMfaRequired value)?  handleMfaRequired,TResult? Function( VerifyMfa value)?  verifyMfa,TResult? Function( EnrollMfa value)?  enrollMfa,TResult? Function( SendOtp value)?  sendOtp,TResult? Function( VerifyOtp value)?  verifyOtp,TResult? Function( SignOut value)?  signOut,TResult? Function( CheckAuthStatus value)?  checkAuthStatus,}){
final _that = this;
switch (_that) {
case SignInWithEmail() when signInWithEmail != null:
return signInWithEmail(_that);case SignUpWithEmail() when signUpWithEmail != null:
return signUpWithEmail(_that);case HandleMfaRequired() when handleMfaRequired != null:
return handleMfaRequired(_that);case VerifyMfa() when verifyMfa != null:
return verifyMfa(_that);case EnrollMfa() when enrollMfa != null:
return enrollMfa(_that);case SendOtp() when sendOtp != null:
return sendOtp(_that);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case SignOut() when signOut != null:
return signOut(_that);case CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email,  String password)?  signInWithEmail,TResult Function( String email,  String password)?  signUpWithEmail,TResult Function( firebase_auth.FirebaseAuthMultiFactorException exception)?  handleMfaRequired,TResult Function( String smsCode)?  verifyMfa,TResult Function( String phoneNumber)?  enrollMfa,TResult Function( String phoneNumber)?  sendOtp,TResult Function( String otp)?  verifyOtp,TResult Function()?  signOut,TResult Function()?  checkAuthStatus,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SignInWithEmail() when signInWithEmail != null:
return signInWithEmail(_that.email,_that.password);case SignUpWithEmail() when signUpWithEmail != null:
return signUpWithEmail(_that.email,_that.password);case HandleMfaRequired() when handleMfaRequired != null:
return handleMfaRequired(_that.exception);case VerifyMfa() when verifyMfa != null:
return verifyMfa(_that.smsCode);case EnrollMfa() when enrollMfa != null:
return enrollMfa(_that.phoneNumber);case SendOtp() when sendOtp != null:
return sendOtp(_that.phoneNumber);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.otp);case SignOut() when signOut != null:
return signOut();case CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email,  String password)  signInWithEmail,required TResult Function( String email,  String password)  signUpWithEmail,required TResult Function( firebase_auth.FirebaseAuthMultiFactorException exception)  handleMfaRequired,required TResult Function( String smsCode)  verifyMfa,required TResult Function( String phoneNumber)  enrollMfa,required TResult Function( String phoneNumber)  sendOtp,required TResult Function( String otp)  verifyOtp,required TResult Function()  signOut,required TResult Function()  checkAuthStatus,}) {final _that = this;
switch (_that) {
case SignInWithEmail():
return signInWithEmail(_that.email,_that.password);case SignUpWithEmail():
return signUpWithEmail(_that.email,_that.password);case HandleMfaRequired():
return handleMfaRequired(_that.exception);case VerifyMfa():
return verifyMfa(_that.smsCode);case EnrollMfa():
return enrollMfa(_that.phoneNumber);case SendOtp():
return sendOtp(_that.phoneNumber);case VerifyOtp():
return verifyOtp(_that.otp);case SignOut():
return signOut();case CheckAuthStatus():
return checkAuthStatus();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email,  String password)?  signInWithEmail,TResult? Function( String email,  String password)?  signUpWithEmail,TResult? Function( firebase_auth.FirebaseAuthMultiFactorException exception)?  handleMfaRequired,TResult? Function( String smsCode)?  verifyMfa,TResult? Function( String phoneNumber)?  enrollMfa,TResult? Function( String phoneNumber)?  sendOtp,TResult? Function( String otp)?  verifyOtp,TResult? Function()?  signOut,TResult? Function()?  checkAuthStatus,}) {final _that = this;
switch (_that) {
case SignInWithEmail() when signInWithEmail != null:
return signInWithEmail(_that.email,_that.password);case SignUpWithEmail() when signUpWithEmail != null:
return signUpWithEmail(_that.email,_that.password);case HandleMfaRequired() when handleMfaRequired != null:
return handleMfaRequired(_that.exception);case VerifyMfa() when verifyMfa != null:
return verifyMfa(_that.smsCode);case EnrollMfa() when enrollMfa != null:
return enrollMfa(_that.phoneNumber);case SendOtp() when sendOtp != null:
return sendOtp(_that.phoneNumber);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.otp);case SignOut() when signOut != null:
return signOut();case CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus();case _:
  return null;

}
}

}

/// @nodoc


class SignInWithEmail implements AuthEvent {
  const SignInWithEmail({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInWithEmailCopyWith<SignInWithEmail> get copyWith => _$SignInWithEmailCopyWithImpl<SignInWithEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInWithEmail&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.signInWithEmail(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $SignInWithEmailCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SignInWithEmailCopyWith(SignInWithEmail value, $Res Function(SignInWithEmail) _then) = _$SignInWithEmailCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$SignInWithEmailCopyWithImpl<$Res>
    implements $SignInWithEmailCopyWith<$Res> {
  _$SignInWithEmailCopyWithImpl(this._self, this._then);

  final SignInWithEmail _self;
  final $Res Function(SignInWithEmail) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(SignInWithEmail(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignUpWithEmail implements AuthEvent {
  const SignUpWithEmail({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpWithEmailCopyWith<SignUpWithEmail> get copyWith => _$SignUpWithEmailCopyWithImpl<SignUpWithEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpWithEmail&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.signUpWithEmail(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $SignUpWithEmailCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SignUpWithEmailCopyWith(SignUpWithEmail value, $Res Function(SignUpWithEmail) _then) = _$SignUpWithEmailCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$SignUpWithEmailCopyWithImpl<$Res>
    implements $SignUpWithEmailCopyWith<$Res> {
  _$SignUpWithEmailCopyWithImpl(this._self, this._then);

  final SignUpWithEmail _self;
  final $Res Function(SignUpWithEmail) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(SignUpWithEmail(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HandleMfaRequired implements AuthEvent {
  const HandleMfaRequired({required this.exception});
  

 final  firebase_auth.FirebaseAuthMultiFactorException exception;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HandleMfaRequiredCopyWith<HandleMfaRequired> get copyWith => _$HandleMfaRequiredCopyWithImpl<HandleMfaRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HandleMfaRequired&&(identical(other.exception, exception) || other.exception == exception));
}


@override
int get hashCode => Object.hash(runtimeType,exception);

@override
String toString() {
  return 'AuthEvent.handleMfaRequired(exception: $exception)';
}


}

/// @nodoc
abstract mixin class $HandleMfaRequiredCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $HandleMfaRequiredCopyWith(HandleMfaRequired value, $Res Function(HandleMfaRequired) _then) = _$HandleMfaRequiredCopyWithImpl;
@useResult
$Res call({
 firebase_auth.FirebaseAuthMultiFactorException exception
});




}
/// @nodoc
class _$HandleMfaRequiredCopyWithImpl<$Res>
    implements $HandleMfaRequiredCopyWith<$Res> {
  _$HandleMfaRequiredCopyWithImpl(this._self, this._then);

  final HandleMfaRequired _self;
  final $Res Function(HandleMfaRequired) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? exception = null,}) {
  return _then(HandleMfaRequired(
exception: null == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as firebase_auth.FirebaseAuthMultiFactorException,
  ));
}


}

/// @nodoc


class VerifyMfa implements AuthEvent {
  const VerifyMfa({required this.smsCode});
  

 final  String smsCode;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyMfaCopyWith<VerifyMfa> get copyWith => _$VerifyMfaCopyWithImpl<VerifyMfa>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyMfa&&(identical(other.smsCode, smsCode) || other.smsCode == smsCode));
}


@override
int get hashCode => Object.hash(runtimeType,smsCode);

@override
String toString() {
  return 'AuthEvent.verifyMfa(smsCode: $smsCode)';
}


}

/// @nodoc
abstract mixin class $VerifyMfaCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $VerifyMfaCopyWith(VerifyMfa value, $Res Function(VerifyMfa) _then) = _$VerifyMfaCopyWithImpl;
@useResult
$Res call({
 String smsCode
});




}
/// @nodoc
class _$VerifyMfaCopyWithImpl<$Res>
    implements $VerifyMfaCopyWith<$Res> {
  _$VerifyMfaCopyWithImpl(this._self, this._then);

  final VerifyMfa _self;
  final $Res Function(VerifyMfa) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? smsCode = null,}) {
  return _then(VerifyMfa(
smsCode: null == smsCode ? _self.smsCode : smsCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EnrollMfa implements AuthEvent {
  const EnrollMfa({required this.phoneNumber});
  

 final  String phoneNumber;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrollMfaCopyWith<EnrollMfa> get copyWith => _$EnrollMfaCopyWithImpl<EnrollMfa>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrollMfa&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber);

@override
String toString() {
  return 'AuthEvent.enrollMfa(phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class $EnrollMfaCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $EnrollMfaCopyWith(EnrollMfa value, $Res Function(EnrollMfa) _then) = _$EnrollMfaCopyWithImpl;
@useResult
$Res call({
 String phoneNumber
});




}
/// @nodoc
class _$EnrollMfaCopyWithImpl<$Res>
    implements $EnrollMfaCopyWith<$Res> {
  _$EnrollMfaCopyWithImpl(this._self, this._then);

  final EnrollMfa _self;
  final $Res Function(EnrollMfa) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,}) {
  return _then(EnrollMfa(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SendOtp implements AuthEvent {
  const SendOtp({required this.phoneNumber});
  

 final  String phoneNumber;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendOtpCopyWith<SendOtp> get copyWith => _$SendOtpCopyWithImpl<SendOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendOtp&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber);

@override
String toString() {
  return 'AuthEvent.sendOtp(phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class $SendOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SendOtpCopyWith(SendOtp value, $Res Function(SendOtp) _then) = _$SendOtpCopyWithImpl;
@useResult
$Res call({
 String phoneNumber
});




}
/// @nodoc
class _$SendOtpCopyWithImpl<$Res>
    implements $SendOtpCopyWith<$Res> {
  _$SendOtpCopyWithImpl(this._self, this._then);

  final SendOtp _self;
  final $Res Function(SendOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,}) {
  return _then(SendOtp(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class VerifyOtp implements AuthEvent {
  const VerifyOtp({required this.otp});
  

 final  String otp;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpCopyWith<VerifyOtp> get copyWith => _$VerifyOtpCopyWithImpl<VerifyOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtp&&(identical(other.otp, otp) || other.otp == otp));
}


@override
int get hashCode => Object.hash(runtimeType,otp);

@override
String toString() {
  return 'AuthEvent.verifyOtp(otp: $otp)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $VerifyOtpCopyWith(VerifyOtp value, $Res Function(VerifyOtp) _then) = _$VerifyOtpCopyWithImpl;
@useResult
$Res call({
 String otp
});




}
/// @nodoc
class _$VerifyOtpCopyWithImpl<$Res>
    implements $VerifyOtpCopyWith<$Res> {
  _$VerifyOtpCopyWithImpl(this._self, this._then);

  final VerifyOtp _self;
  final $Res Function(VerifyOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? otp = null,}) {
  return _then(VerifyOtp(
otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignOut implements AuthEvent {
  const SignOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.signOut()';
}


}




/// @nodoc


class CheckAuthStatus implements AuthEvent {
  const CheckAuthStatus();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckAuthStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.checkAuthStatus()';
}


}




// dart format on
