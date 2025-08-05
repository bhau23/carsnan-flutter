// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  phoneNumber: json['phoneNumber'] as String,
  displayName: json['displayName'] as String?,
  email: json['email'] as String?,
  photoUrl: json['photoUrl'] as String?,
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  lastSignInAt: json['lastSignInAt'] == null
      ? null
      : DateTime.parse(json['lastSignInAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'phoneNumber': instance.phoneNumber,
      'displayName': instance.displayName,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'isEmailVerified': instance.isEmailVerified,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastSignInAt': instance.lastSignInAt?.toIso8601String(),
    };
