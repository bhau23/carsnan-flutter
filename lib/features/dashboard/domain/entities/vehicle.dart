class Vehicle {
  final String id;
  final String make;
  final String model;
  final int year;
  final String color;
  final String licensePlate;
  final VehicleType type;
  final bool isDefault;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    required this.type,
    this.isDefault = false,
  });
}

enum VehicleType { car, truck, suv, motorcycle, van }
