import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/top_action_bar.dart';
import '../widgets/service_card.dart';
import '../widgets/bottom_nav_bar.dart';
import 'service_details_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../profile/data/datasources/profile_local_datasource.dart';
import '../../../profile/data/repositories/profile_repository_impl.dart';
import '../../../profile/domain/usecases/get_user_profile_usecase.dart';
import '../../../profile/domain/usecases/update_user_profile_usecase.dart';
import '../../../cart/presentation/widgets/cart_icon_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DashboardCubit(getServicesUseCase: context.read())..loadServices(),
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
        title: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return Text(
              _getAppBarTitle(state.selectedBottomNavIndex),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [CartIconWidget()],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return IndexedStack(
            index: state.selectedBottomNavIndex,
            children: [
              _buildHomePage(context, state, theme),
              _buildOrdersPage(context, theme),
              _buildProfilePage(context),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return BottomNavBar(
            currentIndex: state.selectedBottomNavIndex,
            onTap: (index) =>
                context.read<DashboardCubit>().updateBottomNavIndex(index),
          );
        },
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'CarsNan';
      case 1:
        return 'My Orders';
      case 2:
        return 'My Profile';
      default:
        return 'CarsNan';
    }
  }

  Widget _buildHomePage(
    BuildContext context,
    DashboardState state,
    ThemeData theme,
  ) {
    return Column(
      children: [
        TopActionBar(
          onAddAddress: () =>
              context.read<DashboardCubit>().navigateToAddAddress(),
          onAddVehicle: () => _navigateToCars(context),
        ),
        Expanded(child: _buildHomeBody(context, state, theme)),
      ],
    );
  }

  Widget _buildOrdersPage(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No orders yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your order history will appear here',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProfileLocalDataSourceImpl>(
          create: (context) => ProfileLocalDataSourceImpl(),
        ),
        RepositoryProvider<ProfileRepositoryImpl>(
          create: (context) =>
              ProfileRepositoryImpl(context.read<ProfileLocalDataSourceImpl>()),
        ),
        RepositoryProvider<GetUserProfileUseCase>(
          create: (context) =>
              GetUserProfileUseCase(context.read<ProfileRepositoryImpl>()),
        ),
        RepositoryProvider<UpdateUserProfileUseCase>(
          create: (context) =>
              UpdateUserProfileUseCase(context.read<ProfileRepositoryImpl>()),
        ),
      ],
      child: const ProfilePage(userId: 'current_user'),
    );
  }

  Widget _buildHomeBody(
    BuildContext context,
    DashboardState state,
    ThemeData theme,
  ) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: theme.textTheme.titleLarge),
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
                    color: theme.textTheme.bodyLarge?.color?.withValues(
                      alpha: 0.7,
                    ),
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
            delegate: SliverChildBuilderDelegate((context, index) {
              final service = state.services[index];
              return ServiceCard(
                service: service,
                onTap: () {
                  context.read<DashboardCubit>().selectService(service.id);
                  ServiceDetailsPage.show(context, service);
                },
              );
            }, childCount: state.services.length),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }

  void _navigateToCars(BuildContext context) {
    context.push('/cars');
  }
}
