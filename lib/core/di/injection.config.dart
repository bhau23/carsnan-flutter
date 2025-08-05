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
    gh.factory<_i545.AuthRemoteDataSource>(
      () => _i127.AuthRemoteDataSourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i917.AuthRepository>(
      () => _i329.AuthRepositoryImpl(gh<_i545.AuthRemoteDataSource>()),
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
    return this;
  }
}

class _$FirebaseModule extends _i1061.FirebaseModule {}
