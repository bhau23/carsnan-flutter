import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/car_repository.dart';

@injectable
class DeleteCarUseCase {
  const DeleteCarUseCase(this._repository);

  final CarRepository _repository;

  Future<Either<Failure, void>> call(String carId) {
    return _repository.deleteCar(carId);
  }
}
