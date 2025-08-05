import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/top_action_bar.dart';
import '../widgets/service_card.dart';
import '../widgets/bottom_nav_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        getServicesUseCase: context.read(),
      )..loadServices(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CarsNan',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return Column(
            children: [
              TopActionBar(
                onAddAddress: () => context.read<DashboardCubit>().navigateToAddAddress(),
                onAddVehicle: () => context.read<DashboardCubit>().navigateToAddVehicle(),
              ),
              Expanded(
                child: _buildBody(context, state, theme),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return BottomNavBar(
            currentIndex: state.selectedBottomNavIndex,
            onTap: (index) => context.read<DashboardCubit>().updateBottomNavIndex(index),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardState state, ThemeData theme) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<DashboardCubit>().loadServices(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Services',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the perfect service for your vehicle',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final service = state.services[index];
                return ServiceCard(
                  service: service,
                  onTap: () => context.read<DashboardCubit>().selectService(service.id),
                );
              },
              childCount: state.services.length,
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 32),
        ),
      ],
    );
  }
}
