import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/data/models/category.dart';
import '../../features/data/models/product.dart';
import '../../features/data/models/user.dart';
import '../../features/presentation/bloc/remote/auth/auth_bloc.dart';
import '../../features/presentation/bloc/remote/auth/auth_event.dart';

import '../../features/presentation/bloc/remote/cart/cart_bloc.dart';
import '../../features/presentation/bloc/remote/cart/cart_event.dart';
import '../../features/presentation/bloc/remote/category/category_bloc.dart';
import '../../features/presentation/bloc/remote/category/category_event.dart';
import '../../features/presentation/bloc/remote/product/product_bloc.dart';
import '../../features/presentation/bloc/remote/product/product_event.dart';

import '../../features/presentation/bloc/remote/user/user_bloc.dart';
import '../../features/presentation/bloc/remote/user/user_event.dart';
import '../../features/presentation/bloc/remote/wishlist/wishlist_bloc.dart';
import '../../features/presentation/bloc/remote/wishlist/wishlist_event.dart';

class RemoteEventsUtil {
  static AuthEvents get authEvents => AuthEvents();
  static UserEvents get userEvents => UserEvents();
  static ProductEvents get productEvents => ProductEvents();
  static CategoryEvents get categoryEvents => CategoryEvents();
  static WishlistEvents get wishlistEvents => WishlistEvents();
  static CartEvents get cartEvents => CartEvents();
}

class AuthEvents {
  void signUp(BuildContext context, UserModel user) {
    context.read<RemoteAuthBloc>().add(SignUp(user));
  }

  void signIn(BuildContext context, UserModel user) {
    context.read<RemoteAuthBloc>().add(SignIn(user));
  }

  void requestPasswordReset(BuildContext context, {required String email}) {
    context.read<RemoteAuthBloc>().add(RequestPasswordReset(email: email));
  }

  void resetPassword(BuildContext context,
      {required String token, required String newPassword}) {
    context
        .read<RemoteAuthBloc>()
        .add(ResetPassword(token: token, newPassword: newPassword));
  }

  void signOut(BuildContext context) {
    context.read<RemoteAuthBloc>().add(const SignOut());
  }
}

class UserEvents {
  void getUsers(BuildContext context,
      {int? limit,
      int? page,
      String? search,
      bool? orderByAlphabets,
      bool? includeAdmins}) {
    context.read<RemoteUserBloc>().add(
          GetUsers(
            limit: limit,
            page: page,
            search: search,
            orderByAlphabets: orderByAlphabets,
            includeAdmins: includeAdmins,
          ),
        );
  }

  void getLoggedInUser(BuildContext context, {bool onEditProfile = false}) {
    context
        .read<RemoteUserBloc>()
        .add(GetLoggedInUser(onEditProfile: onEditProfile));
  }

  void updateUser(BuildContext context, {required UserModel user}) {
    context.read<RemoteUserBloc>().add(UpdateUser(user: user));
  }

  void updateUserPassword(BuildContext context,
      {required String recentPassword, required String newPassword}) {
    context.read<RemoteUserBloc>().add(
          UpdateUserPassword(
              recentPassword: recentPassword, newPassword: newPassword),
        );
  }

  void deleteUser(BuildContext context, int id) {
    context.read<RemoteUserBloc>().add(DeleteUser(id: id));
  }
}

class ProductEvents {
  // Method to get products
  void getProducts(
    BuildContext context, {
    int? limit,
    int? page,
    String? productIds,
    String? search,
    String? isbn,
    String? title,
    String? authorName,
    String? editor,
    int? categoryNumber,
    String? categoryName,
    String? priceRange,
    String? publicationDate,
    bool? isPublished,
    String? publishedIn,
    String? publishedWithin,
    bool? isNewArrivals,
    bool? isBestSellers,
    bool? isPreorder,
    bool? isInStock,
    bool? isOutStock,
    bool? orderByCreateDate,
    bool? orderBySales,
    String? orderByProductIds,
    bool? orderByTitle,
    bool? orderByAuthor,
    bool? orderByPrice,
    bool? orderByPublicationDate,
    bool? orderByStock,
    bool? orderByPreorder,
  }) {
    context.read<RemoteProductBloc>().add(GetBoutiqueProducts(
          limit: limit,
          page: page,
          productIds: productIds,
          search: search,
          isbn: isbn,
          title: title,
          authorName: authorName,
          editor: editor,
          categoryNumber: categoryNumber,
          categoryName: categoryName,
          priceRange: priceRange,
          publicationDate: publicationDate,
          isPublished: isPublished,
          publishedIn: publishedIn,
          publishedWithin: publishedWithin,
          isNewArrivals: isNewArrivals,
          isBestSellers: isBestSellers,
          isPreorder: isPreorder,
          isInStock: isInStock,
          isOutStock: isOutStock,
          orderByCreateDate: orderByCreateDate,
          orderBySales: orderBySales,
          orderByProductIds: orderByProductIds,
          orderByTitle: orderByTitle,
          orderByAuthor: orderByAuthor,
          orderByPrice: orderByPrice,
          orderByPublicationDate: orderByPublicationDate,
          orderByStock: orderByStock,
          orderByPreorder: orderByPreorder,
        ));
  }

