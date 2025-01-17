import '../../../core/resources/data_state.dart';
import '../../data/models/wishlist_item.dart';
import '../entities/wishlist.dart';

abstract class WishlistRepository {
  //syncData
  Future<DataState<WishlistEntity>> syncWishlist();

  // Get the wishlist
  Future<DataState<WishlistEntity>> getWishlist();

  // Add a single item to the wishlist
  Future<DataState<WishlistItemModel>> addItemToWishlist({
    required int productId,
  });

  // Update an item in the wishlist
  Future<DataState<WishlistItemModel>> updateWishlistItem(
      {required int productId, required int quantity});

  // Remove an item from the wishlist
  Future<DataState<WishlistItemModel>> removeItemFromWishlist(
      {required int productId, bool allQuantity = false});

  // Clear the wishlist
  Future<DataState> clearWishlist();
}
