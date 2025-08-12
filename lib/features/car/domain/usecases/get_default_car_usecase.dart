import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/car.dart';
import '../repositories/car_repository.dart';

@injectable
class GetDefaultCarUseCase {
  const GetDefaultCarUseCase(this._repository);

  final CarRepository _repository;

  Future<Either<Failure, Car?>> call() {
    return _repository.getDefaultCar();
  }
}
