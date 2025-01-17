import '../../../domain/entities/cart.dart';

import '../../../domain/entities/cart_item.dart';
import '../../models/cart_item.dart';
import '../../models/data_response.dart';
import 'daos/cart_dao.dart';

class CartLocalDataSource {
  final CartDao cartDao;

  CartLocalDataSource(this.cartDao);

  // Fetch all items in the cart
  Future<DataResponse<CartEntity>> getCart() async {
    try {
      var cartItems = await cartDao.getCartItems();

      // Convert CartItemEntity list to CartItemModel list
      var cartItemModels = cartItems
          ?.map((item) => CartItemModel(
                id: item.id,
                cartId: item.cartId,
                productId: item.productId,
                quantity: item.quantity,
              ))
          .toList();

      var cart = CartEntity(
        id: -1, // Assuming you don't need the cart id here; adjust accordingly
        items: cartItemModels,
      );

      return DataResponse(data: cart);
    } catch (e) {
      throw 'Error fetching cart';
    }
  }

  // Add item to the cart
  Future<DataResponse<CartItemModel>> addItemToCart(
      {required int productId}) async {
    try {
      final existingItem = await cartDao.getCartItemByProductId(productId);

      if (existingItem != null) {
        await cartDao.incrementCartItemQuantityByProductId(productId, 1);
      } else {
        final newItem = CartItemEntity(
          productId: productId,
          quantity: 1,
        );
        await cartDao.insertCartItem(newItem);
      }
      final updatedItem = await cartDao.getCartItemByProductId(productId);
      return DataResponse(
          message: 'The item was added successfully to the cart',
          data: CartItemModel(
            id: updatedItem?.id,
            cartId: updatedItem?.cartId,
            productId: updatedItem?.productId,
            quantity: updatedItem?.quantity,
          ));
    } catch (e) {
      throw 'Failed to add the item to the cart';
    }
  }

  Future<DataResponse<List<CartItemModel>>> addManyItemsToCart({
    required List<int> productIds,
  }) async {
    if (productIds.isEmpty) {
      throw 'Invalid parameters';
    }

    try {
      // List to store all cart items after processing
      final List<CartItemModel> cartItems = [];

      for (var productId in productIds) {
        // Check if the item already exists in the cart
        final existingItem = await cartDao.getCartItemByProductId(productId);

        if (existingItem != null) {
          // If the item exists, increment its quantity
          await cartDao.incrementCartItemQuantityByProductId(productId, 1);

          // Fetch the updated item
          final updatedItem = await cartDao.getCartItemByProductId(productId);

          if (updatedItem != null) {
            cartItems.add(CartItemModel(
              id: updatedItem.id,
              cartId: updatedItem.cartId,
              productId: updatedItem.productId,
              quantity: updatedItem.quantity,
            ));
          }
        } else {
          // If the item does not exist, create a new item with quantity 1
          final newItem = CartItemEntity(
            productId: productId,
            quantity: 1,
          );
          await cartDao.insertCartItem(newItem);

          cartItems.add(CartItemModel(
            productId: productId,
            quantity: 1,
          ));
        }
      }

      // Return all processed cart items
      return DataResponse(
        message: 'The items were added successfully to the cart',
        data: cartItems,
      );
    } catch (e) {
      throw 'Failed to add the items to the cart';
    }
  }

  Future<DataResponse<CartItemModel>> updateCartItem({
    required int productId,
    required int quantity,
  }) async {
    try {
      // Fetch the existing item by productId
      final existingItem = await cartDao.getCartItemByProductId(productId);

      if (existingItem != null) {
        // Update the item's quantity
        await cartDao.updateCartItemQuantityByProductId(
          productId,
          quantity,
        );

        // Fetch the updated item
        final updatedItem = await cartDao.getCartItemByProductId(productId);

        return DataResponse(
          message: 'Cart item was updated successfully',
          data: CartItemModel(
            id: updatedItem?.id,
            cartId: updatedItem?.cartId,
            productId: updatedItem?.productId,
            quantity: updatedItem?.quantity,
          ),
        );
      } else {
        throw 'The item was not found in the cart';
      }
    } catch (e) {
      throw 'Failed to update the item in the cart';
    }
  }

  Future<DataResponse<CartItemModel>> removeItemFromCart({
    required int productId,
    bool allQuantity = false,
  }) async {
    try {
      // Fetch the existing item by productId
      final existingItem = await cartDao.getCartItemByProductId(productId);

      if (existingItem == null) {
        throw 'The item was not found in the cart';
      }

      String message;

      if (allQuantity || existingItem.quantity! <= 1) {
        // Remove the item completely if allQuantity is true or quantity <= 1
        await cartDao.deleteCartItemByProductId(productId);
        message = 'The item was removed successfully';
      } else {
        // Reduce quantity by one if allQuantity is false and quantity > 1
        await cartDao.decrementCartItemQuantityByProductId(productId, 1);
        message = 'The item quantity was decremented successfully';
      }

      // Fetch updated or removed item details
      final updatedItem = await cartDao.getCartItemByProductId(productId);

      return DataResponse(
        data: CartItemModel(
          id: existingItem.id,
          cartId: existingItem.cartId,
          productId: existingItem.productId,
          quantity:
              updatedItem?.quantity ?? 0, // Return 0 if the item is deleted
        ),
        message: message,
      );
    } catch (e) {
      throw 'Failed to remove the item from the cart';
    }
  }

  Future<DataResponse> clearCart() async {
    try {
      await cartDao.clearCartItems();
      return DataResponse(message: 'The cart was cleared successfully');
    } catch (e) {
      throw 'Failed to clear the cart';
    }
  }
}
