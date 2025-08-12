import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/car.dart';
import '../repositories/car_repository.dart';

@injectable
class AddCarUseCase {
  const AddCarUseCase(this._repository);

  final CarRepository _repository;

  Future<Either<Failure, Car>> call(Car car) {
    return _repository.addCar(car);
  }
}
