import 'package:injectable/injectable.dart';
import '../repositories/cart_repository.dart';

/// Use case for clearing the entire cart
@injectable
class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<void> call() async {
    await repository.clearCart();
  }
}
