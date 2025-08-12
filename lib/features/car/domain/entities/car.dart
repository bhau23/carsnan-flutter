import 'package:equatable/equatable.dart';

/// Represents a user's car with all necessary details
class Car extends Equatable {
  const Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    required this.type,
    this.nickname,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique identifier for the car
  final String id;

  /// Car manufacturer (e.g., Toyota, Honda, BMW)
  final String make;

  /// Car model (e.g., Camry, Accord, X5)
  final String model;

  /// Manufacturing year
  final int year;

  /// Car color
  final String color;

  /// License plate number
  final String licensePlate;

  /// Optional user-friendly name for the car
  final String? nickname;

  /// Type of vehicle (affects pricing)
  final CarType type;

  /// Whether this is the user's default car
  final bool isDefault;

  /// When the car was added to the system
  final DateTime createdAt;

  /// When the car was last updated
  final DateTime updatedAt;

  /// Get display name (nickname or make + model)
  String get displayName => nickname ?? '$make $model';

  /// Get full car description
  String get fullDescription => '$year $make $model ($color)';

  /// Copy car with updated fields
  Car copyWith({
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
    return Car(
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

  @override
  List<Object?> get props => [
    id,
    make,
    model,
    year,
    color,
    licensePlate,
    nickname,
    type,
    isDefault,
    createdAt,
    updatedAt,
  ];
}

/// Enum for different car types with pricing information
enum CarType {
  /// Standard sedan cars (base pricing)
  sedan(
    displayName: 'Sedan',
    priceMultiplier: 1.0,
    icon: '🚗',
    description: 'Perfect for standard car wash services',
  ),

  /// Sport Utility Vehicles (20% premium)
  suv(
    displayName: 'SUV',
    priceMultiplier: 1.2,
    icon: '🚙',
    description: 'Larger vehicles require more attention',
  ),

  /// Compact/Mini cars (20% discount)
  mini(
    displayName: 'Mini',
    priceMultiplier: 0.8,
    icon: '🚕',
    description: 'Smaller vehicles, lower pricing',
  );

  const CarType({
    required this.displayName,
    required this.priceMultiplier,
    required this.icon,
    required this.description,
  });

  /// Human-readable name
  final String displayName;

  /// Price multiplier for services
  final double priceMultiplier;

  /// Icon representation
  final String icon;

  /// Description of the car type
  final String description;

  /// Calculate service price based on base price
  double calculatePrice(double basePrice) {
    return basePrice * priceMultiplier;
  }
}
