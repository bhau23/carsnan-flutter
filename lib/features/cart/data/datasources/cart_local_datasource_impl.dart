import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/time_slot.dart';
import '../../../dashboard/data/datasources/service_local_datasource.dart';
import '../../../car/data/datasources/car_local_data_source.dart';
import '../../../dashboard/domain/entities/service.dart';
import '../../../car/domain/entities/car.dart';
import '../../domain/entities/cart.dart';
import 'cart_local_datasource.dart';

@Injectable(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final ServiceLocalDataSource serviceDataSource;
  final CarLocalDataSource carDataSource;

  CartLocalDataSourceImpl({
    required this.serviceDataSource,
    required this.carDataSource,
  });

  // In-memory storage for demo purposes (could be replaced with Hive later)
  static final List<CartItem> _cartItems = [];
  static final StreamController<Cart> _cartStreamController =
      StreamController<Cart>.broadcast();

  @override
  Future<Cart> getCart() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return Cart(items: List.from(_cartItems));
  }

  @override
  Future<void> addItem(CartItem item) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Check if the same service+car combination already exists
    final existingIndex = _cartItems.indexWhere(
      (existingItem) =>
          existingItem.service.id == item.service.id &&
          existingItem.car.id == item.car.id,
    );

    if (existingIndex != -1) {
      // Replace existing item with new one (updated timestamp)
      _cartItems[existingIndex] = item;
    } else {
      // Add new item
      _cartItems.add(item);
    }

    // Notify listeners of cart changes
    _cartStreamController.add(Cart(items: List.from(_cartItems)));
  }

  @override
  Future<void> removeItem(String itemId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    _cartItems.removeWhere((item) => item.id == itemId);

    // Notify listeners of cart changes
    _cartStreamController.add(Cart(items: List.from(_cartItems)));
  }

  @override
  Future<void> clearCart() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    _cartItems.clear();

    // Notify listeners of cart changes
    _cartStreamController.add(Cart(items: List.from(_cartItems)));
  }

  @override
  Stream<Cart> watchCart() {
    // Emit current cart state immediately
    _cartStreamController.add(Cart(items: List.from(_cartItems)));
    return _cartStreamController.stream;
  }

  @override
  Future<Service?> getServiceById(String serviceId) async {
    final services = await serviceDataSource.getServices();
    try {
      return services.firstWhere((service) => service.id == serviceId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Car?> getCarById(String carId) async {
    try {
      final carModel = await carDataSource.getCarById(carId);
      if (carModel == null) return null;

      // Convert CarModel to Car entity
      return Car(
        id: carModel.id,
        make: carModel.make,
        model: carModel.model,
        year: carModel.year,
        color: carModel.color,
        licensePlate: carModel.licensePlate,
        nickname: carModel.nickname,
        type: carModel.type,
        isDefault: carModel.isDefault,
        createdAt: carModel.createdAt,
        updatedAt: carModel.updatedAt,
      );
    } catch (e) {
      return null;
    }
  }

  /// Dispose method to close stream controller
  void dispose() {
    _cartStreamController.close();
  }
}

@Injectable(as: CartFirestoreDataSource)
class CartFirestoreDataSourceImpl implements CartFirestoreDataSource {
  final FirebaseFirestore _firestore;
  final ServiceLocalDataSource serviceDataSource;
  final CarLocalDataSource carDataSource;

  CartFirestoreDataSourceImpl(
    this._firestore, {
    required this.serviceDataSource,
    required this.carDataSource,
  });

  /// Get the cart collection reference for a user
  CollectionReference _getCartCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  @override
  Future<Cart> getCart(String userId) async {
    try {
      final querySnapshot = await _getCartCollection(userId).get();
      final cartItems = <CartItem>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final cartItem = await _mapToCartItem(doc.id, data);
        if (cartItem != null) {
          cartItems.add(cartItem);
        }
      }

      return Cart(items: cartItems);
    } catch (e) {
      throw Exception('Failed to get cart: $e');
    }
  }

  @override
  Future<void> addItem(String userId, CartItem item) async {
    try {
      final cartData = {
        'serviceId': item.service.id,
        'carId': item.car.id,
        'addedAt': item.addedAt.toIso8601String(),
        'timeSlot': item.timeSlot?.toMap(),
        'price': item.finalPrice,
      };

      await _getCartCollection(userId).doc(item.id).set(cartData);
    } catch (e) {
      throw Exception('Failed to add cart item: $e');
    }
  }

  @override
  Future<void> removeItem(String userId, String itemId) async {
    try {
      await _getCartCollection(userId).doc(itemId).delete();
    } catch (e) {
      throw Exception('Failed to remove cart item: $e');
    }
  }

  @override
  Future<void> clearCart(String userId) async {
    try {
      final batch = _firestore.batch();
      final querySnapshot = await _getCartCollection(userId).get();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  @override
  Stream<Cart> watchCart(String userId) {
    return _getCartCollection(userId).snapshots().asyncMap((snapshot) async {
      final cartItems = <CartItem>[];

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final cartItem = await _mapToCartItem(doc.id, data);
        if (cartItem != null) {
          cartItems.add(cartItem);
        }
      }

      return Cart(items: cartItems);
    });
  }

  @override
  Future<Service?> getServiceById(String serviceId) async {
    final services = await serviceDataSource.getServices();
    try {
      return services.firstWhere((service) => service.id == serviceId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Car?> getCarById(String carId) async {
    try {
      final carModel = await carDataSource.getCarById(carId);
      if (carModel == null) return null;

      // Convert CarModel to Car entity
      return Car(
        id: carModel.id,
        make: carModel.make,
        model: carModel.model,
        year: carModel.year,
        color: carModel.color,
        licensePlate: carModel.licensePlate,
        nickname: carModel.nickname,
        type: carModel.type,
        isDefault: carModel.isDefault,
        createdAt: carModel.createdAt,
        updatedAt: carModel.updatedAt,
      );
    } catch (e) {
      return null;
    }
  }

  /// Helper method to map Firestore document to CartItem entity
  Future<CartItem?> _mapToCartItem(String id, Map<String, dynamic> data) async {
    try {
      final serviceId = data['serviceId'] as String;
      final carId = data['carId'] as String;
      final addedAt = DateTime.parse(data['addedAt'] as String);

      final service = await getServiceById(serviceId);
      final car = await getCarById(carId);

      if (service == null || car == null) {
        return null;
      }

      return CartItem(
        id: id,
        service: service,
        car: car,
        addedAt: addedAt,
        timeSlot: data['timeSlot'] != null
            ? TimeSlot.fromMap(data['timeSlot'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      return null;
    }
  }
}

@Injectable(as: BookingFirestoreDataSource)
class BookingFirestoreDataSourceImpl implements BookingFirestoreDataSource {
  final FirebaseFirestore _firestore;
  final ServiceLocalDataSource serviceDataSource;
  final CarLocalDataSource carDataSource;

  BookingFirestoreDataSourceImpl(
    this._firestore, {
    required this.serviceDataSource,
    required this.carDataSource,
  });

  /// Get the bookings collection reference
  CollectionReference get _bookingsCollection =>
      _firestore.collection('bookings');

  @override
  Future<Booking> createBooking(Booking booking) async {
    try {
      await _bookingsCollection.doc(booking.id).set(booking.toMap());
      return booking;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final querySnapshot = await _bookingsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final bookings = <Booking>[];
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final booking = await _mapToBooking(doc.id, data);
        if (booking != null) {
          bookings.add(booking);
        }
      }

      return bookings;
    } catch (e) {
      throw Exception('Failed to get user bookings: $e');
    }
  }

  @override
  Future<Booking?> getBookingById(String bookingId) async {
    try {
      final doc = await _bookingsCollection.doc(bookingId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return await _mapToBooking(doc.id, data);
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  @override
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    try {
      final updates = <String, dynamic>{'status': status.name};

      // If completing the booking, set completedAt timestamp
      if (status == BookingStatus.completed) {
        updates['completedAt'] = DateTime.now().toIso8601String();
      }

      await _bookingsCollection.doc(bookingId).update(updates);
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  @override
  Stream<List<Booking>> watchUserBookings(String userId) {
    return _bookingsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final bookings = <Booking>[];

          for (final doc in snapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final booking = await _mapToBooking(doc.id, data);
            if (booking != null) {
              bookings.add(booking);
            }
          }

          return bookings;
        });
  }

  /// Helper method to map Firestore document to Booking entity
  Future<Booking?> _mapToBooking(String id, Map<String, dynamic> data) async {
    try {
      final userId = data['userId'] as String;
      final totalPrice = (data['totalPrice'] as num).toDouble();
      final statusString = data['status'] as String;
      final createdAt = DateTime.parse(data['createdAt'] as String);
      final completedAt = data['completedAt'] != null
          ? DateTime.parse(data['completedAt'] as String)
          : null;
      final paymentId = data['paymentId'] as String?;
      final notes = data['notes'] as String?;

      // Parse booking status
      final status = BookingStatus.values.firstWhere(
        (s) => s.name == statusString,
        orElse: () => BookingStatus.pending,
      );

      // Reconstruct cart items
      final itemMaps = List<Map<String, dynamic>>.from(data['items']);
      final items = <CartItem>[];

      for (final itemMap in itemMaps) {
        final serviceId = itemMap['serviceId'] as String;
        final carId = itemMap['carId'] as String;
        final addedAt = DateTime.parse(itemMap['addedAt'] as String);

        try {
          final service = await serviceDataSource.getServiceById(serviceId);
          final carModel = await carDataSource.getCarById(carId);

          if (carModel != null) {
            // Convert CarModel to Car entity
            final car = Car(
              id: carModel.id,
              make: carModel.make,
              model: carModel.model,
              year: carModel.year,
              color: carModel.color,
              licensePlate: carModel.licensePlate,
              nickname: carModel.nickname,
              type: carModel.type,
              isDefault: carModel.isDefault,
              createdAt: carModel.createdAt,
              updatedAt: carModel.updatedAt,
            );

            final cartItem = CartItem(
              id: itemMap['id'] as String,
              service: service,
              car: car,
              addedAt: addedAt,
              timeSlot: itemMap['timeSlot'] != null
                  ? TimeSlot.fromMap(
                      itemMap['timeSlot'] as Map<String, dynamic>,
                    )
                  : null,
            );

            items.add(cartItem);
          }
        } catch (e) {
          // Skip items where service or car can't be found
          continue;
        }
      }

      return Booking(
        id: id,
        userId: userId,
        items: items,
        totalPrice: totalPrice,
        status: status,
        createdAt: createdAt,
        completedAt: completedAt,
        paymentId: paymentId,
        notes: notes,
      );
    } catch (e) {
      return null;
    }
  }
}

@Injectable(as: ReviewFirestoreDataSource)
class ReviewFirestoreDataSourceImpl implements ReviewFirestoreDataSource {
  final FirebaseFirestore _firestore;

  ReviewFirestoreDataSourceImpl(this._firestore);

  /// Get the reviews collection reference
  CollectionReference get _reviewsCollection =>
      _firestore.collection('reviews');

  @override
  Future<Review> createReview(Review review) async {
    try {
      await _reviewsCollection.doc(review.id).set(review.toMap());
      return review;
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  @override
  Future<List<Review>> getBookingReviews(String bookingId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('bookingId', isEqualTo: bookingId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get booking reviews: $e');
    }
  }

  @override
  Future<List<Review>> getClientReviews(String clientId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('clientId', isEqualTo: clientId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get client reviews: $e');
    }
  }

  @override
  Future<List<Review>> getWorkerReviews(String workerId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('workerId', isEqualTo: workerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get worker reviews: $e');
    }
  }

  @override
  Future<Review?> getReviewById(String reviewId) async {
    try {
      final doc = await _reviewsCollection.doc(reviewId).get();
      if (!doc.exists) return null;

      return Review.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get review: $e');
    }
  }

  @override
  Future<Review> updateReview(
    String reviewId,
    Map<String, dynamic> updates,
  ) async {
    try {
      // Add updatedAt timestamp
      updates['updatedAt'] = DateTime.now().toIso8601String();

      await _reviewsCollection.doc(reviewId).update(updates);

      // Return the updated review
      final updatedDoc = await _reviewsCollection.doc(reviewId).get();
      return Review.fromMap(updatedDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await _reviewsCollection.doc(reviewId).delete();
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  @override
  Future<bool> hasClientReviewedBooking(
    String bookingId,
    String clientId,
  ) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('bookingId', isEqualTo: bookingId)
          .where('clientId', isEqualTo: clientId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check if client reviewed booking: $e');
    }
  }

  @override
  Future<double> getWorkerAverageRating(String workerId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('workerId', isEqualTo: workerId)
          .get();

      if (querySnapshot.docs.isEmpty) return 0.0;

      double totalRating = 0.0;
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalRating += (data['rating'] as int).toDouble();
      }

      return totalRating / querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get worker average rating: $e');
    }
  }

  @override
  Future<int> getWorkerReviewCount(String workerId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('workerId', isEqualTo: workerId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get worker review count: $e');
    }
  }

  @override
  Stream<List<Review>> watchBookingReviews(String bookingId) {
    return _reviewsCollection
        .where('bookingId', isEqualTo: bookingId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }

  @override
  Stream<List<Review>> watchClientReviews(String clientId) {
    return _reviewsCollection
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }

  @override
  Stream<List<Review>> watchWorkerReviews(String workerId) {
    return _reviewsCollection
        .where('workerId', isEqualTo: workerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }
}
