import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/car.dart';

/// Abstract repository for car data operations
abstract class CarRepository {
  /// Get all cars for the current user
  Future<Either<Failure, List<Car>>> getCars();

  /// Add a new car
  Future<Either<Failure, Car>> addCar(Car car);

  /// Update an existing car
  Future<Either<Failure, Car>> updateCar(Car car);

  /// Delete a car by ID
  Future<Either<Failure, void>> deleteCar(String carId);

  /// Set a car as default (unsets others)
  Future<Either<Failure, void>> setDefaultCar(String carId);

  /// Get the default car
  Future<Either<Failure, Car?>> getDefaultCar();

  /// Get a specific car by ID
  Future<Either<Failure, Car?>> getCarById(String carId);
}
