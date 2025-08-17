import 'package:equatable/equatable.dart';
import '../../../dashboard/domain/entities/service.dart';
import '../../../car/domain/entities/car.dart';

/// Represents a single item in the cart - a service-car combination
class CartItem extends Equatable {
  const CartItem({
    required this.id,
    required this.service,
    required this.car,
    required this.addedAt,
  });

  /// Unique identifier for this cart item
  final String id;

  /// The service selected for this cart item
  final Service service;

  /// The car selected for this service
  final Car car;

  /// When this item was added to the cart
  final DateTime addedAt;

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
  }) {
    return CartItem(
      id: id ?? this.id,
      service: service ?? this.service,
      car: car ?? this.car,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  List<Object?> get props => [id, service, car, addedAt];

  /// Convert CartItem to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': service.id,
      'carId': car.id,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create CartItem from Map (requires service and car to be passed separately)
  static CartItem fromMap(Map<String, dynamic> map, Service service, Car car) {
    return CartItem(
      id: map['id'] as String,
      service: service,
      car: car,
      addedAt: DateTime.parse(map['addedAt'] as String),
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
