import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../../domain/usecases/wishlist.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class RemoteWishlistBloc
    extends Bloc<RemoteWishlistEvent, RemoteWishlistState> {
  final WishlistUseCases _wishlistUseCases;

  RemoteWishlistBloc(this._wishlistUseCases)
      : super(const RemoteWishlistInitial()) {
    on<SyncWishlist>(onSyncWishlist);
    on<GetWishlist>(onGetWishlist);
    on<AddItemToWishlist>(onAddItemToWishlist);
    on<UpdateWishlistItem>(onUpdateWishlistItem);
    on<RemoveItemFromWishlist>(onRemoveItemFromWishlist);
    on<ClearWishlist>(onClearWishlist);
  }

  //-----------------------------------------------//
  /// Create Wishlist
  void onSyncWishlist(
      SyncWishlist event, Emitter<RemoteWishlistState> emit) async {
    emit(const RemoteWishlistSyncing());
    final dataState = await _wishlistUseCases.syncWishlist();
    if (dataState is DataSuccess) {
      emit(RemoteWishlistSynced(dataState.data));
    } else if (dataState is DataFailed) {
      emit(RemoteWishlistError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Get Wishlist
  void onGetWishlist(
      GetWishlist event, Emitter<RemoteWishlistState> emit) async {
    emit(const RemoteWishlistLoading());
    final dataState = await _wishlistUseCases.getWishlist();
    if (dataState is DataSuccess) {
      emit(RemoteWishlistLoaded(dataState.data));
    } else if (dataState is DataFailed) {
      emit(RemoteWishlistError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Add Item to Wishlist
  void onAddItemToWishlist(
      AddItemToWishlist event, Emitter<RemoteWishlistState> emit) async {
    emit(const RemoteWishlistAddingItem());
    final dataState =
        await _wishlistUseCases.addItemToWishlist(productId: event.productId);
    if (dataState is DataSuccess) {
      print('resss: ${dataState.data}');
      emit(RemoteWishlistItemAdded(dataState.data, dataState.message));
    } else if (dataState is DataFailed) {
      emit(RemoteWishlistError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Update Wishlist Item
  void onUpdateWishlistItem(
      UpdateWishlistItem event, Emitter<RemoteWishlistState> emit) async {
    emit(const RemoteWishlistUpdatingItem());
    final dataState = await _wishlistUseCases.updateWishlistItem(
        productId: event.productId, quantity: event.quantity);
    if (dataState is DataSuccess) {
      emit(RemoteWishlistItemUpdated(dataState.data, dataState.message));
    } else if (dataState is DataFailed) {
      emit(RemoteWishlistError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Remove Item from Wishlist
  void onRemoveItemFromWishlist(
      RemoveItemFromWishlist event, Emitter<RemoteWishlistState> emit) async {
    emit(const RemoteWishlistRemovingItem());
    final dataState = await _wishlistUseCases.removeItemFromWishlist(
        productId: event.productId, allQuantity: event.allQuantity);
    if (dataState is DataSuccess) {
      emit(RemoteWishlistItemRemoved(dataState.data, dataState.message));
    } else if (dataState is DataFailed) {
      emit(RemoteWishlistError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Clear Wishlist
  void onClearWishlist(
      ClearWishlist event, Emitter<RemoteWishlistState> emit) async {
    emit(const RemoteWishlistClearing());
    final dataState = await _wishlistUseCases.clearWishlist();
    if (dataState is DataSuccess) {
      emit(RemoteWishlistCleared(dataState.message));
    } else if (dataState is DataFailed) {
      emit(RemoteWishlistError(dataState.error));
    }
  }
}
