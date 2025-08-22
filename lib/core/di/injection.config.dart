// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/address/data/datasources/address_local_datasource.dart'
    as _i1028;
import '../../features/address/data/repositories/address_repository_impl.dart'
    as _i590;
import '../../features/address/domain/repositories/address_repository.dart'
    as _i463;
import '../../features/address/domain/usecases/add_address_usecase.dart'
    as _i149;
import '../../features/address/domain/usecases/get_addresses_usecase.dart'
    as _i102;
import '../../features/address/domain/usecases/set_default_address_usecase.dart'
    as _i135;
import '../../features/address/presentation/cubit/address_cubit.dart' as _i1056;
import '../../features/authentication/data/datasources/auth_remote_data_source.dart'
    as _i943;
import '../../features/authentication/data/datasources/auth_remote_data_source_impl.dart'
    as _i1068;
import '../../features/authentication/data/repositories/auth_repository_impl.dart'
    as _i317;
import '../../features/authentication/domain/repositories/auth_repository.dart'
    as _i742;
import '../../features/authentication/domain/usecases/enroll_mfa_usecase.dart'
    as _i514;
import '../../features/authentication/domain/usecases/get_auth_state_changes_usecase.dart'
    as _i244;
import '../../features/authentication/domain/usecases/get_current_user_usecase.dart'
    as _i455;
import '../../features/authentication/domain/usecases/send_otp_usecase.dart'
    as _i1072;
import '../../features/authentication/domain/usecases/sign_in_with_email_usecase.dart'
    as _i887;
import '../../features/authentication/domain/usecases/sign_out_usecase.dart'
    as _i749;
import '../../features/authentication/domain/usecases/sign_up_with_email_usecase.dart'
    as _i1050;
import '../../features/authentication/domain/usecases/verify_mfa_usecase.dart'
    as _i348;
import '../../features/authentication/domain/usecases/verify_otp_usecase.dart'
    as _i173;
import '../../features/authentication/presentation/bloc/auth_bloc.dart'
    as _i180;
import '../../features/car/data/datasources/car_local_data_source.dart'
    as _i171;
import '../../features/car/data/datasources/car_local_data_source_impl.dart'
    as _i139;
import '../../features/car/data/repositories/car_repository_impl.dart' as _i746;
import '../../features/car/domain/repositories/car_repository.dart' as _i222;
import '../../features/car/domain/usecases/add_car_usecase.dart' as _i64;
import '../../features/car/domain/usecases/delete_car_usecase.dart' as _i62;
import '../../features/car/domain/usecases/get_cars_usecase.dart' as _i888;
import '../../features/car/domain/usecases/get_default_car_usecase.dart'
    as _i669;
import '../../features/car/domain/usecases/set_default_car_usecase.dart'
    as _i916;
import '../../features/car/domain/usecases/update_car_usecase.dart' as _i554;
import '../../features/car/presentation/cubit/car_cubit.dart' as _i313;
import '../../features/cart/data/datasources/cart_local_datasource.dart'
    as _i339;
import '../../features/cart/data/datasources/cart_local_datasource_impl.dart'
    as _i823;
import '../../features/cart/data/repositories/cart_repository_impl.dart'
    as _i642;
import '../../features/cart/domain/repositories/cart_repository.dart' as _i322;
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart' as _i659;
import '../../features/cart/domain/usecases/clear_cart_usecase.dart' as _i240;
import '../../features/cart/domain/usecases/get_cart_usecase.dart' as _i179;
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart'
    as _i355;
import '../../features/cart/domain/usecases/watch_cart_usecase.dart' as _i352;
import '../../features/cart/presentation/cubit/cart_cubit.dart' as _i499;
import '../../features/dashboard/data/datasources/service_local_datasource.dart'
    as _i183;
import '../../features/dashboard/data/repositories/service_repository_impl.dart'
    as _i579;
import '../../features/dashboard/domain/repositories/service_repository.dart'
    as _i545;
import '../../features/dashboard/domain/usecases/get_services_usecase.dart'
    as _i228;
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i24;
import '../../features/profile/data/datasources/profile_local_datasource.dart'
    as _i1046;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/usecases/get_user_profile_usecase.dart'
    as _i146;
import '../../features/profile/domain/usecases/update_user_profile_usecase.dart'
    as _i103;
