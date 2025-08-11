class UserProfile {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String address;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final String? gender;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? mobile,
    String? address,
    String? avatarUrl,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.mobile == mobile &&
        other.address == address &&
        other.avatarUrl == avatarUrl &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        mobile.hashCode ^
        address.hashCode ^
        avatarUrl.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode;
  }
}
