class Address {
  final String id;
  final String title; // Home, Work, etc.
  final String fullAddress;
  final String street;
  final String area;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  final String? landmark;
  final String? houseNumber;
  final String? floorNumber;
  final String? buildingName;
  final String? instructions;
  final bool isDefault;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Address({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    this.landmark,
    this.houseNumber,
    this.floorNumber,
    this.buildingName,
    this.instructions,
    this.isDefault = false,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Get short display name for address
  String get shortDisplay {
    final parts = <String>[];
    
    if (houseNumber?.isNotEmpty == true) {
      parts.add(houseNumber!);
    }
    
    if (buildingName?.isNotEmpty == true) {
      parts.add(buildingName!);
    } else if (street.isNotEmpty) {
      final streetParts = street.split(' ');
      if (streetParts.length > 2) {
        parts.add('${streetParts.take(2).join(' ')}...');
      } else {
        parts.add(street);
      }
    }
    
    if (parts.isEmpty && area.isNotEmpty) {
      final areaParts = area.split(' ');
      if (areaParts.length > 2) {
        parts.add('${areaParts.take(2).join(' ')}...');
      } else {
        parts.add(area);
      }
    }
    
    return parts.isEmpty ? 'Address' : parts.join(', ');
  }

  /// Get display address for listing
  String get displayAddress {
    final parts = <String>[];
    
    if (houseNumber?.isNotEmpty == true) {
      parts.add(houseNumber!);
    }
    
    if (buildingName?.isNotEmpty == true) {
      parts.add(buildingName!);
    }
    
    if (street.isNotEmpty) {
      parts.add(street);
    }
    
    if (area.isNotEmpty) {
      parts.add(area);
    }
    
    return parts.join(', ');
  }

  Address copyWith({
    String? id,
    String? title,
    String? fullAddress,
    String? street,
    String? area,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    String? landmark,
    String? houseNumber,
    String? floorNumber,
    String? buildingName,
    String? instructions,
    bool? isDefault,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      title: title ?? this.title,
      fullAddress: fullAddress ?? this.fullAddress,
      street: street ?? this.street,
      area: area ?? this.area,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      landmark: landmark ?? this.landmark,
      houseNumber: houseNumber ?? this.houseNumber,
      floorNumber: floorNumber ?? this.floorNumber,
      buildingName: buildingName ?? this.buildingName,
      instructions: instructions ?? this.instructions,
      isDefault: isDefault ?? this.isDefault,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