import '../services/dynamic_pricing_service.dart' as _i485;
import '../services/location_service.dart' as _i669;
import '../services/vehicle_selection_service.dart' as _i143;
import 'firebase_module.dart' as _i616;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i485.DynamicPricingService>(
      () => _i485.DynamicPricingService(),
    );
    gh.factory<_i669.LocationService>(() => _i669.LocationService());
    gh.singleton<_i143.VehicleSelectionService>(
      () => _i143.VehicleSelectionService(),
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => firebaseModule.firebaseFirestore,
    );
    gh.lazySingleton<_i457.FirebaseStorage>(
      () => firebaseModule.firebaseStorage,
    );
    gh.factory<_i616.StorageService>(
      () => _i616.StorageService(gh<_i457.FirebaseStorage>()),
    );
    gh.factory<_i183.ServiceLocalDataSource>(
      () => _i183.ServiceLocalDataSourceImpl(),
    );
    gh.factory<_i1046.ProfileLocalDataSource>(
      () => _i1046.ProfileLocalDataSourceImpl(),
    );
    gh.factory<_i171.CarLocalDataSource>(() => _i139.CarLocalDataSourceImpl());
    gh.factory<_i1028.AddressLocalDataSource>(
      () => _i1028.AddressLocalDataSourceImpl(),
    );
    gh.factory<_i339.BookingFirestoreDataSource>(
      () => _i823.BookingFirestoreDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
        serviceDataSource: gh<_i183.ServiceLocalDataSource>(),
        carDataSource: gh<_i171.CarLocalDataSource>(),
      ),
    );
    gh.factory<_i339.CartFirestoreDataSource>(
      () => _i823.CartFirestoreDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
        serviceDataSource: gh<_i183.ServiceLocalDataSource>(),
        carDataSource: gh<_i171.CarLocalDataSource>(),
      ),
    );
    gh.factory<_i339.CartLocalDataSource>(
      () => _i823.CartLocalDataSourceImpl(
        serviceDataSource: gh<_i183.ServiceLocalDataSource>(),
        carDataSource: gh<_i171.CarLocalDataSource>(),
      ),
    );
    gh.factory<_i1028.AddressFirestoreDataSource>(
      () =>
          _i1028.AddressFirestoreDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i943.AuthRemoteDataSource>(
      () => _i1068.AuthRemoteDataSourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i339.ReviewFirestoreDataSource>(
      () => _i823.ReviewFirestoreDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i183.ServiceFirestoreDataSource>(
      () => _i183.ServiceFirestoreDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i545.ServiceRepository>(
      () => _i579.ServiceRepositoryImpl(
        gh<_i183.ServiceFirestoreDataSource>(),
        gh<_i183.ServiceLocalDataSource>(),
      ),
    );
    gh.factory<_i1046.ProfileFirestoreDataSource>(
      () =>
          _i1046.ProfileFirestoreDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i742.AuthRepository>(
      () => _i317.AuthRepositoryImpl(gh<_i943.AuthRemoteDataSource>()),
    );
    gh.factory<_i171.CarFirestoreDataSource>(
      () => _i139.CarFirestoreDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(gh<_i1046.ProfileLocalDataSource>()),
    );
    gh.factory<_i322.ReviewRepository>(
      () => _i642.ReviewRepositoryImpl(
        reviewDataSource: gh<_i339.ReviewFirestoreDataSource>(),
      ),
    );
    gh.factory<_i322.CartRepository>(
      () => _i642.CartRepositoryImpl(
        localDataSource: gh<_i339.CartLocalDataSource>(),
        firestoreDataSource: gh<_i339.CartFirestoreDataSource>(),
        firebaseAuth: gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i514.EnrollMfaUseCase>(
      () => _i514.EnrollMfaUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i887.SignInWithEmailUseCase>(
      () => _i887.SignInWithEmailUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i1050.SignUpWithEmailUseCase>(
      () => _i1050.SignUpWithEmailUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i348.VerifyMfaUseCase>(
      () => _i348.VerifyMfaUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i322.BookingRepository>(
      () => _i642.BookingRepositoryImpl(
        bookingDataSource: gh<_i339.BookingFirestoreDataSource>(),
        firebaseAuth: gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i463.AddressRepository>(
      () => _i590.AddressRepositoryImpl(
        gh<_i1028.AddressLocalDataSource>(),
        gh<_i1028.AddressFirestoreDataSource>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i146.GetUserProfileUseCase>(
      () => _i146.GetUserProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i146.CheckProfileCompletionUseCase>(
      () => _i146.CheckProfileCompletionUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i103.UpdateUserProfileUseCase>(
      () => _i103.UpdateUserProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i103.CreateUserProfileUseCase>(
      () => _i103.CreateUserProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i244.GetAuthStateChangesUseCase>(
      () => _i244.GetAuthStateChangesUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i455.GetCurrentUserUseCase>(
      () => _i455.GetCurrentUserUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i1072.SendOtpUseCase>(
      () => _i1072.SendOtpUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i749.SignOutUseCase>(
      () => _i749.SignOutUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i173.VerifyOtpUseCase>(
      () => _i173.VerifyOtpUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i180.AuthBloc>(
      () => _i180.AuthBloc(
        gh<_i1072.SendOtpUseCase>(),
        gh<_i173.VerifyOtpUseCase>(),
        gh<_i749.SignOutUseCase>(),
        gh<_i455.GetCurrentUserUseCase>(),
        gh<_i887.SignInWithEmailUseCase>(),
        gh<_i1050.SignUpWithEmailUseCase>(),
        gh<_i514.EnrollMfaUseCase>(),
        gh<_i348.VerifyMfaUseCase>(),
        gh<_i146.GetUserProfileUseCase>(),
        gh<_i103.CreateUserProfileUseCase>(),
        gh<_i103.UpdateUserProfileUseCase>(),
      ),
    );
    gh.factory<_i228.GetServicesUseCase>(
      () => _i228.GetServicesUseCase(gh<_i545.ServiceRepository>()),
    );
    gh.factory<_i222.CarRepository>(
      () => _i746.CarRepositoryImpl(
        gh<_i171.CarLocalDataSource>(),
        gh<_i171.CarFirestoreDataSource>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i659.AddToCartUseCase>(
      () => _i659.AddToCartUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i240.ClearCartUseCase>(
      () => _i240.ClearCartUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i179.GetCartUseCase>(
      () => _i179.GetCartUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i355.RemoveFromCartUseCase>(
      () => _i355.RemoveFromCartUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i352.WatchCartUseCase>(
      () => _i352.WatchCartUseCase(gh<_i322.CartRepository>()),
    );
    gh.factory<_i659.CreateBookingUseCase>(
      () => _i659.CreateBookingUseCase(
        bookingRepository: gh<_i322.BookingRepository>(),
        cartRepository: gh<_i322.CartRepository>(),
      ),
    );
    gh.factory<_i64.AddCarUseCase>(
      () => _i64.AddCarUseCase(gh<_i222.CarRepository>()),
    );
    gh.factory<_i62.DeleteCarUseCase>(
      () => _i62.DeleteCarUseCase(gh<_i222.CarRepository>()),
    );
    gh.factory<_i888.GetCarsUseCase>(
      () => _i888.GetCarsUseCase(gh<_i222.CarRepository>()),
    );
    gh.factory<_i669.GetDefaultCarUseCase>(
      () => _i669.GetDefaultCarUseCase(gh<_i222.CarRepository>()),
    );
    gh.factory<_i916.SetDefaultCarUseCase>(
      () => _i916.SetDefaultCarUseCase(gh<_i222.CarRepository>()),
    );
    gh.factory<_i554.UpdateCarUseCase>(
      () => _i554.UpdateCarUseCase(gh<_i222.CarRepository>()),
    );
    gh.factory<_i24.DashboardCubit>(
      () => _i24.DashboardCubit(
        getServicesUseCase: gh<_i228.GetServicesUseCase>(),
        bookingRepository: gh<_i322.BookingRepository>(),
        reviewRepository: gh<_i322.ReviewRepository>(),
      ),
    );
    gh.factory<_i149.AddAddressUseCase>(
      () => _i149.AddAddressUseCase(gh<_i463.AddressRepository>()),
    );
    gh.factory<_i102.GetAddressesUseCase>(
      () => _i102.GetAddressesUseCase(gh<_i463.AddressRepository>()),
    );
    gh.factory<_i135.SetDefaultAddressUseCase>(
      () => _i135.SetDefaultAddressUseCase(gh<_i463.AddressRepository>()),
    );
    gh.factory<_i659.CheckoutUseCase>(
      () => _i659.CheckoutUseCase(
        checkProfileUseCase: gh<_i146.CheckProfileCompletionUseCase>(),
        createBookingUseCase: gh<_i659.CreateBookingUseCase>(),
        cartRepository: gh<_i322.CartRepository>(),
      ),
    );
    gh.factory<_i499.CartCubit>(
      () => _i499.CartCubit(
        addToCartUseCase: gh<_i659.AddToCartUseCase>(),
        getCartUseCase: gh<_i179.GetCartUseCase>(),
        removeFromCartUseCase: gh<_i355.RemoveFromCartUseCase>(),
        clearCartUseCase: gh<_i240.ClearCartUseCase>(),
        watchCartUseCase: gh<_i352.WatchCartUseCase>(),
      ),
    );
    gh.factory<_i313.CarCubit>(
      () => _i313.CarCubit(
        gh<_i888.GetCarsUseCase>(),
        gh<_i64.AddCarUseCase>(),
        gh<_i554.UpdateCarUseCase>(),
        gh<_i62.DeleteCarUseCase>(),
        gh<_i916.SetDefaultCarUseCase>(),
      ),
    );
    gh.factory<_i1056.AddressCubit>(
      () => _i1056.AddressCubit(
        getAddressesUseCase: gh<_i102.GetAddressesUseCase>(),
        addAddressUseCase: gh<_i149.AddAddressUseCase>(),
        setDefaultAddressUseCase: gh<_i135.SetDefaultAddressUseCase>(),
        locationService: gh<_i669.LocationService>(),
      ),
    );
    return this;
  }
}

class _$FirebaseModule extends _i616.FirebaseModule {}
