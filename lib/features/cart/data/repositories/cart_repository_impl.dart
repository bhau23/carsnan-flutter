import 'package:injectable/injectable.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';

@Injectable(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource dataSource;

  CartRepositoryImpl({required this.dataSource});

  @override
  Future<Cart> getCart() async {
    return await dataSource.getCart();
  }

  @override
  Future<void> addItem(CartItem item) async {
    await dataSource.addItem(item);
  }

  @override
  Future<void> removeItem(String itemId) async {
    await dataSource.removeItem(itemId);
  }

  @override
  Future<void> clearCart() async {
    await dataSource.clearCart();
  }

  @override
  Future<int> getItemCount() async {
    final cart = await dataSource.getCart();
    return cart.itemCount;
  }

  @override
  Future<bool> hasItems() async {
    final cart = await dataSource.getCart();
    return cart.isNotEmpty;
  }

  @override
  Stream<Cart> watchCart() {
    return dataSource.watchCart();
  }
}
