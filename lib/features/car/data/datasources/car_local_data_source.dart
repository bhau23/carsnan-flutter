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

/// Abstract data source for car data from Firestore
abstract class CarFirestoreDataSource {
  /// Get all cars for the current user from Firestore
  Future<List<CarModel>> getCars(String userId);

  /// Add a new car to Firestore
  Future<CarModel> addCar(String userId, CarModel car);

  /// Update an existing car in Firestore
  Future<CarModel> updateCar(String userId, CarModel car);

  /// Delete a car by ID from Firestore
  Future<void> deleteCar(String userId, String carId);

  /// Set a car as default (unsets others) in Firestore
  Future<void> setDefaultCar(String userId, String carId);

  /// Get the default car from Firestore
  Future<CarModel?> getDefaultCar(String userId);

  /// Get a specific car by ID from Firestore
  Future<CarModel?> getCarById(String userId, String carId);
}
