import 'package:injectable/injectable.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Use case for watching cart changes
@injectable
class WatchCartUseCase {
  final CartRepository repository;

  WatchCartUseCase(this.repository);

  Stream<Cart> call() {
    return repository.watchCart();
  }
}
