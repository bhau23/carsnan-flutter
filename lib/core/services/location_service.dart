import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/errors/failures.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String address;
  final String? area;
  final String? city;
  final String? state;
  final String? postalCode;

  LocationResult({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.area,
    this.city,
    this.state,
    this.postalCode,
  });
}

class LocationService {
  Future<Either<Failure, LocationResult>> getCurrentLocation() async {
    try {
      // Check location permission
      final permission = await Permission.location.request();
      if (permission.isDenied || permission.isPermanentlyDenied) {
        return Left(GeneralFailure('Location permission denied'));
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Left(GeneralFailure('Location services are disabled'));
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Get address from coordinates
      final addressResult = await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return addressResult.fold(
        (failure) => Left(failure),
        (address) => Right(LocationResult(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        )),
      );
    } catch (e) {
      return Left(GeneralFailure('Failed to get current location: ${e.toString()}'));
    }
  }

  Future<Either<Failure, String>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final addressParts = <String>[];

        if (placemark.subThoroughfare?.isNotEmpty == true) {
          addressParts.add(placemark.subThoroughfare!);
        }
        if (placemark.thoroughfare?.isNotEmpty == true) {
          addressParts.add(placemark.thoroughfare!);
        }
        if (placemark.subLocality?.isNotEmpty == true) {
          addressParts.add(placemark.subLocality!);
        }
        if (placemark.locality?.isNotEmpty == true) {
          addressParts.add(placemark.locality!);
        }
        if (placemark.administrativeArea?.isNotEmpty == true) {
          addressParts.add(placemark.administrativeArea!);
        }
        if (placemark.postalCode?.isNotEmpty == true) {
          addressParts.add(placemark.postalCode!);
        }

        return Right(addressParts.join(', '));
      } else {
        return Left(GeneralFailure('No address found for coordinates'));
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to get address: ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<LocationResult>>> searchAddresses(
    String query,
  ) async {
    try {
      if (query.trim().isEmpty) {
        return const Right([]);
      }

      List<Location> locations = await locationFromAddress(query);
      
      List<LocationResult> results = [];
      
      for (Location location in locations.take(5)) { // Limit to 5 results
        final addressResult = await getAddressFromCoordinates(
          location.latitude,
          location.longitude,
        );
        
        addressResult.fold(
          (failure) => null,
          (address) => results.add(LocationResult(
            latitude: location.latitude,
            longitude: location.longitude,
            address: address,
          )),
        );
      }

      return Right(results);
    } catch (e) {
      return Left(GeneralFailure('Failed to search addresses: ${e.toString()}'));
    }
  }
}
