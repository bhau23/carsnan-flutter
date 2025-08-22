// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( OtpSent value)?  otpSent,TResult Function( MfaRequired value)?  mfaRequired,TResult Function( MfaEnrolled value)?  mfaEnrolled,TResult Function( Authenticated value)?  authenticated,TResult Function( ProfileIncomplete value)?  profileIncomplete,TResult Function( Unauthenticated value)?  unauthenticated,TResult Function( Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case OtpSent() when otpSent != null:
return otpSent(_that);case MfaRequired() when mfaRequired != null:
return mfaRequired(_that);case MfaEnrolled() when mfaEnrolled != null:
return mfaEnrolled(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case ProfileIncomplete() when profileIncomplete != null:
return profileIncomplete(_that);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( OtpSent value)  otpSent,required TResult Function( MfaRequired value)  mfaRequired,required TResult Function( MfaEnrolled value)  mfaEnrolled,required TResult Function( Authenticated value)  authenticated,required TResult Function( ProfileIncomplete value)  profileIncomplete,required TResult Function( Unauthenticated value)  unauthenticated,required TResult Function( Error value)  error,}){
final _that = this;
switch (_that) {
case Initial():
return initial(_that);case Loading():
return loading(_that);case OtpSent():
return otpSent(_that);case MfaRequired():
return mfaRequired(_that);case MfaEnrolled():
return mfaEnrolled(_that);case Authenticated():
return authenticated(_that);case ProfileIncomplete():
return profileIncomplete(_that);case Unauthenticated():
return unauthenticated(_that);case Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( OtpSent value)?  otpSent,TResult? Function( MfaRequired value)?  mfaRequired,TResult? Function( MfaEnrolled value)?  mfaEnrolled,TResult? Function( Authenticated value)?  authenticated,TResult? Function( ProfileIncomplete value)?  profileIncomplete,TResult? Function( Unauthenticated value)?  unauthenticated,TResult? Function( Error value)?  error,}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case OtpSent() when otpSent != null:
return otpSent(_that);case MfaRequired() when mfaRequired != null:
return mfaRequired(_that);case MfaEnrolled() when mfaEnrolled != null:
return mfaEnrolled(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case ProfileIncomplete() when profileIncomplete != null:
return profileIncomplete(_that);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  otpSent,TResult Function()?  mfaRequired,TResult Function()?  mfaEnrolled,TResult Function( User user)?  authenticated,TResult Function( User user)?  profileIncomplete,TResult Function()?  unauthenticated,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case OtpSent() when otpSent != null:
return otpSent();case MfaRequired() when mfaRequired != null:
return mfaRequired();case MfaEnrolled() when mfaEnrolled != null:
return mfaEnrolled();case Authenticated() when authenticated != null:
return authenticated(_that.user);case ProfileIncomplete() when profileIncomplete != null:
return profileIncomplete(_that.user);case Unauthenticated() when unauthenticated != null:
return unauthenticated();case Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  otpSent,required TResult Function()  mfaRequired,required TResult Function()  mfaEnrolled,required TResult Function( User user)  authenticated,required TResult Function( User user)  profileIncomplete,required TResult Function()  unauthenticated,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case Initial():
return initial();case Loading():
return loading();case OtpSent():
return otpSent();case MfaRequired():
return mfaRequired();case MfaEnrolled():
return mfaEnrolled();case Authenticated():
return authenticated(_that.user);case ProfileIncomplete():
return profileIncomplete(_that.user);case Unauthenticated():
return unauthenticated();case Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  otpSent,TResult? Function()?  mfaRequired,TResult? Function()?  mfaEnrolled,TResult? Function( User user)?  authenticated,TResult? Function( User user)?  profileIncomplete,TResult? Function()?  unauthenticated,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case OtpSent() when otpSent != null:
return otpSent();case MfaRequired() when mfaRequired != null:
return mfaRequired();case MfaEnrolled() when mfaEnrolled != null:
return mfaEnrolled();case Authenticated() when authenticated != null:
return authenticated(_that.user);case ProfileIncomplete() when profileIncomplete != null:
return profileIncomplete(_that.user);case Unauthenticated() when unauthenticated != null:
return unauthenticated();case Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class Initial implements AuthState {
  const Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class Loading implements AuthState {
  const Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class OtpSent implements AuthState {
  const OtpSent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpSent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.otpSent()';
}


}




/// @nodoc


class MfaRequired implements AuthState {
  const MfaRequired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MfaRequired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.mfaRequired()';
}


}




/// @nodoc


class MfaEnrolled implements AuthState {
  const MfaEnrolled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MfaEnrolled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.mfaEnrolled()';
}


}




/// @nodoc


class Authenticated implements AuthState {
  const Authenticated({required this.user});
  

 final  User user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedCopyWith<Authenticated> get copyWith => _$AuthenticatedCopyWithImpl<Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Authenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthenticatedCopyWith(Authenticated value, $Res Function(Authenticated) _then) = _$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 User user
});




}
/// @nodoc
class _$AuthenticatedCopyWithImpl<$Res>
    implements $AuthenticatedCopyWith<$Res> {
  _$AuthenticatedCopyWithImpl(this._self, this._then);

  final Authenticated _self;
  final $Res Function(Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(Authenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}


}

/// @nodoc


class ProfileIncomplete implements AuthState {
  const ProfileIncomplete({required this.user});
  

 final  User user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileIncompleteCopyWith<ProfileIncomplete> get copyWith => _$ProfileIncompleteCopyWithImpl<ProfileIncomplete>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileIncomplete&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.profileIncomplete(user: $user)';
}


}

/// @nodoc
abstract mixin class $ProfileIncompleteCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $ProfileIncompleteCopyWith(ProfileIncomplete value, $Res Function(ProfileIncomplete) _then) = _$ProfileIncompleteCopyWithImpl;
@useResult
$Res call({
 User user
});




}
/// @nodoc
class _$ProfileIncompleteCopyWithImpl<$Res>
    implements $ProfileIncompleteCopyWith<$Res> {
  _$ProfileIncompleteCopyWithImpl(this._self, this._then);

  final ProfileIncomplete _self;
  final $Res Function(ProfileIncomplete) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(ProfileIncomplete(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}


}

/// @nodoc


class Unauthenticated implements AuthState {
  const Unauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class Error implements AuthState {
  const Error({required this.message});
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCopyWith<Error> get copyWith => _$ErrorCopyWithImpl<Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) = _$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ErrorCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
