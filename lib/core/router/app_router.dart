import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static GoRouter get router => GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Dashboard Page'),
          ),
        ),
      ),
    ],
  );
}
