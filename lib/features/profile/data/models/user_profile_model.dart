import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.uid,
    super.email,
    super.phoneNumber,
    required super.displayName,
    super.photoURL,
    super.role = 'client',
    super.isProfileComplete = false,
    required super.createdAt,
    super.address,
    super.dateOfBirth,
    super.gender,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      role: json['role'] as String? ?? 'client',
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String),
      address: json['address'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? json['dateOfBirth'] is Timestamp
              ? (json['dateOfBirth'] as Timestamp).toDate()
              : DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role,
      'isProfileComplete': isProfileComplete,
      'createdAt': Timestamp.fromDate(createdAt),
      'address': address,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
    };
  }

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      uid: profile.uid,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      displayName: profile.displayName,
      photoURL: profile.photoURL,
      role: profile.role,
      isProfileComplete: profile.isProfileComplete,
      createdAt: profile.createdAt,
      address: profile.address,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
    );
  }

  // Legacy support - create from Firebase Auth User
  factory UserProfileModel.fromFirebaseUser({
    required String uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoURL,
  }) {
    return UserProfileModel(
      uid: uid,
      email: email,
      phoneNumber: phoneNumber,
      displayName: displayName ?? 'User',
      photoURL: photoURL,
      role: 'client',
      isProfileComplete: false,
      createdAt: DateTime.now(),
    );
  }
}
