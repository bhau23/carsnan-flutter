import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

/// Cart icon widget with dynamic item count badge
class CartIconWidget extends StatelessWidget {
  final Color? iconColor;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final double? iconSize;

  const CartIconWidget({
    super.key,
    this.iconColor,
    this.badgeColor,
    this.badgeTextColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Stack(
          children: [
            IconButton(
              onPressed: () => _navigateToCart(context),
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: iconColor ?? theme.iconTheme.color,
                size: iconSize ?? 24,
              ),
            ),
            if (state.itemCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor ?? theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    state.itemCount > 99 ? '99+' : state.itemCount.toString(),
                    style: TextStyle(
                      color: badgeTextColor ?? theme.colorScheme.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _navigateToCart(BuildContext context) {
    context.push('/cart');
  }
}
