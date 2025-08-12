// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:carsnan/core/di/firebase_module.dart' as _i1061;
import 'package:carsnan/features/authentication/data/datasources/auth_remote_data_source.dart'
    as _i545;
import 'package:carsnan/features/authentication/data/datasources/auth_remote_data_source_impl.dart'
    as _i127;
import 'package:carsnan/features/authentication/data/repositories/auth_repository_impl.dart'
    as _i329;
import 'package:carsnan/features/authentication/domain/repositories/auth_repository.dart'
    as _i917;
import 'package:carsnan/features/authentication/domain/usecases/enroll_mfa_usecase.dart'
    as _i147;
import 'package:carsnan/features/authentication/domain/usecases/get_auth_state_changes_usecase.dart'
    as _i917;
import 'package:carsnan/features/authentication/domain/usecases/get_current_user_usecase.dart'
    as _i214;
import 'package:carsnan/features/authentication/domain/usecases/send_otp_usecase.dart'
    as _i1065;
import 'package:carsnan/features/authentication/domain/usecases/sign_in_with_email_usecase.dart'
    as _i674;
import 'package:carsnan/features/authentication/domain/usecases/sign_out_usecase.dart'
    as _i430;
import 'package:carsnan/features/authentication/domain/usecases/sign_up_with_email_usecase.dart'
    as _i297;
import 'package:carsnan/features/authentication/domain/usecases/verify_mfa_usecase.dart'
    as _i805;
import 'package:carsnan/features/authentication/domain/usecases/verify_otp_usecase.dart'
    as _i136;
import 'package:carsnan/features/authentication/presentation/bloc/auth_bloc.dart'
    as _i945;
import 'package:carsnan/features/car/data/datasources/car_local_data_source.dart'
    as _i643;
import 'package:carsnan/features/car/data/datasources/car_local_data_source_impl.dart'
    as _i533;
import 'package:carsnan/features/car/data/repositories/car_repository_impl.dart'
    as _i121;
import 'package:carsnan/features/car/domain/repositories/car_repository.dart'
    as _i893;
import 'package:carsnan/features/car/domain/usecases/add_car_usecase.dart'
    as _i581;
import 'package:carsnan/features/car/domain/usecases/delete_car_usecase.dart'
    as _i51;
import 'package:carsnan/features/car/domain/usecases/get_cars_usecase.dart'
    as _i375;
import 'package:carsnan/features/car/domain/usecases/get_default_car_usecase.dart'
    as _i145;
import 'package:carsnan/features/car/domain/usecases/set_default_car_usecase.dart'
    as _i400;
import 'package:carsnan/features/car/domain/usecases/update_car_usecase.dart'
    as _i13;
import 'package:carsnan/features/car/presentation/cubit/car_cubit.dart'
    as _i745;
import 'package:carsnan/features/cart/data/datasources/cart_local_datasource.dart'
    as _i972;
import 'package:carsnan/features/cart/data/datasources/cart_local_datasource_impl.dart'
    as _i101;
import 'package:carsnan/features/cart/data/repositories/cart_repository_impl.dart'
    as _i355;
import 'package:carsnan/features/cart/domain/repositories/cart_repository.dart'
    as _i772;
import 'package:carsnan/features/cart/domain/usecases/add_to_cart_usecase.dart'
    as _i467;
import 'package:carsnan/features/cart/domain/usecases/clear_cart_usecase.dart'
    as _i494;
import 'package:carsnan/features/cart/domain/usecases/get_cart_usecase.dart'
    as _i260;
import 'package:carsnan/features/cart/domain/usecases/remove_from_cart_usecase.dart'
    as _i964;
import 'package:carsnan/features/cart/domain/usecases/watch_cart_usecase.dart'
    as _i753;
import 'package:carsnan/features/cart/presentation/cubit/cart_cubit.dart'
    as _i305;
import 'package:carsnan/features/dashboard/data/datasources/service_local_datasource.dart'
    as _i1009;
import 'package:carsnan/features/profile/data/datasources/profile_local_datasource.dart'
    as _i1010;
import 'package:carsnan/features/profile/data/repositories/profile_repository_impl.dart'
    as _i554;
import 'package:carsnan/features/profile/domain/repositories/profile_repository.dart'
    as _i956;
import 'package:carsnan/features/profile/domain/usecases/get_user_profile_usecase.dart'
    as _i107;
