import '../../../core/enums/product.dart';
import '../../../core/resources/data_state.dart';

import '../../data/models/product.dart';
import '../entities/product.dart';
import '../repository/product.dart';

class ProductUseCases {
  final ProductRepository repository;

  ProductUseCases(this.repository);

  Future<DataState<ProductEntity>> createProduct({
    required ProductModel product,
  }) async {
    return await repository.createProduct(product: product);
  }

  Future<DataState<ProductEntity>> updateProduct({
    required ProductModel product,
  }) async {
    return await repository.updateProduct(product: product);
  }

  Future<DataState> deleteProductById({
    required int id,
  }) async {
    return await repository.deleteProductById(id: id);
  }

  Future<DataState> deleteProductByIsbn({
    required String isbn,
  }) async {
    return await repository.deleteProductByIsbn(isbn: isbn);
  }

  Future<DataState<ProductEntity>> getProductById({
    required int id,
  }) async {
    return await repository.getProductById(id: id);
  }

  Future<DataState<ProductEntity>> getProductByIsbn({
    required String isbn,
  }) async {
    return await repository.getProductByIsbn(isbn: isbn);
  }

  Future<DataState<List<ProductEntity>>> getProducts({
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
    ProductFormatType? formatType,
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
    SortOrder? sortOrder,
  }) async {
    return await repository.getProducts(
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
      formatType: formatType,
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
      sortOrder: sortOrder,
    );
  }

  Future<DataState<List<ProductEntity>>> getProductsByProductIds({
    String? productIds,
  }) async {
    return await repository.getProductsByProductIds(
      productIds: productIds,
    );
  }
}
