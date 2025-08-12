import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/car_local_data_source.dart';
import '../models/car_model.dart';

@Injectable(as: CarRepository)
class CarRepositoryImpl implements CarRepository {
  const CarRepositoryImpl(this._localDataSource);

  final CarLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<Car>>> getCars() async {
    try {
      final carModels = await _localDataSource.getCars();
      final cars = carModels.map((model) => model.toEntity()).toList();
      return Right(cars);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Car>> addCar(Car car) async {
    try {
      final carModel = CarModel.fromEntity(car);
      final addedCarModel = await _localDataSource.addCar(carModel);
      return Right(addedCarModel.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Car>> updateCar(Car car) async {
    try {
      final carModel = CarModel.fromEntity(car);
      final updatedCarModel = await _localDataSource.updateCar(carModel);
      return Right(updatedCarModel.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCar(String carId) async {
    try {
      await _localDataSource.deleteCar(carId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultCar(String carId) async {
    try {
      await _localDataSource.setDefaultCar(carId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Car?>> getDefaultCar() async {
    try {
      final carModel = await _localDataSource.getDefaultCar();
      return Right(carModel?.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Car?>> getCarById(String carId) async {
    try {
      final carModel = await _localDataSource.getCarById(carId);
      return Right(carModel?.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
