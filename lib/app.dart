import 'package:carsnan/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection.dart';
import '../core/router/app_router.dart';
import '../theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(const CheckAuthStatus()),
      child: Builder(
        builder: (context) {
          final router = AppRouter(authBloc: context.read<AuthBloc>()).router;
          return MaterialApp.router(
            title: 'Carsnan',
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            theme: const MaterialTheme(Typography.englishLike2018).light(),
            darkTheme: const MaterialTheme(Typography.englishLike2018).dark(),
          );
        },
      ),
    );
  }
}
