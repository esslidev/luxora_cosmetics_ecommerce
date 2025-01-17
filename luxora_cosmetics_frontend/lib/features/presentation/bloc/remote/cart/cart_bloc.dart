import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../../domain/usecases/cart.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class RemoteCartBloc extends Bloc<RemoteCartEvent, RemoteCartState> {
  final CartUseCases _cartUseCases;

  RemoteCartBloc(this._cartUseCases) : super(const RemoteCartInitial()) {
    on<SyncCart>(onSyncCart);
    on<GetCart>(onGetCart);
    on<AddItemToCart>(onAddItemToCart);
    on<AddManyItemsToCart>(onAddManyItemsToCart);
    on<UpdateCartItem>(onUpdateCartItem);
    on<RemoveItemFromCart>(onRemoveItemFromCart);
    on<ClearCart>(onClearCart);
  }

  //-----------------------------------------------//
  /// sync Cart
  void onSyncCart(SyncCart event, Emitter<RemoteCartState> emit) async {
    emit(const RemoteCartSyncing());
    final dataState = await _cartUseCases.syncCart();
    if (dataState is DataSuccess) {
      emit(RemoteCartSynced(dataState.data));
    } else if (dataState is DataFailed) {
      emit(RemoteCartError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Get Cart
  void onGetCart(GetCart event, Emitter<RemoteCartState> emit) async {
    emit(const RemoteCartLoading());
    final dataState = await _cartUseCases.getCart();
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteCartLoaded(dataState.data));
    } else if (dataState is DataFailed) {
      emit(RemoteCartError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Add Item to Cart
  void onAddItemToCart(
      AddItemToCart event, Emitter<RemoteCartState> emit) async {
    emit(const RemoteCartAddingItem());
    final dataState =
        await _cartUseCases.addItemToCart(productId: event.productId);
    if (dataState is DataSuccess) {
      emit(RemoteCartItemAdded(dataState.data, dataState.message));
    } else if (dataState is DataFailed) {
      emit(RemoteCartError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Add Many Items to Cart
  void onAddManyItemsToCart(
      AddManyItemsToCart event, Emitter<RemoteCartState> emit) async {
    emit(const RemoteCartAddingManyItems());
    final dataState =
        await _cartUseCases.addManyItemsToCart(productIds: event.productIds);
    if (dataState is DataSuccess) {
      emit(RemoteCartManyItemsAdded(dataState.data, dataState.message));
    } else if (dataState is DataFailed) {
      emit(RemoteCartError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Update Cart Item
  void onUpdateCartItem(
      UpdateCartItem event, Emitter<RemoteCartState> emit) async {
    emit(const RemoteCartUpdatingItem());
    final dataState = await _cartUseCases.updateCartItem(
        productId: event.productId, quantity: event.quantity);
    if (dataState is DataSuccess) {
      emit(RemoteCartItemUpdated(dataState.data, dataState.message));
    } else if (dataState is DataFailed) {
      emit(RemoteCartError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Remove Item from Cart
  void onRemoveItemFromCart(
      RemoveItemFromCart event, Emitter<RemoteCartState> emit) async {
    emit(const RemoteCartRemovingItem());
    final dataState = await _cartUseCases.removeItemFromCart(
        productId: event.productId, allQuantity: event.allQuantity);
    if (dataState is DataSuccess) {
      emit(RemoteCartItemRemoved(dataState.data, dataState.message));
    } else if (dataState is DataFailed) {
      emit(RemoteCartError(dataState.error));
    }
  }

  //-----------------------------------------------//
  /// Clear Cart
  void onClearCart(ClearCart event, Emitter<RemoteCartState> emit) async {
    emit(const RemoteCartClearing());
    final dataState = await _cartUseCases.clearCart();
    if (dataState is DataSuccess) {
      emit(RemoteCartCleared(dataState.message));
    } else if (dataState is DataFailed) {
      emit(RemoteCartError(dataState.error));
    }
  }
}
