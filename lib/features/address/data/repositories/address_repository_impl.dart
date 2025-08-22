import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_local_datasource.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressLocalDataSource localDataSource;

  AddressRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final addresses = await localDataSource.getAddresses();
      return Right(addresses.map((model) => model as Address).toList());
    } catch (e) {
      return Left(GeneralFailure('Failed to get addresses: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Address>> getDefaultAddress() async {
    try {
      final address = await localDataSource.getDefaultAddress();
      if (address != null) {
        return Right(address);
      } else {
        return Left(GeneralFailure('No default address found'));
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to get default address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(Address address) async {
    try {
      final addressModel = AddressModel.fromDomain(address);
      await localDataSource.saveAddress(addressModel);
      return Right(address);
    } catch (e) {
      return Left(GeneralFailure('Failed to add address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress(Address address) async {
    try {
      final addressModel = AddressModel.fromDomain(address);
      await localDataSource.updateAddress(addressModel);
      return Right(address);
    } catch (e) {
      return Left(GeneralFailure('Failed to update address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      await localDataSource.deleteAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure('Failed to delete address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String addressId) async {
    try {
      await localDataSource.setDefaultAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure('Failed to set default address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Address?>> getAddressByCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final addresses = await localDataSource.getAddresses();
      
      // Find address within 100 meters radius
      for (final address in addresses) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          address.latitude,
          address.longitude,
        );
        
        if (distance <= 0.1) { // 100 meters
          return Right(address);
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure('Failed to get address by coordinates: ${e.toString()}'));
    }
  }

  // Simple distance calculation (Haversine formula approximation)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth radius in kilometers
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = 
        (dLat / 2).abs() * (dLat / 2).abs() +
        (lat1 * 3.14159 / 180).abs() * (lat2 * 3.14159 / 180).abs() *
        (dLon / 2).abs() * (dLon / 2).abs();
    
    final double c = 2 * (a.abs().clamp(0.0, 1.0));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * 3.14159 / 180;
  }
}
