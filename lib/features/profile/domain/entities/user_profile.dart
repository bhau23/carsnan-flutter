class UserProfile {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String displayName;
  final String? photoURL;
  final String role;
  final bool isProfileComplete;
  final DateTime createdAt;
  final String? address;
  final DateTime? dateOfBirth;
  final String? gender;

  const UserProfile({
    required this.uid,
    this.email,
    this.phoneNumber,
    required this.displayName,
    this.photoURL,
    this.role = 'client',
    this.isProfileComplete = false,
    required this.createdAt,
    this.address,
    this.dateOfBirth,
    this.gender,
  });

  UserProfile copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoURL,
    String? role,
    bool? isProfileComplete,
    DateTime? createdAt,
    String? address,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      createdAt: createdAt ?? this.createdAt,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.uid == uid &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.displayName == displayName &&
        other.photoURL == photoURL &&
        other.role == role &&
        other.isProfileComplete == isProfileComplete &&
        other.createdAt == createdAt &&
        other.address == address &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        displayName.hashCode ^
        photoURL.hashCode ^
        role.hashCode ^
        isProfileComplete.hashCode ^
        createdAt.hashCode ^
        address.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode;
  }

  @override
  String toString() {
    return 'UserProfile(uid: $uid, email: $email, phoneNumber: $phoneNumber, displayName: $displayName, photoURL: $photoURL, role: $role, isProfileComplete: $isProfileComplete, createdAt: $createdAt, address: $address, dateOfBirth: $dateOfBirth, gender: $gender)';
  }

  // Legacy getters for backward compatibility
  String get id => uid;
  String get name => displayName;
  String get mobile => phoneNumber ?? '';
  String? get avatarUrl => photoURL;
}
