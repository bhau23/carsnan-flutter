import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/address.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/add_address_usecase.dart';
import '../../domain/usecases/set_default_address_usecase.dart';
import '../../../../core/services/location_service.dart';
import 'address_state.dart';

@injectable
class AddressCubit extends Cubit<AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;
  final LocationService locationService;

  AddressCubit({
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.setDefaultAddressUseCase,
    required this.locationService,
  }) : super(const AddressInitial());

  /// Load all addresses
  Future<void> loadAddresses() async {
    emit(const AddressLoading());

    final result = await getAddressesUseCase();

    result.fold((failure) => emit(AddressError(failure.message)), (addresses) {
      final defaultAddress = addresses.isEmpty
          ? null
          : addresses.firstWhere(
              (addr) => addr.isDefault,
              orElse: () => addresses.first,
            );
      emit(AddressLoaded(addresses: addresses, defaultAddress: defaultAddress));
    });
  }

  /// Get current location
  Future<void> getCurrentLocation() async {
    emit(const LocationLoading());

    final result = await locationService.getCurrentLocation();

    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (location) => emit(LocationLoaded(location: location)),
    );
  }

  /// Search for addresses
  Future<void> searchAddresses(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchResults(results: [], query: ''));
      return;
    }

    emit(const AddressLoading());

    final result = await locationService.searchAddresses(query);

    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (results) => emit(SearchResults(results: results, query: query)),
    );
  }

  /// Add new address
  Future<void> addAddress(Address address) async {
    emit(const AddingAddress());

    final result = await addAddressUseCase(address);

    result.fold((failure) => emit(AddressError(failure.message)), (
      savedAddress,
    ) async {
      // Directly reload addresses instead of emitting AddressAdded
      await loadAddresses();
    });
  }

  /// Set default address
  Future<void> setDefaultAddress(String addressId) async {
    emit(const AddressLoading());

    final result = await setDefaultAddressUseCase(addressId);

    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => loadAddresses(), // Reload to update default status
    );
  }

  /// Clear states and go back to initial
  void clearState() {
    emit(const AddressInitial());
  }

  /// Go back to loaded state if we have addresses
  void backToAddresses() {
    if (state is AddressLoaded) {
      return; // Already in loaded state
    }
    loadAddresses();
  }
}
