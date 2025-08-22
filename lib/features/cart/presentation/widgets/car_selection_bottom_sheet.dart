import 'package:carsnan/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/dynamic_pricing_service.dart';
import '../../../car/presentation/cubit/car_cubit.dart';
import '../../../car/presentation/cubit/car_state.dart';
import '../../../car/domain/entities/car.dart';
import '../../../dashboard/domain/entities/service.dart';
import '../cubit/cart_cubit.dart';
import '../../domain/entities/cart.dart';
import 'add_to_cart_success_dialog.dart';

/// Bottom sheet for selecting a car when adding to cart
class CarSelectionBottomSheet extends StatelessWidget {
  final Service service;

  const CarSelectionBottomSheet({super.key, required this.service});

  static void show(BuildContext context, Service service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CarSelectionBottomSheet(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Select a Vehicle',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose which car to add ${service.title} service for',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Cars list
          Flexible(
            child: BlocBuilder<CarCubit, CarState>(
              builder: (context, carState) {
                if (carState is CarLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (carState is CarError) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading cars',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          carState.message,
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (carState is CarLoaded && carState.cars.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No cars found',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please add a vehicle first',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Navigate to add car page
                          },
                          child: const Text('Add Vehicle'),
                        ),
                      ],
                    ),
                  );
                }

                if (carState is CarLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: carState.cars.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final car = carState.cars[index];
                      return _buildCarCard(context, theme, car);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // Bottom padding for safe area
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, ThemeData theme, Car car) {
    final cartCubit = context.read<CartCubit>();
    final isInCart = cartCubit.isServiceCarInCart(service.id, car.id);
    final pricingService = getIt<DynamicPricingService>();
    final finalPrice = pricingService.calculateServicePrice(service, car);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: isInCart ? null : () => _addToCart(context, car),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Car type icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getCarTypeColor(car.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    car.type.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Car details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            car.displayName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (car.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'DEFAULT',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.fullDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${finalPrice.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFD4AF37),
                              ),
                            ),
                          ],
                        ),
                        if (isInCart)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'In Cart',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCarTypeColor(CarType type) {
    switch (type) {
      case CarType.sedan:
        return Colors.blue;
      case CarType.suv:
        return Colors.green;
      case CarType.mini:
        return Colors.orange;
    }
  }

  void _addToCart(BuildContext context, Car car) async {
    final cartCubit = context.read<CartCubit>();

    try {
      await cartCubit.addToCart(
        service: service,
        car: car,
        timeSlot: null, // No time slot selected yet in car selection
      );

      if (context.mounted) {
        // Close the car selection modal
        Navigator.pop(context);

        // Create the cart item for the dialog
        final cartItem = CartItem(
          id: '${service.id}_${car.id}_${DateTime.now().millisecondsSinceEpoch}',
          service: service,
          car: car,
          addedAt: DateTime.now(),
          timeSlot: null, // No time slot yet
        );

        // Show success dialog with options
        AddToCartSuccessDialog.show(context, cartItem);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to add to cart: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
