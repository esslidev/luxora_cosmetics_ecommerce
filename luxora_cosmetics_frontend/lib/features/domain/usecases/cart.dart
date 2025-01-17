import '../../../core/resources/data_state.dart';
import '../../data/models/cart_item.dart';
import '../entities/cart.dart';
import '../repository/cart.dart';

class CartUseCases {
  final CartRepository repository;

  CartUseCases(this.repository);

  /// Sync the cart
  Future<DataState<CartEntity>> syncCart() async {
    return await repository.syncCart();
  }

  /// Fetch the user's cart
  Future<DataState<CartEntity>> getCart() async {
    return await repository.getCart();
  }

  /// Add a single item to the cart
  Future<DataState<CartItemModel>> addItemToCart({
    required int productId,
  }) async {
    return await repository.addItemToCart(
      productId: productId,
    );
  }

  /// Add multiple items to the cart
  Future<DataState<List<CartItemModel>>> addManyItemsToCart({
    required List<int> productIds,
  }) async {
    return await repository.addManyItemsToCart(
      productIds: productIds,
    );
  }

  /// Update an item in the cart
  Future<DataState<CartItemModel>> updateCartItem(
      {required int productId, required int quantity}) async {
    return await repository.updateCartItem(
        productId: productId, quantity: quantity);
  }

  /// Remove an item from the cart
  Future<DataState<CartItemModel>> removeItemFromCart({
    required int productId,
    bool allQuantity = false,
  }) async {
    return await repository.removeItemFromCart(
        productId: productId, allQuantity: allQuantity);
  }

  /// Clear the entire cart
  Future<DataState> clearCart() async {
    return await repository.clearCart();
  }
}
