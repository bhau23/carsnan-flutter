import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../features/car/domain/entities/car.dart';

/// Service to manage the currently selected vehicle for live dashboard display
@singleton
class VehicleSelectionService {
  VehicleSelectionService();

  Car? _selectedVehicle;
  final _vehicleController = StreamController<Car?>.broadcast();

  /// Stream of currently selected vehicle
  Stream<Car?> get selectedVehicleStream => _vehicleController.stream;

  /// Get currently selected vehicle
  Car? get selectedVehicle => _selectedVehicle;

  /// Set the currently selected vehicle
  void setSelectedVehicle(Car? vehicle) {
    _selectedVehicle = vehicle;
    _vehicleController.add(vehicle);
  }

  /// Clear the selected vehicle
  void clearSelectedVehicle() {
    _selectedVehicle = null;
    _vehicleController.add(null);
  }

  /// Initialize with default vehicle from car list
  void initializeWithDefault(List<Car> cars) {
    if (cars.isEmpty) {
      clearSelectedVehicle();
      return;
    }

    // Try to find default car first, otherwise use the first car
    final defaultCar = cars.where((car) => car.isDefault).firstOrNull;
    setSelectedVehicle(defaultCar ?? cars.first);
  }

  void dispose() {
    _vehicleController.close();
  }
}
