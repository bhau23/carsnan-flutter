import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/addon_service.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/cart.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/addon_product_card.dart';

/// Full cart view page showing all cart items
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final AddonService _addonService = AddonService();
  final Map<String, int> _addonQuantities = {};
  bool _isCheckoutLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.hasItems) {
                return TextButton(
                  onPressed: () => _showClearCartDialog(context),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
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
                    'Error loading cart',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<CartCubit>().loadCart(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.isEmpty) {
            return _buildEmptyCart(context, theme);
          }

          return Column(
            children: [
              // Cart items list
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Cart Items Section
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: state.cart.items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = state.cart.items[index];
                          return CartItemWidget(
                            cartItem: item,
                            onRemove: () => context
                                .read<CartCubit>()
                                .removeFromCart(item.id),
                          );
                        },
                      ),

                      // Add Another Service Section
                      _buildAddAnotherServiceSection(context, theme),

                      // Add-ons Section
                      _buildAddonsSection(context, theme),
                    ],
                  ),
                ),
              ),

              // Bottom summary and checkout
              _buildBottomSummary(context, theme, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some services to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Browse Services'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSummary(
    BuildContext context,
    ThemeData theme,
    CartState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total (${_getTotalItemCount(state)} items)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Est. ${state.cart.totalDurationString}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${_getTotalPrice(state).toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD4AF37), // Gold color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Checkout button
            ElevatedButton(
              onPressed: _isCheckoutLoading
                  ? null
                  : () => _proceedToCheckout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.withValues(alpha: 0.3),
              ),
              child: _isCheckoutLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Processing...'),
                      ],
                    )
                  : Text(
                      'Proceed to Checkout',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAnotherServiceSection(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add Another Service',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          OutlinedButton(
            onPressed: () => _addAnotherService(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Add Service',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddonsSection(BuildContext context, ThemeData theme) {
    final availableAddons = _addonService.getAllAddons();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add-ons',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enhance your service with accessories',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (_getTotalAddonsCount() > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_getTotalAddonsCount()} added',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Horizontal scrollable addon products
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableAddons.length,
              itemBuilder: (context, index) {
                final addon = availableAddons[index];
                final quantity = _addonQuantities[addon.id] ?? 0;

                return AddonProductCard(
                  product: addon,
                  quantity: quantity,
                  onQuantityChanged: (newQuantity) {
                    setState(() {
                      if (newQuantity > 0) {
                        _addonQuantities[addon.id] = newQuantity;
                      } else {
                        _addonQuantities.remove(addon.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalAddonsCount() {
    return _addonQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double _getAddonsTotal() {
    double total = 0;
    _addonQuantities.forEach((addonId, quantity) {
      final addon = _addonService.findAddonById(addonId);
      if (addon != null) {
        total += addon.price * quantity;
      }
    });
    return total;
  }

  double _getTotalPrice(CartState state) {
    return state.totalPrice + _getAddonsTotal();
  }

  int _getTotalItemCount(CartState state) {
    return state.itemCount + _getTotalAddonsCount();
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context) async {
    if (_isCheckoutLoading) return;

    setState(() {
      _isCheckoutLoading = true;
    });

    try {
      final checkoutUseCase = getIt<CheckoutUseCase>();

      // For demo purposes, using a fixed user ID
      // In a real app, this would come from the authentication service
      const String userId = 'demo_user_123';

      final result = await checkoutUseCase(
        userId: userId,
        notes: 'Booking created from cart checkout',
        simulatePaymentFailure: false, // Change to true to test payment failure
      );

      if (context.mounted) {
        if (result.isSuccess) {
          _showCheckoutSuccessDialog(context, result.booking!);
        } else {
          _showCheckoutErrorDialog(context, result);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckoutLoading = false;
        });
      }
    }
  }

  void _showCheckoutSuccessDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),

            Text(
              'Booking Confirmed!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              'Your booking has been created successfully.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildBookingDetailRow('Booking ID:', booking.id),
                  _buildBookingDetailRow(
                    'Status:',
                    _getBookingStatusDisplayName(booking.status),
                  ),
                  _buildBookingDetailRow(
                    'Total:',
                    '\$${booking.totalPrice.toStringAsFixed(2)}',
                  ),
                  _buildBookingDetailRow(
                    'Services:',
                    '${booking.items.length} item(s)',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to dashboard
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showCheckoutErrorDialog(BuildContext context, CheckoutResult result) {
    String title = 'Checkout Failed';
    String message = result.message ?? 'An unknown error occurred.';

    // Customize message based on failure reason
    switch (result.failureReason) {
      case CheckoutFailureReason.emptyCart:
        title = 'Empty Cart';
        message = 'Please add items to your cart before checkout.';
        break;
      case CheckoutFailureReason.incompleteProfile:
        title = 'Profile Incomplete';
        message = 'Please complete your profile to proceed with checkout.';
        break;
      case CheckoutFailureReason.paymentFailed:
        title = 'Payment Failed';
        message =
            result.message ?? 'Payment processing failed. Please try again.';
        break;
      case CheckoutFailureReason.networkError:
        title = 'Network Error';
        message = 'Please check your internet connection and try again.';
        break;
      case CheckoutFailureReason.unknownError:
      case null:
        title = 'Error';
        message = result.message ?? 'An unexpected error occurred.';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          if (result.failureReason ==
              CheckoutFailureReason.incompleteProfile) ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to profile page
                context.push('/profile');
              },
              child: const Text('Complete Profile'),
            ),
          ],
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  String _getBookingStatusDisplayName(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'PENDING';
      case BookingStatus.confirmed:
        return 'CONFIRMED';
      case BookingStatus.inProgress:
        return 'IN PROGRESS';
      case BookingStatus.completed:
        return 'COMPLETED';
      case BookingStatus.cancelled:
        return 'CANCELLED';
    }
  }

  void _addAnotherService(BuildContext context) {
    // Navigate back to dashboard to select another service
    Navigator.of(context).pop(); // Close cart page
    // The user will be on the dashboard where they can select another service
  }
}
