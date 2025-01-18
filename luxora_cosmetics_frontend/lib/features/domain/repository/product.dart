import '../../../core/resources/data_state.dart';
import '../../data/models/product.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<DataState<ProductEntity>> createProduct({
    required ProductModel product,
  });

  Future<DataState<ProductEntity>> updateProduct({
    required ProductModel product,
  });

  Future<DataState> deleteProductById({
    required int id,
  });

  Future<DataState> deleteProductByIsbn({
    required String isbn,
  });

  Future<DataState<ProductEntity>> getProductById({
    required int id,
  });

  Future<DataState<ProductEntity>> getProductByIsbn({
    required String isbn,
  });

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
    bool? orderByPublicationDate,
    bool? orderByPrice,
    bool? orderByStock,
    bool? orderByPreorder,
  });

  Future<DataState<List<ProductEntity>>> getProductsByProductIds({
    String? productIds,
  });
}
