import 'package:equatable/equatable.dart';
import '../../domain/entities/cart.dart';

/// State for cart management
class CartState extends Equatable {
  const CartState({
    this.cart = const Cart(),
    this.isLoading = false,
    this.error,
  });

  /// Current cart
  final Cart cart;

  /// Loading state for cart operations
  final bool isLoading;

  /// Error message if any
  final String? error;

  /// Convenience getter for item count
  int get itemCount => cart.itemCount;

  /// Convenience getter for total price
  double get totalPrice => cart.totalPrice;

  /// Convenience getter for empty cart check
  bool get isEmpty => cart.isEmpty;

  /// Convenience getter for cart with items check
  bool get hasItems => cart.isNotEmpty;

  CartState copyWith({Cart? cart, bool? isLoading, String? error}) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [cart, isLoading, error];
}
