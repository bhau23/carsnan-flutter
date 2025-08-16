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
}
