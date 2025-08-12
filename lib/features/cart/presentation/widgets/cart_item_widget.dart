import 'package:flutter/material.dart';
import '../../domain/entities/cart.dart';
import '../../../dashboard/domain/entities/service.dart';
import '../../../car/domain/entities/car.dart';

/// Widget for displaying individual cart items
class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service and car info row
            Row(
              children: [
                // Service icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getServiceColor(cartItem.service.type),
                        _getServiceColor(
                          cartItem.service.type,
                        ).withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getServiceIcon(cartItem.service.type),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Service and car details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.service.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            _getCarIcon(cartItem.car.type),
                            size: 16,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              cartItem.car.displayName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cartItem.car.fullDescription,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Remove button
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: theme.colorScheme.error,
                  ),
                  tooltip: 'Remove from cart',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Price and duration row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cartItem.car.type.priceMultiplier != 1.0) ...[
                      Text(
                        'Base: \$${cartItem.service.price.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Row(
                      children: [
                        Text(
                          '\$${cartItem.finalPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37), // Gold color
                          ),
                        ),
                        if (cartItem.car.type.priceMultiplier != 1.0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getServiceColor(
                                cartItem.service.type,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${cartItem.car.type.displayName} ${(cartItem.car.type.priceMultiplier * 100).toInt()}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getServiceColor(cartItem.service.type),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cartItem.durationString,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Added ${_formatAddedTime(cartItem.addedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getServiceColor(ServiceType type) {
    switch (type) {
      case ServiceType.general:
        return const Color(0xFF4CAF50); // Green
      case ServiceType.premium:
        return const Color(0xFF2196F3); // Blue
      case ServiceType.luxury:
        return const Color(0xFFD4AF37); // Gold
    }
  }

  IconData _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.general:
        return Icons.local_car_wash;
      case ServiceType.premium:
        return Icons.car_repair;
      case ServiceType.luxury:
        return Icons.diamond;
    }
  }

  IconData _getCarIcon(CarType type) {
    switch (type) {
      case CarType.sedan:
        return Icons.directions_car;
      case CarType.suv:
        return Icons.directions_car;
      case CarType.mini:
        return Icons.directions_car;
    }
  }

  String _formatAddedTime(DateTime addedAt) {
    final now = DateTime.now();
    final difference = now.difference(addedAt);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
