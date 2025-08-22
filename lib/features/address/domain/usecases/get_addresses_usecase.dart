import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

@injectable
class GetAddressesUseCase {
  final AddressRepository repository;

  GetAddressesUseCase(this.repository);

  Future<Either<Failure, List<Address>>> call() {
    return repository.getAddresses();
  }
}
