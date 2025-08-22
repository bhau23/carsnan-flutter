import 'package:equatable/equatable.dart';
import '../../domain/entities/address.dart';
import '../../../../core/services/location_service.dart';

abstract class AddressState extends Equatable {
  const AddressState();
  
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {
  const AddressInitial();
}

class AddressLoading extends AddressState {
  const AddressLoading();
}

class AddressLoaded extends AddressState {
  final List<Address> addresses;
  final Address? defaultAddress;
  
  const AddressLoaded({
    required this.addresses,
    this.defaultAddress,
  });
  
  @override
  List<Object?> get props => [addresses, defaultAddress];
}

class AddressError extends AddressState {
  final String message;
  
  const AddressError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Add address flow states
class LocationLoading extends AddressState {
  const LocationLoading();
}

class LocationLoaded extends AddressState {
  final LocationResult location;
  
  const LocationLoaded({required this.location});
  
  @override
  List<Object?> get props => [location];
}

class SearchResults extends AddressState {
  final List<LocationResult> results;
  final String query;
  
  const SearchResults({
    required this.results,
    required this.query,
  });
  
  @override
  List<Object?> get props => [results, query];
}

class AddingAddress extends AddressState {
  const AddingAddress();
}

class AddressAdded extends AddressState {
  final Address address;
  
  const AddressAdded(this.address);
  
  @override
  List<Object?> get props => [address];
}
