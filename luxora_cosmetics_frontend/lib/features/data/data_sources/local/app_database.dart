// required package imports
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/wishlist_item.dart';
import 'daos/cart_dao.dart';
import 'daos/wishlist_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [WishlistItemEntity, CartItemEntity])
abstract class AppDatabase extends FloorDatabase {
  WishlistDao get wishlistDao;
  CartDao get cartDao;
}
