// data/database/cart.dart
import 'package:floor/floor.dart';

import '../../../../domain/entities/cart_item.dart';

@dao
abstract class CartDao {
  @Query(
    'SELECT * FROM cart_item',
  )
  Future<List<CartItemEntity>?> getCartItems();

  // Find a CartItem by CartId and productId
  @Query(
    'SELECT * FROM cart_item WHERE productId = :productId LIMIT 1',
  )
  Future<CartItemEntity?> getCartItemByProductId(
    int productId,
  );

  // Update the quantity of an existing item
  @Query('''
  UPDATE cart_item 
  SET quantity = :newQuantity 
  WHERE productId = :productId 
  ''')
  Future<void> updateCartItemQuantityByProductId(
    int productId,
    int newQuantity,
  );

  // Increment the quantity of an existing item
  @Query('''
  UPDATE cart_item 
  SET quantity = quantity + :incrementValue 
  WHERE productId = :productId
  ''')
  Future<void> incrementCartItemQuantityByProductId(
    int productId,
    int incrementValue,
  );

  // Increment the quantity of an existing item
  @Query('''
  UPDATE cart_item 
  SET quantity = quantity - :decrementValue 
  WHERE productId = :productId
  ''')
  Future<void> decrementCartItemQuantityByProductId(
    int productId,
    int decrementValue,
  );

  // Insert a new CartItem
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertCartItem(CartItemEntity cartItem);

  // Bulk insert many items into the cart
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertCartItems(List<CartItemEntity> cartItems);

  @Query('DELETE FROM cart_item WHERE productId = :productId ')
  Future<void> deleteCartItemByProductId(int productId);

  @Query('DELETE FROM cart_item')
  Future<void> clearCartItems();
}