  void getSearchedProducts(
    BuildContext context, {
    String? search,
    String? authorName,
    String? title,
    String? editor,
    String? categoryName,
    String? publicationDate,
  }) {
    context.read<RemoteProductBloc>().add(GetSearchedProducts(
          search: search,
          authorName: authorName,
          title: title,
          editor: editor,
          categoryName: categoryName,
          publicationDate: publicationDate,
        ));
  }

  // Method to get new arrival products
  void getNewArrivals(BuildContext context, {int limit = 10}) {
    context.read<RemoteProductBloc>().add(GetProductsNewArrivals(limit: limit));
  }

  // Method to get book references by category
  void getBooksReferences(BuildContext context, {required int categoryNumber}) {
    context
        .read<RemoteProductBloc>()
        .add(GetProductsBooksReferences(categoryNumber: categoryNumber));
  }

  // Method to get best sellers in literature by category
  void getBestSellersLiterature(BuildContext context,
      {required int categoryNumber}) {
    context
        .read<RemoteProductBloc>()
        .add(GetProductsBestSellersLiterature(categoryNumber: categoryNumber));
  }

  // Method to get best sellers in essays by category
  void getBestSellersEssays(BuildContext context,
      {required int categoryNumber}) {
    context
        .read<RemoteProductBloc>()
        .add(GetProductsBestSellersEssays(categoryNumber: categoryNumber));
  }

  // Method to get best sellers in health by category
  void getBestSellersHealth(BuildContext context,
      {required int categoryNumber}) {
    context
        .read<RemoteProductBloc>()
        .add(GetProductsBestSellersHealth(categoryNumber: categoryNumber));
  }

  // Method to get top sellers by category
  void getTopSellers(BuildContext context, {int limit = 10}) {
    context.read<RemoteProductBloc>().add(GetProductsTopSellers(limit: limit));
  }

  // Method to get top sellers by category
  void getWithSimilarCategory(BuildContext context,
      {required int categoryNumber}) {
    context
        .read<RemoteProductBloc>()
        .add(GetProductsWithSimilarCategory(categoryNumber: categoryNumber));
  }

  // get wishlist products
  void geWishlistProducts(BuildContext context, {required String productIds}) {
    context
        .read<RemoteProductBloc>()
        .add(GetWishlistProducts(productIds: productIds));
  }

  // get wishlist products
  void geCartProducts(BuildContext context, {required String productIds}) {
    context
        .read<RemoteProductBloc>()
        .add(GetCartProducts(productIds: productIds));
  }

  // get wishlist products
  void getCheckoutProducts(BuildContext context, {required String productIds}) {
    context
        .read<RemoteProductBloc>()
        .add(GetCheckoutProducts(productIds: productIds));
  }

  // Method to create a product
  void createProduct(BuildContext context, ProductModel product) {
    context.read<RemoteProductBloc>().add(CreateProduct(product));
  }

  // Method to update a product
  void updateProduct(BuildContext context, ProductModel product) {
    context.read<RemoteProductBloc>().add(UpdateProduct(product));
  }

  // Method to delete a product by ID
  void deleteProductById(BuildContext context, int id) {
    context.read<RemoteProductBloc>().add(DeleteProductById(id));
  }

  // Method to delete a product by ISBN
  void deleteProductByIsbn(BuildContext context, String isbn) {
    context.read<RemoteProductBloc>().add(DeleteProductByIsbn(isbn));
  }

  // Method to get a product by ID
  void getProductById(BuildContext context, int id) {
    context.read<RemoteProductBloc>().add(GetProductById(id));
  }

  // Method to get a product by ISBN
  void getProductByIsbn(BuildContext context, String isbn) {
    context.read<RemoteProductBloc>().add(GetProductByIsbn(isbn));
  }
}

class CategoryEvents {
  // Method to create a category
  void createCategory(BuildContext context, CategoryModel category) {
    context.read<RemoteCategoryBloc>().add(CreateCategory(category));
  }

