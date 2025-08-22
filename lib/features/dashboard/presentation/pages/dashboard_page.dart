import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../../cart/presentation/widgets/floating_cart_bar.dart';
import '../../../address/presentation/cubit/address_cubit.dart';
import '../../../../core/di/injection.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardCubit(
            getServicesUseCase: context.read(),
            bookingRepository: getIt(),
            reviewRepository: getIt(),
          )..loadServices(),
        ),
        BlocProvider(
          create: (context) => getIt<AddressCubit>()..loadAddresses(),
        ),
      ],
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
          return Stack(
            children: [
              IndexedStack(
                index: state.selectedBottomNavIndex,
                children: [
                  _buildHomePage(context, state, theme),
                  _buildOrdersPage(context, theme),
                  _buildProfilePage(context),
                ],
              ),
              // Floating cart bar positioned above bottom navigation
              Positioned(
                left: 0,
                right: 0,
                bottom: 15, // Very close to bottom navigation bar
                child: const FloatingCartBar(),
              ),
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
          onAddVehicle: () {}, // Not used anymore, handled by AddCarButton
          onAddAddress: () {}, // Not used anymore, handled by AddressSelector
        ),
        Expanded(child: _buildHomeBody(context, state, theme)),
      ],
    );
  }

  Widget _buildOrdersPage(BuildContext context, ThemeData theme) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state.isLoadingOrders) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.ordersError != null) {
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
                  'Error loading orders',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.ordersError!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<DashboardCubit>().loadOrders(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.orders.isEmpty) {
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

        return RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().loadOrders(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildOrderCard(context, theme, order),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, ThemeData theme, order) {
    // Simple order card for now
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.status.name.toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${order.items.length} service(s) • \$${order.totalPrice.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              'Created: ${_formatDate(order.createdAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (order.status.name == 'completed') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showReviewDialog(context, order),
                      child: const Text('Leave Review'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status.name) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'inProgress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showReviewDialog(BuildContext context, order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How was your service experience?'),
            const SizedBox(height: 16),
            // Simple star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    final rating = index + 1;
                    Navigator.of(context).pop();
                    context.read<DashboardCubit>().createReview(
                      bookingId: order.id,
                      rating: rating,
                      comment: 'Great service!',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your review!'),
                      ),
                    );
                  },
                  icon: Icon(Icons.star, color: Colors.amber),
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
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
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }
}
