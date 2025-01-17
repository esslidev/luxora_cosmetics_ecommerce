import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/models/wishlist_item.dart';
import '../../../../domain/entities/wishlist.dart';

abstract class RemoteWishlistState extends Equatable {
  final WishlistEntity? wishlist;
  final WishlistItemModel? item;
  final String? messageResponse;
  final DioException? error;

  const RemoteWishlistState({
    this.wishlist,
    this.item,
    this.messageResponse,
    this.error,
  });

  @override
  List<Object?> get props => [wishlist, item, messageResponse, error];
}

// ------------- Initial state -------------- //
class RemoteWishlistInitial extends RemoteWishlistState {
  const RemoteWishlistInitial();
}

// ------------- Sync wishlist items -------------- //
class RemoteWishlistSyncing extends RemoteWishlistState {
  const RemoteWishlistSyncing();
}

class RemoteWishlistSynced extends RemoteWishlistState {
  const RemoteWishlistSynced(WishlistEntity? wishlist)
      : super(wishlist: wishlist);
}

// ------------- Loading wishlist -------------- //
class RemoteWishlistLoading extends RemoteWishlistState {
  const RemoteWishlistLoading();
}

class RemoteWishlistLoaded extends RemoteWishlistState {
  const RemoteWishlistLoaded(WishlistEntity? wishlist)
      : super(wishlist: wishlist);
}

// ------------- Adding items to wishlist -------------- //
class RemoteWishlistAddingItem extends RemoteWishlistState {
  const RemoteWishlistAddingItem();
}

class RemoteWishlistItemAdded extends RemoteWishlistState {
  const RemoteWishlistItemAdded(
      WishlistItemModel? item, String? messageResponse)
      : super(item: item, messageResponse: messageResponse);
}

// ------------- Updating item in wishlist -------------- //
class RemoteWishlistUpdatingItem extends RemoteWishlistState {
  const RemoteWishlistUpdatingItem();
}

class RemoteWishlistItemUpdated extends RemoteWishlistState {
  const RemoteWishlistItemUpdated(
      WishlistItemModel? item, String? messageResponse)
      : super(item: item, messageResponse: messageResponse);
}

// ------------- Removing item from wishlist -------------- //
class RemoteWishlistRemovingItem extends RemoteWishlistState {
  const RemoteWishlistRemovingItem();
}

class RemoteWishlistItemRemoved extends RemoteWishlistState {
  const RemoteWishlistItemRemoved(
      WishlistItemModel? item, String? messageResponse)
      : super(item: item, messageResponse: messageResponse);
}

// ------------- Clearing wishlist -------------- //
class RemoteWishlistClearing extends RemoteWishlistState {
  const RemoteWishlistClearing();
}

class RemoteWishlistCleared extends RemoteWishlistState {
  const RemoteWishlistCleared(String? messageResponse)
      : super(messageResponse: messageResponse);
}

// ------------- Error state -------------- //
class RemoteWishlistError extends RemoteWishlistState {
  const RemoteWishlistError(DioException? error) : super(error: error);
}
