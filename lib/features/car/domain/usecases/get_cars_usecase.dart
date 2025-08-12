import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/car.dart';
import '../repositories/car_repository.dart';

@injectable
class GetCarsUseCase {
  const GetCarsUseCase(this._repository);

  final CarRepository _repository;

  Future<Either<Failure, List<Car>>> call() {
    return _repository.getCars();
  }
}
