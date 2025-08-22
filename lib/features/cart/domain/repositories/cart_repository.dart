import '../entities/cart.dart';

/// Repository interface for cart operations
abstract class CartRepository {
  /// Get the current cart
  Future<Cart> getCart();

  /// Add an item to the cart
  Future<void> addItem(CartItem item);

  /// Remove an item from the cart by ID
  Future<void> removeItem(String itemId);

  /// Clear all items from the cart
  Future<void> clearCart();

  /// Get the total number of items in the cart
  Future<int> getItemCount();

  /// Check if the cart has items
  Future<bool> hasItems();

  /// Get cart items stream for reactive updates
  Stream<Cart> watchCart();
}

/// Repository interface for booking operations
abstract class BookingRepository {
  /// Create a new booking from cart items
  Future<Booking> createBooking({
    required String userId,
    required List<CartItem> items,
    required double totalPrice,
    String? paymentId,
    String? notes,
  });

  /// Get all bookings for a user
  Future<List<Booking>> getUserBookings(String userId);

  /// Get a specific booking by ID
  Future<Booking?> getBookingById(String bookingId);

  /// Update booking status
  Future<void> updateBookingStatus(String bookingId, BookingStatus status);

  /// Get bookings stream for reactive updates
  Stream<List<Booking>> watchUserBookings(String userId);
}
