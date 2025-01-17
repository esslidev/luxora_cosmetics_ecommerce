// data/database/wishlist_dao.dart
import 'package:floor/floor.dart';

import '../../../../domain/entities/wishlist_item.dart';

@dao
abstract class WishlistDao {
  // Find a WishlistItem by wishlistId and productId
  @Query(
    'SELECT * FROM wishlist_item',
  )
  Future<List<WishlistItemEntity>?> getWishlistItems();

  // Find a WishlistItem by wishlistId and productId
  @Query(
    'SELECT * FROM wishlist_item WHERE productId = :productId LIMIT 1',
  )
  Future<WishlistItemEntity?> getWishlistItemByProductId(
    int productId,
  );

  // Update the quantity of an existing item
  @Query('''
  UPDATE wishlist_item 
  SET quantity = :newQuantity 
  WHERE productId = :productId
  ''')
  Future<void> updateWishlistItemQuantityByProductId(
    int productId,
    int newQuantity,
  );

  // Increment the quantity of an existing item
  @Query('''
  UPDATE wishlist_item 
  SET quantity = quantity + :incrementValue 
  WHERE productId = :productId
  ''')
  Future<void> incrementWishlistItemQuantityByProductId(
    int productId,
    int incrementValue,
  );

  // Increment the quantity of an existing item
  @Query('''
  UPDATE wishlist_item 
  SET quantity = quantity - :decrementValue 
  WHERE productId = :productId
  ''')
  Future<void> decrementWishlistItemQuantityByProductId(
    int productId,
    int decrementValue,
  );

  // Insert a new WishlistItem
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertWishlistItem(WishlistItemEntity wishlistItem);

  @Query('DELETE FROM wishlist_item WHERE productId = :productId')
  Future<void> deleteWishlistItemByProductId(int productId);

  @Query('DELETE FROM wishlist_item')
  Future<void> clearWishlistItems();
}
