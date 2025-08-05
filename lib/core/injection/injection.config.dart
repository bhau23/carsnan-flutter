// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

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
import '../di/firebase_module.dart' as _i909;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.factory<_i943.AuthRemoteDataSource>(
      () => _i1068.AuthRemoteDataSourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i742.AuthRepository>(
      () => _i317.AuthRepositoryImpl(gh<_i943.AuthRemoteDataSource>()),
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
      ),
    );
    return this;
  }
}

class _$FirebaseModule extends _i909.FirebaseModule {}
