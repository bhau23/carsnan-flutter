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

/// Abstract Firestore data source for cart operations
abstract class CartFirestoreDataSource {
  /// Get the current cart for a specific user
  Future<Cart> getCart(String userId);

  /// Add an item to the cart for a specific user
  Future<void> addItem(String userId, CartItem item);

  /// Remove an item from the cart by ID for a specific user
  Future<void> removeItem(String userId, String itemId);

  /// Clear all items from the cart for a specific user
  Future<void> clearCart(String userId);

  /// Get cart stream for reactive updates for a specific user
  Stream<Cart> watchCart(String userId);

  /// Get service by ID (needed for cart item reconstruction)
  Future<Service?> getServiceById(String serviceId);

  /// Get car by ID (needed for cart item reconstruction)
  Future<Car?> getCarById(String carId);
}

/// Abstract Firestore data source for booking operations
abstract class BookingFirestoreDataSource {
  /// Create a new booking
  Future<Booking> createBooking(Booking booking);

  /// Get all bookings for a user
  Future<List<Booking>> getUserBookings(String userId);

  /// Get a specific booking by ID
  Future<Booking?> getBookingById(String bookingId);

  /// Update booking status
  Future<void> updateBookingStatus(String bookingId, BookingStatus status);

  /// Get bookings stream for reactive updates
  Stream<List<Booking>> watchUserBookings(String userId);
}
