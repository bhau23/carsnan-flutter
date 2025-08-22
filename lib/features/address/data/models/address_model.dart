import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.title,
    required super.fullAddress,
    required super.street,
    required super.area,
    required super.city,
    required super.state,
    required super.pincode,
    required super.latitude,
    required super.longitude,
    super.landmark,
    super.houseNumber,
    super.floorNumber,
    super.buildingName,
    super.instructions,
    super.isDefault = false,
    super.isDeleted = false,
    super.createdAt,
    super.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      title: json['title'] as String,
      fullAddress: json['fullAddress'] as String,
      street: json['street'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      landmark: json['landmark'] as String?,
      houseNumber: json['houseNumber'] as String?,
      floorNumber: json['floorNumber'] as String?,
      buildingName: json['buildingName'] as String?,
      instructions: json['instructions'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fullAddress': fullAddress,
      'street': street,
      'area': area,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'landmark': landmark,
      'houseNumber': houseNumber,
      'floorNumber': floorNumber,
      'buildingName': buildingName,
      'instructions': instructions,
      'isDefault': isDefault,
      'isDeleted': isDeleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'fullAddress': fullAddress,
      'street': street,
      'area': area,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'landmark': landmark,
      'houseNumber': houseNumber,
      'floorNumber': floorNumber,
      'buildingName': buildingName,
      'instructions': instructions,
      'isDefault': isDefault,
      'isDeleted': isDeleted,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Create from Firestore document
  factory AddressModel.fromFirestore(String id, Map<String, dynamic> data) {
    return AddressModel(
      id: id,
      title: data['title'] as String,
      fullAddress: data['fullAddress'] as String,
      street: data['street'] as String,
      area: data['area'] as String,
      city: data['city'] as String,
      state: data['state'] as String,
      pincode: data['pincode'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      landmark: data['landmark'] as String?,
      houseNumber: data['houseNumber'] as String?,
      floorNumber: data['floorNumber'] as String?,
      buildingName: data['buildingName'] as String?,
      instructions: data['instructions'] as String?,
      isDefault: data['isDefault'] as bool? ?? false,
      isDeleted: data['isDeleted'] as bool? ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  factory AddressModel.fromDomain(Address address) {
    return AddressModel(
      id: address.id,
      title: address.title,
      fullAddress: address.fullAddress,
      street: address.street,
      area: address.area,
      city: address.city,
      state: address.state,
      pincode: address.pincode,
      latitude: address.latitude,
      longitude: address.longitude,
      landmark: address.landmark,
      houseNumber: address.houseNumber,
      floorNumber: address.floorNumber,
      buildingName: address.buildingName,
      instructions: address.instructions,
      isDefault: address.isDefault,
      isDeleted: address.isDeleted,
      createdAt: address.createdAt,
      updatedAt: address.updatedAt,
    );
  }

  /// Create a copy with updated fields
  @override
  AddressModel copyWith({
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
    return AddressModel(
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
