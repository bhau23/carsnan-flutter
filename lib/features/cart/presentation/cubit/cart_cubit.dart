import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/cart.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/watch_cart_usecase.dart';
import '../../../dashboard/domain/entities/service.dart';
import '../../../car/domain/entities/car.dart';
import 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  final AddToCartUseCase addToCartUseCase;
  final GetCartUseCase getCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final WatchCartUseCase watchCartUseCase;

  StreamSubscription<Cart>? _cartSubscription;

  CartCubit({
    required this.addToCartUseCase,
    required this.getCartUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
    required this.watchCartUseCase,
  }) : super(const CartState()) {
    _startWatchingCart();
  }

  /// Start watching cart changes
  void _startWatchingCart() {
    _cartSubscription = watchCartUseCase().listen(
      (cart) {
        emit(state.copyWith(cart: cart, isLoading: false, error: null));
      },
      onError: (error) {
        emit(state.copyWith(error: error.toString(), isLoading: false));
      },
    );
  }

  /// Load cart items
  Future<void> loadCart() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final cart = await getCartUseCase();
      emit(state.copyWith(cart: cart, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Add service+car combination to cart
  Future<void> addToCart({required Service service, required Car car}) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Create cart item
      final cartItem = CartItem(
        id: '${service.id}_${car.id}_${DateTime.now().millisecondsSinceEpoch}',
        service: service,
        car: car,
        addedAt: DateTime.now(),
      );

      await addToCartUseCase(cartItem);
      // State will be updated through the stream subscription
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await removeFromCartUseCase(itemId);
      // State will be updated through the stream subscription
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await clearCartUseCase();
      // State will be updated through the stream subscription
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Check if service+car combination exists in cart
  bool isServiceCarInCart(String serviceId, String carId) {
    return state.cart.hasServiceCarCombination(serviceId, carId);
  }

  /// Get cart item for service+car combination
  CartItem? getCartItemForServiceCar(String serviceId, String carId) {
    try {
      return state.cart.items.firstWhere(
        (item) => item.service.id == serviceId && item.car.id == carId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
