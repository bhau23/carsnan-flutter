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

/// Repository interface for review operations
abstract class ReviewRepository {
  /// Create a new review for a booking
  Future<Review> createReview({
    required String bookingId,
    required String clientId,
    required String workerId,
    required int rating,
    String? comment,
    String? serviceName,
    String? serviceDescription,
    String? clientName,
    String? clientEmail,
    String? workerName,
  });

  /// Get all reviews for a specific booking
  Future<List<Review>> getBookingReviews(String bookingId);

  /// Get all reviews by a client
  Future<List<Review>> getClientReviews(String clientId);

  /// Get all reviews for a worker
  Future<List<Review>> getWorkerReviews(String workerId);

  /// Get a specific review by ID
  Future<Review?> getReviewById(String reviewId);

  /// Update an existing review
  Future<Review> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  });

  /// Delete a review
  Future<void> deleteReview(String reviewId);

  /// Check if a booking already has a review from the client
  Future<bool> hasClientReviewedBooking(String bookingId, String clientId);

  /// Get average rating for a worker
  Future<double> getWorkerAverageRating(String workerId);

  /// Get review count for a worker
  Future<int> getWorkerReviewCount(String workerId);

  /// Get reviews stream for reactive updates
  Stream<List<Review>> watchBookingReviews(String bookingId);

  /// Get client reviews stream
  Stream<List<Review>> watchClientReviews(String clientId);

  /// Get worker reviews stream
  Stream<List<Review>> watchWorkerReviews(String workerId);
}