import 'package:carsnan/features/profile/domain/usecases/update_user_profile_usecase.dart'
    as _i734;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.factory<_i1009.ServiceLocalDataSource>(
      () => _i1009.ServiceLocalDataSourceImpl(),
    );
    gh.factory<_i1010.ProfileLocalDataSource>(
      () => _i1010.ProfileLocalDataSourceImpl(),
    );
    gh.factory<_i643.CarLocalDataSource>(() => _i533.CarLocalDataSourceImpl());
    gh.factory<_i893.CarRepository>(
      () => _i121.CarRepositoryImpl(gh<_i643.CarLocalDataSource>()),
    );
    gh.factory<_i972.CartLocalDataSource>(
      () => _i101.CartLocalDataSourceImpl(
        serviceDataSource: gh<_i1009.ServiceLocalDataSource>(),
        carDataSource: gh<_i643.CarLocalDataSource>(),
      ),
    );
    gh.factory<_i545.AuthRemoteDataSource>(
      () => _i127.AuthRemoteDataSourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i917.AuthRepository>(
      () => _i329.AuthRepositoryImpl(gh<_i545.AuthRemoteDataSource>()),
    );
    gh.factory<_i956.ProfileRepository>(
      () => _i554.ProfileRepositoryImpl(gh<_i1010.ProfileLocalDataSource>()),
    );
    gh.factory<_i581.AddCarUseCase>(
      () => _i581.AddCarUseCase(gh<_i893.CarRepository>()),
    );
    gh.factory<_i51.DeleteCarUseCase>(
      () => _i51.DeleteCarUseCase(gh<_i893.CarRepository>()),
    );
    gh.factory<_i375.GetCarsUseCase>(
      () => _i375.GetCarsUseCase(gh<_i893.CarRepository>()),
    );
    gh.factory<_i145.GetDefaultCarUseCase>(
      () => _i145.GetDefaultCarUseCase(gh<_i893.CarRepository>()),
    );
    gh.factory<_i400.SetDefaultCarUseCase>(
      () => _i400.SetDefaultCarUseCase(gh<_i893.CarRepository>()),
    );
    gh.factory<_i13.UpdateCarUseCase>(
      () => _i13.UpdateCarUseCase(gh<_i893.CarRepository>()),
    );
    gh.factory<_i147.EnrollMfaUseCase>(
      () => _i147.EnrollMfaUseCase(gh<_i917.AuthRepository>()),
    );
    gh.factory<_i674.SignInWithEmailUseCase>(
      () => _i674.SignInWithEmailUseCase(gh<_i917.AuthRepository>()),
    );
    gh.factory<_i297.SignUpWithEmailUseCase>(
      () => _i297.SignUpWithEmailUseCase(gh<_i917.AuthRepository>()),
    );
    gh.factory<_i805.VerifyMfaUseCase>(
      () => _i805.VerifyMfaUseCase(gh<_i917.AuthRepository>()),
    );
    gh.factory<_i107.GetUserProfileUseCase>(
      () => _i107.GetUserProfileUseCase(gh<_i956.ProfileRepository>()),
    );
    gh.factory<_i734.UpdateUserProfileUseCase>(
      () => _i734.UpdateUserProfileUseCase(gh<_i956.ProfileRepository>()),
    );
    gh.factory<_i917.GetAuthStateChangesUseCase>(
      () => _i917.GetAuthStateChangesUseCase(gh<_i917.AuthRepository>()),
    );
    gh.factory<_i214.GetCurrentUserUseCase>(
      () => _i214.GetCurrentUserUseCase(gh<_i917.AuthRepository>()),
    );
    gh.factory<_i1065.SendOtpUseCase>(
      () => _i1065.SendOtpUseCase(gh<_i917.AuthRepository>()),
    );
    gh.factory<_i430.SignOutUseCase>(
      () => _i430.SignOutUseCase(gh<_i917.AuthRepository>()),
    );
    gh.factory<_i136.VerifyOtpUseCase>(
      () => _i136.VerifyOtpUseCase(gh<_i917.AuthRepository>()),
    );
    gh.factory<_i772.CartRepository>(
      () =>
          _i355.CartRepositoryImpl(dataSource: gh<_i972.CartLocalDataSource>()),
    );
    gh.factory<_i945.AuthBloc>(
      () => _i945.AuthBloc(
        gh<_i1065.SendOtpUseCase>(),
        gh<_i136.VerifyOtpUseCase>(),
        gh<_i430.SignOutUseCase>(),
        gh<_i214.GetCurrentUserUseCase>(),
        gh<_i674.SignInWithEmailUseCase>(),
        gh<_i297.SignUpWithEmailUseCase>(),
        gh<_i147.EnrollMfaUseCase>(),
        gh<_i805.VerifyMfaUseCase>(),
      ),
    );
    gh.factory<_i745.CarCubit>(
      () => _i745.CarCubit(
        gh<_i375.GetCarsUseCase>(),
        gh<_i581.AddCarUseCase>(),
        gh<_i13.UpdateCarUseCase>(),
        gh<_i51.DeleteCarUseCase>(),
        gh<_i400.SetDefaultCarUseCase>(),
      ),
    );
    gh.factory<_i467.AddToCartUseCase>(
      () => _i467.AddToCartUseCase(gh<_i772.CartRepository>()),
    );
    gh.factory<_i494.ClearCartUseCase>(
      () => _i494.ClearCartUseCase(gh<_i772.CartRepository>()),
    );
    gh.factory<_i260.GetCartUseCase>(
      () => _i260.GetCartUseCase(gh<_i772.CartRepository>()),
    );
    gh.factory<_i964.RemoveFromCartUseCase>(
      () => _i964.RemoveFromCartUseCase(gh<_i772.CartRepository>()),
    );
    gh.factory<_i753.WatchCartUseCase>(
      () => _i753.WatchCartUseCase(gh<_i772.CartRepository>()),
    );
    gh.factory<_i305.CartCubit>(
      () => _i305.CartCubit(
        addToCartUseCase: gh<_i467.AddToCartUseCase>(),
        getCartUseCase: gh<_i260.GetCartUseCase>(),
        removeFromCartUseCase: gh<_i964.RemoveFromCartUseCase>(),
        clearCartUseCase: gh<_i494.ClearCartUseCase>(),
        watchCartUseCase: gh<_i753.WatchCartUseCase>(),
      ),
    );
    return this;
  }
}

class _$FirebaseModule extends _i1061.FirebaseModule {}
