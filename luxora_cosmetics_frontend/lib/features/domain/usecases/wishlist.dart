import '../../../core/resources/data_state.dart';
import '../../data/models/wishlist_item.dart';
import '../entities/wishlist.dart';
import '../repository/wishlist.dart';

class WishlistUseCases {
  final WishlistRepository repository;

  WishlistUseCases(this.repository);

  /// Sync the wishlist
  Future<DataState<WishlistEntity>> syncWishlist() async {
    return await repository.syncWishlist();
  }

  /// Fetch the user's wishlist
  Future<DataState<WishlistEntity>> getWishlist() async {
    return await repository.getWishlist();
  }

  /// Add a single item to the wishlist
  Future<DataState<WishlistItemModel>> addItemToWishlist({
    required int productId,
  }) async {
    return await repository.addItemToWishlist(
      productId: productId,
    );
  }

  /// Update an item in the wishlist
  Future<DataState<WishlistItemModel>> updateWishlistItem(
      {required int productId, required int quantity}) async {
    return await repository.updateWishlistItem(
        productId: productId, quantity: quantity);
  }

  /// Remove an item from the wishlist
  Future<DataState<WishlistItemModel>> removeItemFromWishlist({
    required int productId,
    bool allQuantity = false,
  }) async {
    return await repository.removeItemFromWishlist(
        productId: productId, allQuantity: allQuantity);
  }

  /// Clear the entire wishlist
  Future<DataState> clearWishlist() async {
    return await repository.clearWishlist();
  }
}
