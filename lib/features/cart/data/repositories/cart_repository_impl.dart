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
