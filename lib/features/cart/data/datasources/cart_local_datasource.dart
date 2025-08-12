import 'dart:async';
import '../../../dashboard/domain/entities/service.dart';
import '../../../car/domain/entities/car.dart';
import '../../domain/entities/cart.dart';

/// Abstract data source for cart operations
abstract class CartLocalDataSource {
  /// Get the current cart
  Future<Cart> getCart();

  /// Add an item to the cart
  Future<void> addItem(CartItem item);

  /// Remove an item from the cart by ID
  Future<void> removeItem(String itemId);

  /// Clear all items from the cart
  Future<void> clearCart();

  /// Get cart stream for reactive updates
  Stream<Cart> watchCart();

  /// Get service by ID (needed for cart item reconstruction)
  Future<Service?> getServiceById(String serviceId);

  /// Get car by ID (needed for cart item reconstruction)
  Future<Car?> getCarById(String carId);
}
