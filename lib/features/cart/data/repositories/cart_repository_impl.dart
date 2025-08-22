import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';

@Injectable(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  final CartFirestoreDataSource firestoreDataSource;
  final FirebaseAuth firebaseAuth;

  CartRepositoryImpl({
    required this.localDataSource,
    required this.firestoreDataSource,
    required this.firebaseAuth,
  }); // Updated constructor parameters

  /// Get current user ID or null if not authenticated
  String? get _currentUserId => firebaseAuth.currentUser?.uid;

  /// Use Firestore if user is authenticated, otherwise use local storage
  bool get _useFirestore => _currentUserId != null;

  @override
  Future<Cart> getCart() async {
    if (_useFirestore) {
      return await firestoreDataSource.getCart(_currentUserId!);
    } else {
      return await localDataSource.getCart();
    }
  }

  @override
  Future<void> addItem(CartItem item) async {
    if (_useFirestore) {
      await firestoreDataSource.addItem(_currentUserId!, item);
    } else {
      await localDataSource.addItem(item);
    }
  }

  @override
  Future<void> removeItem(String itemId) async {
    if (_useFirestore) {
      await firestoreDataSource.removeItem(_currentUserId!, itemId);
    } else {
      await localDataSource.removeItem(itemId);
    }
  }

  @override
  Future<void> clearCart() async {
    if (_useFirestore) {
      await firestoreDataSource.clearCart(_currentUserId!);
    } else {
      await localDataSource.clearCart();
    }
  }

  @override
  Future<int> getItemCount() async {
    final cart = await getCart();
    return cart.itemCount;
  }

  @override
  Future<bool> hasItems() async {
    final cart = await getCart();
    return cart.isNotEmpty;
  }

  @override
  Stream<Cart> watchCart() {
    if (_useFirestore) {
      return firestoreDataSource.watchCart(_currentUserId!);
    } else {
      return localDataSource.watchCart();
    }
  }
}

@Injectable(as: BookingRepository)
class BookingRepositoryImpl implements BookingRepository {
  final BookingFirestoreDataSource bookingDataSource;
  final FirebaseAuth firebaseAuth;

  BookingRepositoryImpl({
    required this.bookingDataSource,
    required this.firebaseAuth,
  });

  @override
  Future<Booking> createBooking({
    required String userId,
    required List<CartItem> items,
    required double totalPrice,
    String? paymentId,
    String? notes,
  }) async {
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      items: items,
      totalPrice: totalPrice,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
      paymentId: paymentId,
      notes: notes,
    );

    return await bookingDataSource.createBooking(booking);
  }

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    return await bookingDataSource.getUserBookings(userId);
  }

  @override
  Future<Booking?> getBookingById(String bookingId) async {
    return await bookingDataSource.getBookingById(bookingId);
  }

  @override
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    await bookingDataSource.updateBookingStatus(bookingId, status);
  }

  @override
  Stream<List<Booking>> watchUserBookings(String userId) {
    return bookingDataSource.watchUserBookings(userId);
  }
}

@Injectable(as: ReviewRepository)
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewFirestoreDataSource reviewDataSource;

  ReviewRepositoryImpl({required this.reviewDataSource});

  @override
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
  }) async {
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookingId: bookingId,
      clientId: clientId,
      workerId: workerId,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
      serviceName: serviceName,
      serviceDescription: serviceDescription,
      clientName: clientName,
      clientEmail: clientEmail,
      workerName: workerName,
    );

    return await reviewDataSource.createReview(review);
  }

  @override
  Future<List<Review>> getBookingReviews(String bookingId) async {
    return await reviewDataSource.getBookingReviews(bookingId);
  }

  @override
  Future<List<Review>> getClientReviews(String clientId) async {
    return await reviewDataSource.getClientReviews(clientId);
  }

  @override
  Future<List<Review>> getWorkerReviews(String workerId) async {
    return await reviewDataSource.getWorkerReviews(workerId);
  }

  @override
  Future<Review?> getReviewById(String reviewId) async {
    return await reviewDataSource.getReviewById(reviewId);
  }

  @override
  Future<Review> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    final updates = <String, dynamic>{};
    if (rating != null) updates['rating'] = rating;
    if (comment != null) updates['comment'] = comment;

    return await reviewDataSource.updateReview(reviewId, updates);
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    await reviewDataSource.deleteReview(reviewId);
  }

  @override
  Future<bool> hasClientReviewedBooking(
    String bookingId,
    String clientId,
  ) async {
    return await reviewDataSource.hasClientReviewedBooking(bookingId, clientId);
  }

  @override
  Future<double> getWorkerAverageRating(String workerId) async {
    return await reviewDataSource.getWorkerAverageRating(workerId);
  }

  @override
  Future<int> getWorkerReviewCount(String workerId) async {
    return await reviewDataSource.getWorkerReviewCount(workerId);
  }

  @override
  Stream<List<Review>> watchBookingReviews(String bookingId) {
    return reviewDataSource.watchBookingReviews(bookingId);
  }

  @override
  Stream<List<Review>> watchClientReviews(String clientId) {
    return reviewDataSource.watchClientReviews(clientId);
  }

  @override
  Stream<List<Review>> watchWorkerReviews(String workerId) {
    return reviewDataSource.watchWorkerReviews(workerId);
  }
}
