abstract class RemoteCartEvent {
  const RemoteCartEvent();
}

//-----------------------------------------------//
// Transport wishlist items
class SyncCart extends RemoteCartEvent {
  const SyncCart();
}

//-----------------------------------------------//
// Fetch the current user's cart
class GetCart extends RemoteCartEvent {
  const GetCart();
}

//-----------------------------------------------//
// Add a single item to the cart
class AddItemToCart extends RemoteCartEvent {
  final int productId;

  const AddItemToCart({required this.productId});
}

//-----------------------------------------------//
// Add multiple items to the cart
class AddManyItemsToCart extends RemoteCartEvent {
  final List<int> productIds;

  const AddManyItemsToCart({required this.productIds});
}

//-----------------------------------------------//
// Update a specific item in the cart
class UpdateCartItem extends RemoteCartEvent {
  final int productId;
  final int quantity;

  const UpdateCartItem({required this.productId, required this.quantity});
}

//-----------------------------------------------//
// Remove an item from the cart
class RemoveItemFromCart extends RemoteCartEvent {
  final int productId;
  final bool allQuantity;

  const RemoveItemFromCart({required this.productId, this.allQuantity = false});
}

//-----------------------------------------------//
// Clear all items from the cart
class ClearCart extends RemoteCartEvent {
  const ClearCart();
}
