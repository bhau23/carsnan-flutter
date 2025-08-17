import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/car.dart';
import '../../domain/usecases/add_car_usecase.dart';
import '../../domain/usecases/delete_car_usecase.dart';
import '../../domain/usecases/get_cars_usecase.dart';
import '../../domain/usecases/set_default_car_usecase.dart';
import '../../domain/usecases/update_car_usecase.dart';
import 'car_state.dart';

@injectable
class CarCubit extends Cubit<CarState> {
  CarCubit(
    this._getCarsUseCase,
    this._addCarUseCase,
    this._updateCarUseCase,
    this._deleteCarUseCase,
    this._setDefaultCarUseCase,
  ) : super(const CarInitial());

  final GetCarsUseCase _getCarsUseCase;
  final AddCarUseCase _addCarUseCase;
  final UpdateCarUseCase _updateCarUseCase;
  final DeleteCarUseCase _deleteCarUseCase;
  final SetDefaultCarUseCase _setDefaultCarUseCase;

  /// Load all cars
  Future<void> loadCars() async {
    emit(const CarLoading());

    final result = await _getCarsUseCase();

    result.fold(
      (failure) => emit(CarError(message: failure.message)),
      (cars) => emit(CarLoaded(cars: cars)),
    );
  }

  /// Add a new car
  Future<void> addCar(Car car) async {
    emit(const CarLoading());

    final result = await _addCarUseCase(car);

    result.fold(
      (failure) => emit(CarError(message: failure.message)),
      (addedCar) => _refreshCarList(),
    );
  }

  /// Update an existing car
  Future<void> updateCar(Car car) async {
    emit(const CarLoading());

    final result = await _updateCarUseCase(car);

    result.fold(
      (failure) => emit(CarError(message: failure.message)),
      (updatedCar) => _refreshCarList(),
    );
  }

  /// Delete a car
  Future<void> deleteCar(String carId) async {
    emit(const CarLoading());

    final result = await _deleteCarUseCase(carId);

    result.fold(
      (failure) => emit(CarError(message: failure.message)),
      (_) => _refreshCarList(),
    );
  }

  /// Set a car as default
  Future<void> setDefaultCar(String carId) async {
    final result = await _setDefaultCarUseCase(carId);

    result.fold(
      (failure) => emit(CarError(message: failure.message)),
      (_) => _refreshCarList(),
    );
  }

  /// Refresh the car list
  Future<void> _refreshCarList() async {
    final result = await _getCarsUseCase();

    result.fold(
      (failure) => emit(CarError(message: failure.message)),
      (cars) => emit(CarLoaded(cars: cars)),
    );
  }

  /// Get current cars from state
  List<Car> get cars {
    if (state is CarLoaded) {
      return (state as CarLoaded).cars;
    }
    return [];
  }
}
