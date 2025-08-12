import 'package:injectable/injectable.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Use case for adding an item to the cart
@injectable
class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call(CartItem item) async {
    await repository.addItem(item);
  }
}
