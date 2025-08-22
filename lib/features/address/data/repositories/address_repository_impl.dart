import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_local_datasource.dart';
import '../models/address_model.dart';

@Injectable(as: AddressRepository)
class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl(
    this._localDataSource,
    this._firestoreDataSource,
    this._firebaseAuth,
  );

  final AddressLocalDataSource _localDataSource;
  final AddressFirestoreDataSource _firestoreDataSource;
  final FirebaseAuth _firebaseAuth;

  /// Get current user ID or null if not authenticated
  String? get _currentUserId => _firebaseAuth.currentUser?.uid;

  /// Use Firestore if user is authenticated, otherwise use local storage
  bool get _useFirestore => _currentUserId != null;

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      if (_useFirestore) {
        final addressModels = await _firestoreDataSource.getAddresses(
          _currentUserId!,
        );
        final addresses = addressModels
            .map((model) => model as Address)
            .toList();
        return Right(addresses);
      } else {
        final addressModels = await _localDataSource.getAddresses();
        final addresses = addressModels
            .map((model) => model as Address)
            .toList();
        return Right(addresses);
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to get addresses: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Address>> getDefaultAddress() async {
    try {
      AddressModel? addressModel;

      if (_useFirestore) {
        addressModel = await _firestoreDataSource.getDefaultAddress(
          _currentUserId!,
        );
      } else {
        addressModel = await _localDataSource.getDefaultAddress();
      }

      if (addressModel != null) {
        return Right(addressModel);
      } else {
        return Left(GeneralFailure('No default address found'));
      }
    } catch (e) {
      return Left(
        GeneralFailure('Failed to get default address: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(Address address) async {
    try {
      final addressModel = AddressModel.fromDomain(address);

      if (_useFirestore) {
        final addedAddressModel = await _firestoreDataSource.addAddress(
          _currentUserId!,
          addressModel,
        );
        return Right(addedAddressModel);
      } else {
        await _localDataSource.saveAddress(addressModel);
        return Right(address);
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to add address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress(Address address) async {
    try {
      final addressModel = AddressModel.fromDomain(address);

      if (_useFirestore) {
        final updatedAddressModel = await _firestoreDataSource.updateAddress(
          _currentUserId!,
          addressModel,
        );
        return Right(updatedAddressModel);
      } else {
        await _localDataSource.updateAddress(addressModel);
        return Right(address);
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to update address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      if (_useFirestore) {
        await _firestoreDataSource.deleteAddress(_currentUserId!, addressId);
      } else {
        await _localDataSource.deleteAddress(addressId);
      }
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure('Failed to delete address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String addressId) async {
    try {
      if (_useFirestore) {
        await _firestoreDataSource.setDefaultAddress(
          _currentUserId!,
          addressId,
        );
      } else {
        await _localDataSource.setDefaultAddress(addressId);
      }
      return const Right(null);
    } catch (e) {
      return Left(
        GeneralFailure('Failed to set default address: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Address?>> getAddressByCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<AddressModel> addresses;

      if (_useFirestore) {
        addresses = await _firestoreDataSource.getAddresses(_currentUserId!);
      } else {
        addresses = await _localDataSource.getAddresses();
      }

      // Find address within 100 meters radius
      for (final address in addresses) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          address.latitude,
          address.longitude,
        );

        if (distance <= 0.1) {
          // 100 meters
          return Right(address);
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(
        GeneralFailure('Failed to get address by coordinates: ${e.toString()}'),
      );
    }
  }

  // Simple distance calculation (Haversine formula approximation)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        (dLat / 2).abs() * (dLat / 2).abs() +
        (lat1 * 3.14159 / 180).abs() *
            (lat2 * 3.14159 / 180).abs() *
            (dLon / 2).abs() *
            (dLon / 2).abs();

    final double c = 2 * (a.abs().clamp(0.0, 1.0));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * 3.14159 / 180;
  }
}
