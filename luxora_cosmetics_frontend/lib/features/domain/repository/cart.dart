import '../../../core/resources/data_state.dart';
import '../../data/models/cart_item.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  //syncData
  Future<DataState<CartEntity>> syncCart();

  // Get the cart
  Future<DataState<CartEntity>> getCart();

  // Add a single item to the cart
  Future<DataState<CartItemModel>> addItemToCart({
    required int productId,
  });

  // Add multiple items to the cart
  Future<DataState<List<CartItemModel>>> addManyItemsToCart({
    required List<int> productIds,
  });

  // Update an item in the cart
  Future<DataState<CartItemModel>> updateCartItem({
    required int productId,
    required int quantity,
  });

  // Remove an item from the cart
  Future<DataState<CartItemModel>> removeItemFromCart(
      {required int productId, bool allQuantity = false});

  // Clear the cart
  Future<DataState> clearCart();
}