  // Method to update a category
  void updateCategory(BuildContext context, CategoryModel category) {
    context.read<RemoteCategoryBloc>().add(UpdateCategory(category));
  }

  // Method to delete a category by ID
  void deleteCategoryById(BuildContext context, int id) {
    context.read<RemoteCategoryBloc>().add(DeleteCategoryById(id));
  }

  // Method to delete a category by category number
  void deleteCategoryByCategoryNumber(
      BuildContext context, int categoryNumber) {
    context
        .read<RemoteCategoryBloc>()
        .add(DeleteCategoryByCategoryNumber(categoryNumber));
  }

  // Method to get a category by ID
  void getCategoryById(BuildContext context,
      {required int id, required int level}) {
    context
        .read<RemoteCategoryBloc>()
        .add(GetCategoryById(id: id, level: level));
  }

  // Method to get a category by category number
  void getCategoryByCategoryNumber(BuildContext context,
      {required int categoryNumber, required int level}) {
    context.read<RemoteCategoryBloc>().add(GetCategoryByCategoryNumber(
        categoryNumber: categoryNumber, level: level));
  }

  // Method to get a category by category number
  void getBoutiqueMainCategory(BuildContext context,
      {required int categoryNumber}) {
    context
        .read<RemoteCategoryBloc>()
        .add(GetBoutiqueMainCategory(categoryNumber: categoryNumber));
  }

  // Method to get all categories with optional filtering by level or main category flag
  void getNavigatorAllCategories(
    BuildContext context,
  ) {
    context.read<RemoteCategoryBloc>().add(const GetNavigatorAllCategories());
  }

  // Method to get all categories with optional filtering by level or main category flag
  void getBoutiqueAllCategories(
    BuildContext context,
  ) {
    context.read<RemoteCategoryBloc>().add(const GetBoutiqueAllCategories());
  }

  // Method to get categories by IDs or category numbers
  void getSearchMainCategories(BuildContext context,
      {String? ids, String? categoryNumbers}) {
    context.read<RemoteCategoryBloc>().add(
        GetSearchMainCategories(ids: ids, categoryNumbers: categoryNumbers));
  }

  // Method to get categories by IDs or category numbers
  void getCategories(BuildContext context,
      {String? ids, String? categoryNumbers}) {
    context
        .read<RemoteCategoryBloc>()
        .add(GetCategories(ids: ids, categoryNumbers: categoryNumbers));
  }
}

class WishlistEvents {
  void syncWishlist(BuildContext context) {
    context.read<RemoteWishlistBloc>().add(const SyncWishlist());
  }

  void getWishlist(BuildContext context) {
    context.read<RemoteWishlistBloc>().add(const GetWishlist());
  }

  void addItemToWishlist(BuildContext context, int productId) {
    context
        .read<RemoteWishlistBloc>()
        .add(AddItemToWishlist(productId: productId));
  }

  void updateWishlistItem(BuildContext context,
      {required int productId, required int quantity}) {
    context
        .read<RemoteWishlistBloc>()
        .add(UpdateWishlistItem(productId: productId, quantity: quantity));
  }

  void removeItemFromWishlist(BuildContext context,
      {required int productId, bool allQuantity = false}) {
    context.read<RemoteWishlistBloc>().add(
        RemoveItemFromWishlist(productId: productId, allQuantity: allQuantity));
  }

  void clearWishlist(BuildContext context) {
    context.read<RemoteWishlistBloc>().add(const ClearWishlist());
  }
}

class CartEvents {
  void syncCart(BuildContext context) {
    context.read<RemoteCartBloc>().add(const SyncCart());
  }

  void getCart(BuildContext context) {
    context.read<RemoteCartBloc>().add(const GetCart());
  }

  void addItemToCart(BuildContext context, {required int productId}) {
    context.read<RemoteCartBloc>().add(AddItemToCart(productId: productId));
  }

  void addManyItemsToCart(BuildContext context,
      {required List<int> productIds}) {
    context
        .read<RemoteCartBloc>()
        .add(AddManyItemsToCart(productIds: productIds));
  }

  void updateCartItem(BuildContext context,
      {required int productId, required int quantity}) {
    context
        .read<RemoteCartBloc>()
        .add(UpdateCartItem(productId: productId, quantity: quantity));
  }

  void removeItemFromCart(BuildContext context,
      {required int productId, bool allQuantity = false}) {
    context.read<RemoteCartBloc>().add(
        RemoveItemFromCart(productId: productId, allQuantity: allQuantity));
  }

  void clearCart(BuildContext context) {
    context.read<RemoteCartBloc>().add(const ClearCart());
  }
}
