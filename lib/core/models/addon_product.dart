class AddonProduct {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final String category;
  final bool isPopular;

  const AddonProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    this.isPopular = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddonProduct &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class CartAddon {
  final AddonProduct product;
  final int quantity;

  const CartAddon({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartAddon copyWith({
    AddonProduct? product,
    int? quantity,
  }) {
    return CartAddon(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartAddon &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          quantity == other.quantity;

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;
}
