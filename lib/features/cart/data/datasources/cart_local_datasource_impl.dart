import 'dart:async';
import 'package:injectable/injectable.dart';
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
