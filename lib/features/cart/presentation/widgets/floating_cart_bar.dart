import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../pages/cart_page.dart';

class FloatingCartBar extends StatefulWidget {
  const FloatingCartBar({Key? key}) : super(key: key);

  @override
  State<FloatingCartBar> createState() => _FloatingCartBarState();
}

class _FloatingCartBarState extends State<FloatingCartBar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  
  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 250), // Reduced duration for better performance
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 150), // Reduced duration
      vsync: this,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // Only show if cart has items
        if (state.isEmpty) {
          _slideController.reverse();
          return const SizedBox.shrink();
        }

        _slideController.forward();
        
        final totalPrice = state.totalPrice;
        final itemCount = state.itemCount;

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeOutBack,
          )),
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0), // No vertical margin
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Cart icon with item count
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.shopping_cart,
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              itemCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Cart text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'You have items worth ₹$totalPrice',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'waiting in your cart',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Go to Cart button
                GestureDetector(
                  onTap: () => _navigateToCart(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Go to Cart',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Close button
                GestureDetector(
                  onTap: () => _showClearCartDialog(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: theme.colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartPage(),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return ClearCartDialog(
          onConfirm: () {
            Navigator.of(dialogContext).pop();
            context.read<CartCubit>().clearCart();
            _showClearSuccessMessage(context);
          },
          onCancel: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  void _showClearSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cart cleared successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(
          bottom: 120, // Just above the cart bar
          left: 16,
          right: 16,
        ),
      ),
    );
  }
}

class ClearCartDialog extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ClearCartDialog({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ClearCartDialog> createState() => _ClearCartDialogState();
}

class _ClearCartDialogState extends State<ClearCartDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3 * _opacityAnimation.value),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0 * _opacityAnimation.value,
                    sigmaY: 5.0 * _opacityAnimation.value,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.0),
                    ),
                  ),
                ),
              ),
            ),
            
            // Dialog content
            Center(
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Warning icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning_rounded,
                          color: Colors.orange,
                          size: 30,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Title
                      Text(
                        'Remove Services?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Message
                      Text(
                        'Service remove from your cart',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Buttons
                      Row(
                        children: [
                          // No button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: widget.onCancel,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Yes button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: widget.onConfirm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
