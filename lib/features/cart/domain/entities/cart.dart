import 'package:equatable/equatable.dart';
import '../../../dashboard/domain/entities/service.dart';
import '../../../car/domain/entities/car.dart';
import '../../../../core/models/time_slot.dart';

/// Represents a single item in the cart - a service-car combination with time slot
class CartItem extends Equatable {
  const CartItem({
    required this.id,
    required this.service,
    required this.car,
    required this.addedAt,
    this.timeSlot,
  });

  /// Unique identifier for this cart item
  final String id;

  /// The service selected for this cart item
  final Service service;

  /// The car selected for this service
  final Car car;

  /// When this item was added to the cart
  final DateTime addedAt;

  /// The selected time slot for this service (optional until booking)
  final TimeSlot? timeSlot;

  /// Calculate the final price using the dynamic pricing service
  /// Note: This getter should ideally receive DynamicPricingService via dependency injection
  /// For now, we'll return the service price as-is and let the UI handle dynamic pricing
  double get finalPrice {
    // This will be calculated by the UI layer using DynamicPricingService
    return service.price;
  }

  /// Get a display string for the service duration
  String get durationString {
    final hours = service.estimatedDurationInMinutes ~/ 60;
    final minutes = service.estimatedDurationInMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  CartItem copyWith({
    String? id,
    Service? service,
    Car? car,
    DateTime? addedAt,
    TimeSlot? timeSlot,
  }) {
    return CartItem(
      id: id ?? this.id,
      service: service ?? this.service,
      car: car ?? this.car,
      addedAt: addedAt ?? this.addedAt,
      timeSlot: timeSlot ?? this.timeSlot,
    );
  }

  @override
  List<Object?> get props => [id, service, car, addedAt, timeSlot];

  /// Convert CartItem to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': service.id,
      'carId': car.id,
      'addedAt': addedAt.toIso8601String(),
      'timeSlot': timeSlot?.toMap(),
    };
  }

  /// Create CartItem from Map (requires service and car to be passed separately)
  static CartItem fromMap(Map<String, dynamic> map, Service service, Car car) {
    return CartItem(
      id: map['id'] as String,
      service: service,
      car: car,
      addedAt: DateTime.parse(map['addedAt'] as String),
      timeSlot: map['timeSlot'] != null
          ? TimeSlot.fromMap(map['timeSlot'])
          : null,
    );
  }
}

/// Represents the complete shopping cart
class Cart extends Equatable {
  const Cart({this.items = const []});

  /// List of items in the cart
  final List<CartItem> items;

  /// Total number of items in the cart
  int get itemCount => items.length;

