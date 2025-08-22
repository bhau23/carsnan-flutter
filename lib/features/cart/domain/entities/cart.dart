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
