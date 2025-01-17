// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WishlistDao? _wishlistDaoInstance;

  CartDao? _cartDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `wishlist_item` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `wishlistId` INTEGER, `productId` INTEGER, `quantity` INTEGER, `createdAt` TEXT, `updatedAt` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `cart_item` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `cartId` INTEGER, `productId` INTEGER, `quantity` INTEGER, `createdAt` TEXT, `updatedAt` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WishlistDao get wishlistDao {
    return _wishlistDaoInstance ??= _$WishlistDao(database, changeListener);
  }

  @override
  CartDao get cartDao {
    return _cartDaoInstance ??= _$CartDao(database, changeListener);
  }
}

class _$WishlistDao extends WishlistDao {
  _$WishlistDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _wishlistItemEntityInsertionAdapter = InsertionAdapter(
            database,
            'wishlist_item',
            (WishlistItemEntity item) => <String, Object?>{
                  'id': item.id,
                  'wishlistId': item.wishlistId,
                  'productId': item.productId,
                  'quantity': item.quantity,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WishlistItemEntity>
      _wishlistItemEntityInsertionAdapter;

  @override
  Future<List<WishlistItemEntity>?> getWishlistItems() async {
    return _queryAdapter.queryList('SELECT * FROM wishlist_item',
        mapper: (Map<String, Object?> row) => WishlistItemEntity(
            id: row['id'] as int?,
            wishlistId: row['wishlistId'] as int?,
            productId: row['productId'] as int?,
            quantity: row['quantity'] as int?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?));
  }

  @override
  Future<WishlistItemEntity?> getWishlistItemByProductId(int productId) async {
    return _queryAdapter.query(
        'SELECT * FROM wishlist_item WHERE productId = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => WishlistItemEntity(
            id: row['id'] as int?,
            wishlistId: row['wishlistId'] as int?,
            productId: row['productId'] as int?,
            quantity: row['quantity'] as int?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?),
        arguments: [productId]);
  }

  @override
  Future<void> updateWishlistItemQuantityByProductId(
    int productId,
    int newQuantity,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE wishlist_item    SET quantity = ?2    WHERE productId = ?1',
        arguments: [productId, newQuantity]);
  }

  @override
  Future<void> incrementWishlistItemQuantityByProductId(
    int productId,
    int incrementValue,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE wishlist_item    SET quantity = quantity + ?2    WHERE productId = ?1',
        arguments: [productId, incrementValue]);
  }

  @override
  Future<void> decrementWishlistItemQuantityByProductId(
    int productId,
    int decrementValue,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE wishlist_item    SET quantity = quantity - ?2    WHERE productId = ?1',
        arguments: [productId, decrementValue]);
  }

  @override
  Future<void> deleteWishlistItemByProductId(int productId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM wishlist_item WHERE productId = ?1',
        arguments: [productId]);
  }

  @override
  Future<void> clearWishlistItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM wishlist_item');
  }

  @override
  Future<void> insertWishlistItem(WishlistItemEntity wishlistItem) async {
    await _wishlistItemEntityInsertionAdapter.insert(
        wishlistItem, OnConflictStrategy.ignore);
  }
}

class _$CartDao extends CartDao {
  _$CartDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _cartItemEntityInsertionAdapter = InsertionAdapter(
            database,
            'cart_item',
            (CartItemEntity item) => <String, Object?>{
                  'id': item.id,
                  'cartId': item.cartId,
                  'productId': item.productId,
                  'quantity': item.quantity,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CartItemEntity> _cartItemEntityInsertionAdapter;

  @override
  Future<List<CartItemEntity>?> getCartItems() async {
    return _queryAdapter.queryList('SELECT * FROM cart_item',
        mapper: (Map<String, Object?> row) => CartItemEntity(
            id: row['id'] as int?,
            cartId: row['cartId'] as int?,
            productId: row['productId'] as int?,
            quantity: row['quantity'] as int?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?));
  }

  @override
  Future<CartItemEntity?> getCartItemByProductId(int productId) async {
    return _queryAdapter.query(
        'SELECT * FROM cart_item WHERE productId = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => CartItemEntity(
            id: row['id'] as int?,
            cartId: row['cartId'] as int?,
            productId: row['productId'] as int?,
            quantity: row['quantity'] as int?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?),
        arguments: [productId]);
  }

  @override
  Future<void> updateCartItemQuantityByProductId(
    int productId,
    int newQuantity,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE cart_item    SET quantity = ?2    WHERE productId = ?1',
        arguments: [productId, newQuantity]);
  }

  @override
  Future<void> incrementCartItemQuantityByProductId(
    int productId,
    int incrementValue,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE cart_item    SET quantity = quantity + ?2    WHERE productId = ?1',
        arguments: [productId, incrementValue]);
  }

  @override
  Future<void> decrementCartItemQuantityByProductId(
    int productId,
    int decrementValue,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE cart_item    SET quantity = quantity - ?2    WHERE productId = ?1',
        arguments: [productId, decrementValue]);
  }

  @override
  Future<void> deleteCartItemByProductId(int productId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM cart_item WHERE productId = ?1',
        arguments: [productId]);
  }

  @override
  Future<void> clearCartItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM cart_item');
  }

  @override
  Future<void> insertCartItem(CartItemEntity cartItem) async {
    await _cartItemEntityInsertionAdapter.insert(
        cartItem, OnConflictStrategy.ignore);
  }

  @override
  Future<void> insertCartItems(List<CartItemEntity> cartItems) async {
    await _cartItemEntityInsertionAdapter.insertList(
        cartItems, OnConflictStrategy.ignore);
  }
}
