import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/car.dart';

part 'car_model.g.dart';

@JsonSerializable()
class CarModel {
  const CarModel({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    this.nickname,
    required this.type,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String make;
  final String model;
  final int year;
  final String color;
  final String licensePlate;
  final String? nickname;
  @JsonKey(unknownEnumValue: CarType.sedan)
  final CarType type;
  final bool isDefault;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarModelToJson(this);

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'licensePlate': licensePlate,
      'nickname': nickname,
      'type': type.name,
      'isDefault': isDefault,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create from Firestore document
  factory CarModel.fromFirestore(String id, Map<String, dynamic> data) {
    return CarModel(
      id: id,
      make: data['make'] as String,
      model: data['model'] as String,
      year: data['year'] as int,
      color: data['color'] as String,
      licensePlate: data['licensePlate'] as String,
      nickname: data['nickname'] as String?,
      type: CarType.values.firstWhere(
        (type) => type.name == data['type'],
        orElse: () => CarType.sedan,
      ),
      isDefault: data['isDefault'] as bool? ?? false,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : data['createdAt'] is String
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : data['updatedAt'] is String
          ? DateTime.parse(data['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert model to domain entity
  Car toEntity() {
    return Car(
      id: id,
      make: make,
      model: model,
      year: year,
      color: color,
      licensePlate: licensePlate,
      nickname: nickname,
      type: type,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from domain entity
  factory CarModel.fromEntity(Car car) {
    return CarModel(
      id: car.id,
      make: car.make,
      model: car.model,
      year: car.year,
      color: car.color,
      licensePlate: car.licensePlate,
      nickname: car.nickname,
      type: car.type,
      isDefault: car.isDefault,
      createdAt: car.createdAt,
      updatedAt: car.updatedAt,
    );
  }

  /// Create a copy with updated fields
  CarModel copyWith({
    String? id,
    String? make,
    String? model,
    int? year,
    String? color,
    String? licensePlate,
    String? nickname,
    CarType? type,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarModel(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
      nickname: nickname ?? this.nickname,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Helper functions for DateTime JSON serialization
DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();
