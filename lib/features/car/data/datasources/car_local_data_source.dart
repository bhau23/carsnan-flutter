import '../models/car_model.dart';

/// Abstract data source for car data
abstract class CarLocalDataSource {
  /// Get all cars for the current user
  Future<List<CarModel>> getCars();

  /// Add a new car
  Future<CarModel> addCar(CarModel car);

  /// Update an existing car
  Future<CarModel> updateCar(CarModel car);

  /// Delete a car by ID
  Future<void> deleteCar(String carId);

  /// Set a car as default (unsets others)
  Future<void> setDefaultCar(String carId);

  /// Get the default car
  Future<CarModel?> getDefaultCar();

  /// Get a specific car by ID
  Future<CarModel?> getCarById(String carId);
}
