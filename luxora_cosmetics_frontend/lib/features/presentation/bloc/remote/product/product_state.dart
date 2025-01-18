import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/pagination.dart';
import '../../../../domain/entities/product.dart';

abstract class RemoteProductState extends Equatable {
  final ProductEntity? product;
  final List<ProductEntity>? boutiqueProducts;
  final List<ProductEntity>? searchedProducts;
  final List<ProductEntity>? productsNewArrivals;
  final List<ProductEntity>? productsBooksReferences;
  final List<ProductEntity>? productsBestSellersLiterature;
  final List<ProductEntity>? productsBestSellersEssays;
  final List<ProductEntity>? productsBestSellersHealth;
  final List<ProductEntity>? productsTopSellers;
  final List<ProductEntity>? productsWithSimilarCategory;
  final List<ProductEntity>? productsRecentlyViewed;
  final List<ProductEntity>? wishlistProducts;
  final List<ProductEntity>? cartProducts;
  final List<ProductEntity>? checkoutProducts;
  final bool? productLoading;
  final bool? boutiqueProductsLoading;
  final bool? searchedProductsLoading;
  final bool? productsNewArrivalsLoading;
  final bool? productsBooksReferencesLoading;
  final bool? productsBestSellersLiteratureLoading;
  final bool? productsBestSellersEssaysLoading;
  final bool? productsBestSellersHealthLoading;
  final bool? productsTopSellersLoading;
  final bool? productsWithSimilarCategoryLoading;
  final bool? productsRecentlyViewedLoading;
  final bool? wishlistProductsLoading;
  final bool? cartProductsLoading;
  final bool? checkoutProductsLoading;
  final PaginationEntity? pagination;
  final String? messageResponse;
  final DioException? error;

  const RemoteProductState({
    this.product,
    this.boutiqueProducts,
    this.searchedProducts,
    this.productsNewArrivals,
    this.productsBooksReferences,
    this.productsBestSellersLiterature,
    this.productsBestSellersEssays,
    this.productsBestSellersHealth,
    this.productsTopSellers,
    this.productsWithSimilarCategory,
    this.productsRecentlyViewed,
    this.wishlistProducts,
    this.cartProducts,
    this.checkoutProducts,
    this.productLoading,
    this.boutiqueProductsLoading,
    this.searchedProductsLoading,
    this.productsNewArrivalsLoading,
    this.productsBooksReferencesLoading,
    this.productsBestSellersLiteratureLoading,
    this.productsBestSellersEssaysLoading,
    this.productsBestSellersHealthLoading,
    this.productsTopSellersLoading,
    this.productsWithSimilarCategoryLoading,
    this.productsRecentlyViewedLoading,
    this.wishlistProductsLoading,
    this.cartProductsLoading,
    this.checkoutProductsLoading,
    this.pagination,
    this.messageResponse,
    this.error,
  });

  @override
  List<Object?> get props => [
        product,
        boutiqueProducts,
        searchedProducts,
        productsNewArrivals,
        productsBooksReferences,
        productsBestSellersLiterature,
        productsBestSellersEssays,
        productsBestSellersHealth,
        productsTopSellers,
        productsWithSimilarCategory,
        wishlistProducts,
        cartProducts,
        checkoutProducts,
        productLoading,
        searchedProductsLoading,
        productsNewArrivalsLoading,
        productsBooksReferencesLoading,
        productsBestSellersLiteratureLoading,
        productsBestSellersEssaysLoading,
        productsBestSellersHealthLoading,
        productsTopSellersLoading,
        productsWithSimilarCategoryLoading,
        productsRecentlyViewedLoading,
        wishlistProductsLoading,
        cartProductsLoading,
        checkoutProductsLoading,
        pagination,
        messageResponse,
        error,
      ];
}

// ------------- Init product state -------------- //
class RemoteProductInitial extends RemoteProductState {
  const RemoteProductInitial();
}

// ------------- Saving product -------------- //
class RemoteProductSaving extends RemoteProductState {
  const RemoteProductSaving();
}

class RemoteProductSaved extends RemoteProductState {
  const RemoteProductSaved(ProductEntity? product) : super(product: product);
}

// ------------- Updating product -------------- //
class RemoteProductUpdating extends RemoteProductState {
  const RemoteProductUpdating();
}

class RemoteProductUpdated extends RemoteProductState {
  const RemoteProductUpdated(ProductEntity? product) : super(product: product);
}

// ------------- Deleting product -------------- //
class RemoteProductDeleting extends RemoteProductState {
  const RemoteProductDeleting();
}

class RemoteProductDeleted extends RemoteProductState {
  const RemoteProductDeleted(String? messageResponse)
      : super(messageResponse: messageResponse);
}

// ------------- Loading product -------------- //
class RemoteProductLoading extends RemoteProductState {
  const RemoteProductLoading({super.productLoading});
}

class RemoteProductLoaded extends RemoteProductState {
  const RemoteProductLoaded(ProductEntity? product) : super(product: product);
}

// ------------- Loading products -------------- //

class RemoteProductsLoading extends RemoteProductState {
  const RemoteProductsLoading(
      {super.boutiqueProductsLoading,
      super.searchedProductsLoading,
      super.productsNewArrivalsLoading,
      super.productsBooksReferencesLoading,
      super.productsBestSellersLiteratureLoading,
      super.productsBestSellersEssaysLoading,
      super.productsBestSellersHealthLoading,
      super.productsTopSellersLoading,
      super.productsWithSimilarCategoryLoading,
      super.productsRecentlyViewedLoading,
      super.wishlistProductsLoading,
      super.cartProductsLoading,
      super.checkoutProductsLoading});
}

class RemoteProductsLoaded extends RemoteProductState {
  const RemoteProductsLoaded(
      {super.boutiqueProducts,
      super.searchedProducts,
      super.productsNewArrivals,
      super.productsBooksReferences,
      super.productsBestSellersLiterature,
      super.productsBestSellersEssays,
      super.productsBestSellersHealth,
      super.productsTopSellers,
      super.productsWithSimilarCategory,
      super.productsRecentlyViewed,
      super.wishlistProducts,
      super.cartProducts,
      super.checkoutProducts,
      super.pagination});
}

// ------------- Error product -------------- //
class RemoteProductError extends RemoteProductState {
  const RemoteProductError(DioException? error) : super(error: error);
}
