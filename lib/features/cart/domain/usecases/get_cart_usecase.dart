import 'package:injectable/injectable.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Use case for getting cart items
@injectable
class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<Cart> call() async {
    return await repository.getCart();
  }
}
