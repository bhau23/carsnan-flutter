import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.uid,
    required this.phoneNumber,
    this.displayName,
    this.email,
    this.photoUrl,
    this.isEmailVerified = false,
    this.createdAt,
    this.lastSignInAt,
  });

  final String uid;
  final String phoneNumber;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;

  @override
  List<Object?> get props => [
    uid,
    phoneNumber,
    displayName,
    email,
    photoUrl,
    isEmailVerified,
    createdAt,
    lastSignInAt,
  ];
}
