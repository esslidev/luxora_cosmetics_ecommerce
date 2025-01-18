import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../../domain/usecases/product.dart';
import 'product_event.dart';
import 'product_state.dart';

class RemoteProductBloc extends Bloc<RemoteProductEvent, RemoteProductState> {
  final ProductUseCases _productUseCases;

  RemoteProductBloc(this._productUseCases)
      : super(const RemoteProductInitial()) {
    on<CreateProduct>(onCreateProduct);
    on<UpdateProduct>(onUpdateProduct);
    on<DeleteProductById>(onDeleteProductById);
    on<DeleteProductByIsbn>(onDeleteProductByIsbn);
    on<GetProductById>(onGetProductById);
    on<GetProductByIsbn>(onGetProductByIsbn);
    on<GetBoutiqueProducts>(onGetBoutiqueProducts);
    on<GetSearchedProducts>(onGetSearchedProducts);
    on<GetProductsNewArrivals>(onGetProductsNewArrivals);
    on<GetProductsBooksReferences>(onGetProductsBooksReferences);
    on<GetProductsBestSellersLiterature>(onGetProductsBestSellersLiterature);
    on<GetProductsBestSellersEssays>(onGetProductsBestSellersEssays);
    on<GetProductsBestSellersHealth>(onGetProductsBestSellersHealth);
    on<GetProductsTopSellers>(onGetProductsTopSellers);
    on<GetProductsWithSimilarCategory>(onGetProductsWithSimilarCategory);
    on<GetWishlistProducts>(onGetWishlistProducts);
    on<GetCartProducts>(onGetCartProducts);
    on<GetCheckoutProducts>(onGetCheckoutProducts);
  }

  void onCreateProduct(
      CreateProduct event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductSaving());
    final dataState =
        await _productUseCases.createProduct(product: event.product);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductSaved(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onUpdateProduct(
      UpdateProduct event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductUpdating());
    final dataState =
        await _productUseCases.updateProduct(product: event.product);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductUpdated(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onDeleteProductById(
      DeleteProductById event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductDeleting());
    final dataState = await _productUseCases.deleteProductById(id: event.id);
    if (dataState is DataSuccess && dataState.message != null) {
      emit(RemoteProductDeleted(dataState.message!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onDeleteProductByIsbn(
      DeleteProductByIsbn event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductDeleting());
    final dataState =
        await _productUseCases.deleteProductByIsbn(isbn: event.isbn);
    if (dataState is DataSuccess && dataState.message != null) {
      emit(RemoteProductDeleted(dataState.message!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetProductById(
      GetProductById event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductLoading(productLoading: true));
    final dataState = await _productUseCases.getProductById(id: event.id);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductLoaded(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetProductByIsbn(
      GetProductByIsbn event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductLoading(productLoading: true));
    final dataState = await _productUseCases.getProductByIsbn(isbn: event.isbn);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductLoaded(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetBoutiqueProducts(
      GetBoutiqueProducts event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(boutiqueProductsLoading: true));
    final dataState = await _productUseCases.getProducts(
      limit: event.limit,
      page: event.page,
      productIds: event.productIds,
      search: event.search,
      isbn: event.isbn,
      title: event.title,
      authorName: event.authorName,
      editor: event.editor,
      categoryNumber: event.categoryNumber,
      categoryName: event.categoryName,
      priceRange: event.priceRange,
      publicationDate: event.publicationDate,
      isPublished: event.isPublished,
      publishedIn: event.publishedIn,
      publishedWithin: event.publishedWithin,
      isPreorder: event.isPreorder,
      isNewArrivals: event.isNewArrivals,
      isBestSellers: event.isBestSellers,
      isInStock: event.isInStock,
      isOutStock: event.isOutStock,
      orderByCreateDate: event.orderByCreateDate,
      orderBySales: event.orderBySales,
      orderByProductIds: event.orderByProductIds,
      orderByTitle: event.orderByTitle,
      orderByAuthor: event.orderByAuthor,
      orderByPrice: event.orderByPrice,
      orderByPublicationDate: event.orderByPublicationDate,
      orderByStock: event.orderByStock,
      orderByPreorder: event.orderByPreorder,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(
        boutiqueProducts: dataState.data!,
        pagination: dataState.pagination!,
      ));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetSearchedProducts(
      GetSearchedProducts event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(searchedProductsLoading: true));
    final dataState = await _productUseCases.getProducts(
      limit: 5,
      search: event.search,
      authorName: event.authorName,
      title: event.title,
      editor: event.editor,
      categoryName: event.categoryName,
      publicationDate: event.publicationDate,
      orderByTitle: true,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(
        searchedProducts: dataState.data!,
        pagination: dataState.pagination!,
      ));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetProductsNewArrivals(
      GetProductsNewArrivals event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(productsNewArrivalsLoading: true));
    final dataState = await _productUseCases.getProducts(
      orderByCreateDate: true,
      limit: event.limit,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(productsNewArrivals: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetProductsBooksReferences(GetProductsBooksReferences event,
      Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(productsBooksReferencesLoading: true));
    final dataState = await _productUseCases.getProducts(
      categoryNumber: event.categoryNumber,
      limit: event.limit,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(productsBooksReferences: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetProductsBestSellersLiterature(
      GetProductsBestSellersLiterature event,
      Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(
        productsBestSellersLiteratureLoading: true));
    final dataState = await _productUseCases.getProducts(
      orderBySales: true,
      categoryNumber: event.categoryNumber,
      limit: event.limit,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(
          RemoteProductsLoaded(productsBestSellersLiterature: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetProductsBestSellersEssays(GetProductsBestSellersEssays event,
      Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(productsBestSellersEssaysLoading: true));
    final dataState = await _productUseCases.getProducts(
      orderBySales: true,
      categoryNumber: event.categoryNumber,
      limit: event.limit,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(productsBestSellersEssays: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetProductsBestSellersHealth(GetProductsBestSellersHealth event,
      Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(productsBestSellersHealthLoading: true));
    final dataState = await _productUseCases.getProducts(
      orderBySales: true,
      categoryNumber: event.categoryNumber,
      limit: event.limit,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(productsBestSellersHealth: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetProductsTopSellers(
      GetProductsTopSellers event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(productsTopSellersLoading: true));
    final dataState = await _productUseCases.getProducts(
      limit: event.limit,
      orderBySales: true,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(productsTopSellers: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetProductsWithSimilarCategory(GetProductsWithSimilarCategory event,
      Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(productsWithSimilarCategoryLoading: true));
    final dataState = await _productUseCases.getProducts(
      orderByCreateDate: true,
      categoryNumber: event.categoryNumber,
      limit: event.limit,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(productsWithSimilarCategory: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetWishlistProducts(
      GetWishlistProducts event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(wishlistProductsLoading: true));
    final dataState = await _productUseCases.getProductsByProductIds(
      productIds: event.productIds,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(wishlistProducts: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetCartProducts(
      GetCartProducts event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(cartProductsLoading: true));
    final dataState = await _productUseCases.getProductsByProductIds(
      productIds: event.productIds,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(cartProducts: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }

  void onGetCheckoutProducts(
      GetCheckoutProducts event, Emitter<RemoteProductState> emit) async {
    emit(const RemoteProductsLoading(checkoutProductsLoading: true));
    final dataState = await _productUseCases.getProductsByProductIds(
      productIds: event.productIds,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteProductsLoaded(checkoutProducts: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteProductError(dataState.error!));
    }
  }
}
