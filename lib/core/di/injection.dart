import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Address feature imports
import '../../features/address/data/datasources/address_local_datasource.dart';
import '../../features/address/data/repositories/address_repository_impl.dart';
import '../../features/address/domain/repositories/address_repository.dart';
import '../../features/address/domain/usecases/get_addresses_usecase.dart';
import '../../features/address/domain/usecases/add_address_usecase.dart';
import '../../features/address/domain/usecases/set_default_address_usecase.dart';
import '../../features/address/presentation/cubit/address_cubit.dart';
import '../services/location_service.dart';
import '../services/vehicle_selection_service.dart';
import '../services/dynamic_pricing_service.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();
  _setupAddressDependencies();
  _setupVehicleServices();
}

void _setupVehicleServices() {
  // Register vehicle selection and pricing services
  getIt.registerSingleton<VehicleSelectionService>(
    VehicleSelectionService(),
  );

  getIt.registerLazySingleton<DynamicPricingService>(
    () => DynamicPricingService(),
  );
}

void _setupAddressDependencies() {
  // Register address dependencies
  getIt.registerLazySingleton<AddressLocalDataSource>(
    () => AddressLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<LocationService>(
    () => LocationService(),
  );

  getIt.registerLazySingleton<GetAddressesUseCase>(
    () => GetAddressesUseCase(getIt()),
  );

  getIt.registerLazySingleton<AddAddressUseCase>(
    () => AddAddressUseCase(getIt()),
  );

  getIt.registerLazySingleton<SetDefaultAddressUseCase>(
    () => SetDefaultAddressUseCase(getIt()),
  );

  getIt.registerFactory<AddressCubit>(
    () => AddressCubit(
      getAddressesUseCase: getIt(),
      addAddressUseCase: getIt(),
      setDefaultAddressUseCase: getIt(),
      locationService: getIt(),
    ),
  );
}
