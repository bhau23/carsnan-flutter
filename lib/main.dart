import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/data/datasources/service_local_datasource.dart';
import 'features/dashboard/data/repositories/service_repository_impl.dart';
import 'features/dashboard/domain/usecases/get_services_usecase.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      child: MaterialApp(
        title: 'CarsNan',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const DashboardPage(),
      ),
    );
  }
}
