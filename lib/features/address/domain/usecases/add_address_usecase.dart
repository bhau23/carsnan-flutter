import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

@injectable
class AddAddressUseCase {
  final AddressRepository repository;

  AddAddressUseCase(this.repository);

  Future<Either<Failure, Address>> call(Address address) {
    return repository.addAddress(address);
  }
}
