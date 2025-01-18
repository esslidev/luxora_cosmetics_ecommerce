import '../../../domain/entities/wishlist.dart';
import '../../../domain/entities/wishlist_item.dart';
import '../../models/data_response.dart';
import '../../models/wishlist_item.dart';
import 'daos/wishlist_dao.dart';

class WishlistLocalDataSource {
  final WishlistDao wishlistDao;

  WishlistLocalDataSource(this.wishlistDao);

  Future<DataResponse<WishlistEntity>> getWishlist() async {
    try {
      var wishlistItems = await wishlistDao.getWishlistItems();
      // Convert WishlistItemEntity list to WishlistItemModel list
      var wishlistItemModels = wishlistItems
          ?.map((item) => WishlistItemModel(
                id: item.id,
                wishlistId: item.wishlistId,
                productId: item.productId,
                quantity: item.quantity,
              ))
          .toList();

      var wishlist = WishlistEntity(
        id: -1,
        items: wishlistItemModels,
      );

      return DataResponse(data: wishlist);
    } catch (e) {
      throw 'Error fetching wishlist';
    }
  }

  Future<DataResponse<WishlistItemModel>> addItemToWishlist(
      {required int productId}) async {
    try {
      final existingItem =
          await wishlistDao.getWishlistItemByProductId(productId);

      if (existingItem != null) {
        await wishlistDao.incrementWishlistItemQuantityByProductId(
            productId, 1);
      } else {
        final newItem = WishlistItemEntity(
          productId: productId,
          quantity: 1,
        );
        await wishlistDao.insertWishlistItem(newItem);
      }
      final updatedItem =
          await wishlistDao.getWishlistItemByProductId(productId);
      return DataResponse(
          message:
              'Le produit a été ajouté avec succès à la liste de souhaits.',
          data: WishlistItemModel(
            id: updatedItem?.id,
            wishlistId: updatedItem?.wishlistId,
            productId: updatedItem?.productId,
            quantity: updatedItem?.quantity,
          ));
    } catch (e) {
      throw 'Échec de l\'ajout du produit à la liste de souhaits. $e';
    }
  }

  Future<DataResponse<WishlistItemModel>> updateWishlistItem({
    required int productId,
    required int quantity,
  }) async {
    try {
      // Fetch the existing item by productId
      final existingItem =
          await wishlistDao.getWishlistItemByProductId(productId);

      if (existingItem != null) {
        // Update the item's quantity
        await wishlistDao.updateWishlistItemQuantityByProductId(
          productId,
          quantity,
        );

        // Fetch the updated item
        final updatedItem =
            await wishlistDao.getWishlistItemByProductId(productId);

        return DataResponse(
          message: 'Wishlist item was updated successfully',
          data: WishlistItemModel(
            id: updatedItem?.id,
            wishlistId: updatedItem?.wishlistId,
            productId: updatedItem?.productId,
            quantity: updatedItem?.quantity,
          ),
        );
      } else {
        throw 'The item was not found in the wishlist';
      }
    } catch (e) {
      throw 'Failed to update the item in the wishlist';
    }
  }

  Future<DataResponse<WishlistItemModel>> removeItemFromWishlist({
    required int productId,
    bool allQuantity = false,
  }) async {
    try {
      // Fetch the existing item by productId
      final existingItem =
          await wishlistDao.getWishlistItemByProductId(productId);

      if (existingItem == null) {
        throw 'The item was not found in the wishlist';
      }

      String message;

      if (allQuantity || existingItem.quantity! <= 1) {
        // Remove the item completely if allQuantity is true or quantity <= 1
        await wishlistDao.deleteWishlistItemByProductId(productId);
        message = 'The item was removed successfully';
      } else {
        // Reduce quantity by one if allQuantity is false and quantity > 1
        await wishlistDao.decrementWishlistItemQuantityByProductId(
            productId, 1);
        message = 'The item quantity was decremented successfully';
      }

      // Fetch updated or removed item details
      final updatedItem =
          await wishlistDao.getWishlistItemByProductId(productId);

      return DataResponse(
        data: WishlistItemModel(
          id: existingItem.id,
          wishlistId: existingItem.wishlistId,
          productId: existingItem.productId,
          quantity:
              updatedItem?.quantity ?? 0, // Return 0 if the item is deleted
        ),
        message: message,
      );
    } catch (e) {
      throw 'Failed to remove the item from the wishlist';
    }
  }

  /// Clears all items from the wishlist.
  Future<DataResponse> clearWishlist() async {
    try {
      await wishlistDao.clearWishlistItems();
      return DataResponse(message: 'Wishlist was cleared successfully');
    } catch (e) {
      throw 'Failed to clear the wishlist';
    }
  }
}
