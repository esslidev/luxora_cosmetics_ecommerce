abstract class RemoteWishlistEvent {
  const RemoteWishlistEvent();
}

//-----------------------------------------------//
// Transport wishlist items
class SyncWishlist extends RemoteWishlistEvent {
  const SyncWishlist();
}

//-----------------------------------------------//
// Fetch the current user's wishlist
class GetWishlist extends RemoteWishlistEvent {
  const GetWishlist();
}

//-----------------------------------------------//
// Add a single item to the wishlist
class AddItemToWishlist extends RemoteWishlistEvent {
  final int productId;

  const AddItemToWishlist({required this.productId});
}

//-----------------------------------------------//
// Update a specific item in the wishlist
class UpdateWishlistItem extends RemoteWishlistEvent {
  final int productId;
  final int quantity;

  const UpdateWishlistItem({required this.productId, required this.quantity});
}

//-----------------------------------------------//
// Remove an item from the wishlist
class RemoveItemFromWishlist extends RemoteWishlistEvent {
  final int productId;
  final bool allQuantity;

  const RemoveItemFromWishlist(
      {required this.productId, this.allQuantity = false});
}

//-----------------------------------------------//
// Clear all items from the wishlist
class ClearWishlist extends RemoteWishlistEvent {
  const ClearWishlist();
}
