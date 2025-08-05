import 'package:carsnan/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/dashboard/data/datasources/service_local_datasource.dart';
import '../features/dashboard/data/repositories/service_repository_impl.dart';
import '../features/dashboard/domain/usecases/get_services_usecase.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ServiceLocalDataSourceImpl>(
          create: (context) => ServiceLocalDataSourceImpl(),
        ),
        RepositoryProvider<ServiceRepositoryImpl>(
          create: (context) =>
              ServiceRepositoryImpl(context.read<ServiceLocalDataSourceImpl>()),
        ),
        RepositoryProvider<GetServicesUseCase>(
          create: (context) =>
              GetServicesUseCase(context.read<ServiceRepositoryImpl>()),
        ),
      ],
      child: BlocProvider(
        create: (context) => getIt<AuthBloc>()..add(const CheckAuthStatus()),
        child: Builder(
          builder: (context) {
            final router = AppRouter(authBloc: context.read<AuthBloc>()).router;
            return MaterialApp.router(
              title: 'Carsnan',
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
