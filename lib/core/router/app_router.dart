import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_state.dart';
import 'package:carsnan/features/authentication/presentation/pages/email_authentication_page.dart';
import 'package:carsnan/features/authentication/presentation/pages/mfa_verification_page.dart';
import 'package:carsnan/features/authentication/presentation/pages/otp_verification_page.dart';
import 'package:carsnan/features/authentication/presentation/pages/phone_authentication_page.dart';
import 'package:carsnan/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:carsnan/features/car/presentation/pages/car_list_page.dart';
import 'package:carsnan/features/car/presentation/pages/add_car_page.dart';
import 'package:carsnan/features/car/presentation/pages/edit_car_page.dart';
import 'package:carsnan/features/cart/presentation/pages/cart_page.dart';
import 'dart:async';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const DashboardPage(),
      ),
      // Primary authentication route - now uses email/password
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const EmailAuthenticationPage(),
      ),
      // MFA verification route
      GoRoute(
        path: '/mfa',
        builder: (BuildContext context, GoRouterState state) =>
            const MfaVerificationPage(),
      ),
      // Legacy phone authentication route (for backward compatibility)
      GoRoute(
        path: '/phone-auth',
        builder: (BuildContext context, GoRouterState state) =>
            const PhoneAuthenticationPage(),
      ),
      // Legacy OTP verification route
      GoRoute(
        path: '/otp',
        builder: (BuildContext context, GoRouterState state) =>
            const OtpVerificationPage(),
      ),
      // Car management routes
      GoRoute(
        path: '/cars',
        builder: (BuildContext context, GoRouterState state) =>
            const CarListPage(),
      ),
      GoRoute(
        path: '/cars/add',
        builder: (BuildContext context, GoRouterState state) =>
            const AddCarPage(),
      ),
      GoRoute(
        path: '/cars/edit/:carId',
        builder: (BuildContext context, GoRouterState state) =>
            EditCarPage(carId: state.pathParameters['carId']!),
      ),
      // Cart route
      GoRoute(
        path: '/cart',
        builder: (BuildContext context, GoRouterState state) =>
            const CartPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authBloc.state.maybeWhen(
        authenticated: (user) => true,
        orElse: () => false,
      );

      final bool mfaRequired = authBloc.state.maybeWhen(
        mfaRequired: () => true,
        orElse: () => false,
      );

      final bool loggingIn = state.matchedLocation == '/login';
      final bool inMfaFlow = state.matchedLocation == '/mfa';
      final bool usingPhoneAuth = state.matchedLocation == '/phone-auth';
      final bool inOtpFlow = state.matchedLocation == '/otp';

      // If MFA is required, redirect to MFA page
      if (mfaRequired && !inMfaFlow) {
        return '/mfa';
      }

      // If not logged in and MFA not required, allow access to auth pages
      if (!loggedIn && !mfaRequired) {
        // Allow access to login, phone-auth, and otp pages
        if (loggingIn || usingPhoneAuth || inOtpFlow) {
          return null;
        }
        // For any other route, redirect to login
        return '/login';
      }

      // If logged in and trying to access auth pages, redirect to dashboard
      if (loggedIn && (loggingIn || inMfaFlow || usingPhoneAuth || inOtpFlow)) {
        return '/';
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