  /// Total price of all items in the cart
  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.finalPrice);
  }

  /// Total estimated duration of all services
  int get totalDurationInMinutes {
    return items.fold(
      0,
      (sum, item) => sum + item.service.estimatedDurationInMinutes,
    );
  }

  /// Get formatted total duration string
  String get totalDurationString {
    final hours = totalDurationInMinutes ~/ 60;
    final minutes = totalDurationInMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Add an item to the cart
  Cart addItem(CartItem item) {
    final updatedItems = List<CartItem>.from(items)..add(item);
    return Cart(items: updatedItems);
  }

  /// Remove an item from the cart by ID
  Cart removeItem(String itemId) {
    final updatedItems = items.where((item) => item.id != itemId).toList();
    return Cart(items: updatedItems);
  }

  /// Clear all items from the cart
  Cart clear() {
    return const Cart(items: []);
  }

  /// Check if a specific service-car combination already exists
  bool hasServiceCarCombination(String serviceId, String carId) {
    return items.any(
      (item) => item.service.id == serviceId && item.car.id == carId,
    );
  }

  /// Get all unique services in the cart
  List<Service> get uniqueServices {
    final serviceIds = <String>{};
    final services = <Service>[];

    for (final item in items) {
      if (serviceIds.add(item.service.id)) {
        services.add(item.service);
      }
    }

    return services;
  }

  /// Get all unique cars in the cart
  List<Car> get uniqueCars {
    final carIds = <String>{};
    final cars = <Car>[];

    for (final item in items) {
      if (carIds.add(item.car.id)) {
        cars.add(item.car);
      }
    }

    return cars;
  }

  Cart copyWith({List<CartItem>? items}) {
    return Cart(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}

/// Represents a booking entity for storing completed orders
class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.paymentId,
    this.notes,
  });

  /// Unique identifier for this booking
  final String id;

  /// ID of the user who made the booking
  final String userId;

  /// List of cart items in this booking
  final List<CartItem> items;

  /// Total price of the booking
  final double totalPrice;

  /// Current status of the booking
  final BookingStatus status;

  /// When the booking was created
  final DateTime createdAt;

  /// When the booking was completed (if applicable)
  final DateTime? completedAt;

  /// Payment reference ID (for future payment integration)
  final String? paymentId;

  /// Optional notes for the booking
  final String? notes;

  /// Total estimated duration of all services in the booking
  int get totalDurationInMinutes {
    return items.fold(
      0,
      (sum, item) => sum + item.service.estimatedDurationInMinutes,
    );
  }

  /// Get formatted total duration string
  String get totalDurationString {
    final hours = totalDurationInMinutes ~/ 60;
    final minutes = totalDurationInMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  Booking copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? totalPrice,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? paymentId,
    String? notes,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      paymentId: paymentId ?? this.paymentId,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    totalPrice,
    status,
    createdAt,
    completedAt,
    paymentId,
    notes,
  ];

  /// Convert Booking to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'paymentId': paymentId,
      'notes': notes,
    };
  }

  /// Create Booking from Map (requires services and cars to be passed for item reconstruction)
  static Booking fromMap(
    Map<String, dynamic> map,
    List<Service> services,
    List<Car> cars,
  ) {
    final itemMaps = List<Map<String, dynamic>>.from(map['items']);
    final items = <CartItem>[];

    for (final itemMap in itemMaps) {
      final service = services.firstWhere((s) => s.id == itemMap['serviceId']);
      final car = cars.firstWhere((c) => c.id == itemMap['carId']);
      items.add(CartItem.fromMap(itemMap, service, car));
    }

    return Booking(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: items,
      totalPrice: (map['totalPrice'] as num).toDouble(),
      status: BookingStatus.values.firstWhere((s) => s.name == map['status']),
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      paymentId: map['paymentId'] as String?,
      notes: map['notes'] as String?,
    );
  }
}

/// Enum for booking status
enum BookingStatus { pending, confirmed, inProgress, completed, cancelled }

/// Review entity representing a service review and rating
class Review extends Equatable {
  const Review({
    required this.id,
    required this.bookingId,
    required this.clientId,
    required this.workerId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.updatedAt,
    // Booking details for display
    this.serviceName,
    this.serviceDescription,
    // Client details for display
    this.clientName,
    this.clientEmail,
    // Worker details for display
    this.workerName,
  });

  final String id;
  final String bookingId;
  final String clientId;
  final String workerId;
  final int rating; // 1-5 stars
  final String? comment;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Booking details for display
  final String? serviceName;
  final String? serviceDescription;

  // Client details for display
  final String? clientName;
  final String? clientEmail;

  // Worker details for display
  final String? workerName;

  /// Check if review has a comment
  bool get hasComment => comment != null && comment!.isNotEmpty;

  /// Get star rating as a double for display
  double get ratingAsDouble => rating.toDouble();

  /// Get rating description
  String get ratingDescription {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Unknown';
    }
  }

  /// Get formatted date
  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// Check if rating is valid (1-5)
  bool get isValidRating => rating >= 1 && rating <= 5;

  /// Create a copy with updated fields
  Review copyWith({
    String? id,
    String? bookingId,
    String? clientId,
    String? workerId,
    int? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? serviceName,
    String? serviceDescription,
    String? clientName,
    String? clientEmail,
    String? workerName,
  }) {
    return Review(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      clientId: clientId ?? this.clientId,
      workerId: workerId ?? this.workerId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serviceName: serviceName ?? this.serviceName,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      workerName: workerName ?? this.workerName,
    );
  }

  /// Convert Review to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'clientId': clientId,
      'workerId': workerId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'serviceName': serviceName,
      'serviceDescription': serviceDescription,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'workerName': workerName,
    };
  }

  /// Create Review from Map
  static Review fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      bookingId: map['bookingId'] as String,
      clientId: map['clientId'] as String,
      workerId: map['workerId'] as String,
      rating: map['rating'] as int,
      comment: map['comment'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      serviceName: map['serviceName'] as String?,
      serviceDescription: map['serviceDescription'] as String?,
      clientName: map['clientName'] as String?,
      clientEmail: map['clientEmail'] as String?,
      workerName: map['workerName'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    bookingId,
    clientId,
    workerId,
    rating,
    comment,
    createdAt,
    updatedAt,
    serviceName,
    serviceDescription,
    clientName,
    clientEmail,
    workerName,
  ];
}
