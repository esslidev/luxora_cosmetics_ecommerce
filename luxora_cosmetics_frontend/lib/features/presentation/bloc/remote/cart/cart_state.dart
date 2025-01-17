import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/models/cart_item.dart';
import '../../../../domain/entities/cart.dart';

abstract class RemoteCartState extends Equatable {
  final CartEntity? cart;
  final CartItemModel? item;
  final List<CartItemModel>? items;
  final String? messageResponse;
  final DioException? error;

  const RemoteCartState({
    this.cart,
    this.item,
    this.items,
    this.messageResponse,
    this.error,
  });

  @override
  List<Object?> get props => [cart, item, messageResponse, error];
}

// ------------- Initial state -------------- //
class RemoteCartInitial extends RemoteCartState {
  const RemoteCartInitial();
}

// ------------- Sync cart items -------------- //
class RemoteCartSyncing extends RemoteCartState {
  const RemoteCartSyncing();
}

class RemoteCartSynced extends RemoteCartState {
  const RemoteCartSynced(CartEntity? cart) : super(cart: cart);
}

// ------------- Loading cart -------------- //
class RemoteCartLoading extends RemoteCartState {
  const RemoteCartLoading();
}

class RemoteCartLoaded extends RemoteCartState {
  const RemoteCartLoaded(CartEntity? cart) : super(cart: cart);
}

// ------------- Adding items to cart -------------- //
class RemoteCartAddingItem extends RemoteCartState {
  const RemoteCartAddingItem();
}

class RemoteCartItemAdded extends RemoteCartState {
  const RemoteCartItemAdded(CartItemModel? item, String? messageResponse)
      : super(item: item, messageResponse: messageResponse);
}

// ------------- Adding multiple items to cart -------------- //
class RemoteCartAddingManyItems extends RemoteCartState {
  const RemoteCartAddingManyItems();
}

class RemoteCartManyItemsAdded extends RemoteCartState {
  const RemoteCartManyItemsAdded(
      List<CartItemModel>? items, String? messageResponse)
      : super(items: items, messageResponse: messageResponse);
}

// ------------- Updating item in cart -------------- //
class RemoteCartUpdatingItem extends RemoteCartState {
  const RemoteCartUpdatingItem();
}

class RemoteCartItemUpdated extends RemoteCartState {
  const RemoteCartItemUpdated(CartItemModel? item, String? messageResponse)
      : super(item: item, messageResponse: messageResponse);
}

// ------------- Removing item from cart -------------- //
class RemoteCartRemovingItem extends RemoteCartState {
  const RemoteCartRemovingItem();
}

class RemoteCartItemRemoved extends RemoteCartState {
  const RemoteCartItemRemoved(CartItemModel? item, String? messageResponse)
      : super(item: item, messageResponse: messageResponse);
}

// ------------- Clearing cart -------------- //
class RemoteCartClearing extends RemoteCartState {
  const RemoteCartClearing();
}

class RemoteCartCleared extends RemoteCartState {
  const RemoteCartCleared(String? messageResponse)
      : super(messageResponse: messageResponse);
}

// ------------- Error state -------------- //
class RemoteCartError extends RemoteCartState {
  const RemoteCartError(DioException? error) : super(error: error);
}
