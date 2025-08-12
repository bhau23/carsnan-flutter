import 'package:injectable/injectable.dart';
import '../repositories/cart_repository.dart';

/// Use case for removing an item from the cart
@injectable
class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<void> call(String itemId) async {
    await repository.removeItem(itemId);
  }
}
