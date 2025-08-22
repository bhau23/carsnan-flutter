import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/car_local_data_source.dart';
import '../models/car_model.dart';

@Injectable(as: CarRepository)
class CarRepositoryImpl implements CarRepository {
  const CarRepositoryImpl(
    this._localDataSource,
    this._firestoreDataSource,
    this._firebaseAuth,
  );

  final CarLocalDataSource _localDataSource;
  final CarFirestoreDataSource _firestoreDataSource;
  final FirebaseAuth _firebaseAuth;

  /// Get current user ID or null if not authenticated
  String? get _currentUserId => _firebaseAuth.currentUser?.uid;

  /// Use Firestore if user is authenticated, otherwise use local storage
  bool get _useFirestore => _currentUserId != null;

  @override
  Future<Either<Failure, List<Car>>> getCars() async {
    try {
      if (_useFirestore) {
        final carModels = await _firestoreDataSource.getCars(_currentUserId!);
        final cars = carModels.map((model) => model.toEntity()).toList();
        return Right(cars);
      } else {
        final carModels = await _localDataSource.getCars();
        final cars = carModels.map((model) => model.toEntity()).toList();
        return Right(cars);
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Car>> addCar(Car car) async {
    try {
      final carModel = CarModel.fromEntity(car);

      if (_useFirestore) {
        final addedCarModel = await _firestoreDataSource.addCar(
          _currentUserId!,
          carModel,
        );
        return Right(addedCarModel.toEntity());
      } else {
        final addedCarModel = await _localDataSource.addCar(carModel);
        return Right(addedCarModel.toEntity());
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Car>> updateCar(Car car) async {
    try {
      final carModel = CarModel.fromEntity(car);

      if (_useFirestore) {
        final updatedCarModel = await _firestoreDataSource.updateCar(
          _currentUserId!,
          carModel,
        );
        return Right(updatedCarModel.toEntity());
      } else {
        final updatedCarModel = await _localDataSource.updateCar(carModel);
        return Right(updatedCarModel.toEntity());
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCar(String carId) async {
    try {
      if (_useFirestore) {
        await _firestoreDataSource.deleteCar(_currentUserId!, carId);
      } else {
        await _localDataSource.deleteCar(carId);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultCar(String carId) async {
    try {
      if (_useFirestore) {
        await _firestoreDataSource.setDefaultCar(_currentUserId!, carId);
      } else {
        await _localDataSource.setDefaultCar(carId);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Car?>> getDefaultCar() async {
    try {
      CarModel? carModel;

      if (_useFirestore) {
        carModel = await _firestoreDataSource.getDefaultCar(_currentUserId!);
      } else {
        carModel = await _localDataSource.getDefaultCar();
      }

      return Right(carModel?.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Car?>> getCarById(String carId) async {
    try {
      CarModel? carModel;

      if (_useFirestore) {
        carModel = await _firestoreDataSource.getCarById(
          _currentUserId!,
          carId,
        );
      } else {
        carModel = await _localDataSource.getCarById(carId);
      }

      return Right(carModel?.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
