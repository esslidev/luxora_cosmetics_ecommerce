import '../../../../data/models/product.dart';

abstract class RemoteProductEvent {
  const RemoteProductEvent();
}

//-----------------------------------------------//
class CreateProduct extends RemoteProductEvent {
  final ProductModel product;

  CreateProduct(this.product);
}

//-----------------------------------------------//

class UpdateProduct extends RemoteProductEvent {
  final ProductModel product;

  UpdateProduct(this.product);
}

//-----------------------------------------------//

class DeleteProductById extends RemoteProductEvent {
  final int id;

  DeleteProductById(this.id);
}

class DeleteProductByIsbn extends RemoteProductEvent {
  final String isbn;

  DeleteProductByIsbn(this.isbn);
}

//-----------------------------------------------//

class GetBoutiqueProducts extends RemoteProductEvent {
  final int? limit;
  final int? page;
  final String? productIds;
  final String? search;
  final String? isbn;
  final int? categoryNumber;
  final String? title;
  final String? authorName;
  final String? editor;
  final String? categoryName;
  final String? priceRange;
  final String? publicationDate;
  final bool? isPublished;
  final String? publishedIn;
  final String? publishedWithin;
  final bool? isPreorder;
  final bool? isNewArrivals;
  final bool? isBestSellers;
  final bool? isInStock;
  final bool? isOutStock;
  final bool? orderByCreateDate;
  final bool? orderBySales;
  final String? orderByProductIds;
  final bool? orderByTitle;
  final bool? orderByAuthor;
  final bool? orderByPrice;
  final bool? orderByPublicationDate;
  final bool? orderByStock;
  final bool? orderByPreorder;

  const GetBoutiqueProducts({
    this.limit,
    this.page,
    this.productIds,
    this.search,
    this.isbn,
    this.title,
    this.authorName,
    this.editor,
    this.categoryNumber,
    this.categoryName,
    this.priceRange,
    this.publicationDate,
    this.isPublished,
    this.publishedIn,
    this.publishedWithin,
    this.isNewArrivals,
    this.isBestSellers,
    this.isPreorder,
    this.isInStock,
    this.isOutStock,
    this.orderByCreateDate,
    this.orderBySales,
    this.orderByProductIds,
    this.orderByTitle,
    this.orderByAuthor,
    this.orderByPrice,
    this.orderByPublicationDate,
    this.orderByStock,
    this.orderByPreorder,
  });
}

class GetSearchedProducts extends RemoteProductEvent {
  final String? search;
  final String? authorName;
  final String? title;
  final String? editor;
  final String? categoryName;
  final String? publicationDate;

  const GetSearchedProducts({
    this.search,
    this.authorName,
    this.title,
    this.editor,
    this.categoryName,
    this.publicationDate,
  });
}

class GetProductsNewArrivals extends RemoteProductEvent {
  final int limit;
  const GetProductsNewArrivals({this.limit = 10});
}

class GetProductsBooksReferences extends RemoteProductEvent {
  final int categoryNumber;
  final int limit;
  const GetProductsBooksReferences(
      {required this.categoryNumber, this.limit = 10});
}

class GetProductsBestSellersLiterature extends RemoteProductEvent {
  final int categoryNumber;
  final int limit;
  const GetProductsBestSellersLiterature(
      {required this.categoryNumber, this.limit = 10});
}

class GetProductsBestSellersEssays extends RemoteProductEvent {
  final int categoryNumber;
  final int limit;
  const GetProductsBestSellersEssays(
      {required this.categoryNumber, this.limit = 10});
}

class GetProductsBestSellersHealth extends RemoteProductEvent {
  final int categoryNumber;
  final int limit;
  const GetProductsBestSellersHealth(
      {required this.categoryNumber, this.limit = 10});
}

class GetProductsTopSellers extends RemoteProductEvent {
  final int limit;
  const GetProductsTopSellers({this.limit = 10});
}

class GetProductsWithSimilarCategory extends RemoteProductEvent {
  final int categoryNumber;
  final int limit;
  const GetProductsWithSimilarCategory(
      {required this.categoryNumber, this.limit = 10});
}

class GetWishlistProducts extends RemoteProductEvent {
  final String productIds;
  const GetWishlistProducts({required this.productIds});
}

class GetCartProducts extends RemoteProductEvent {
  final String productIds;
  const GetCartProducts({required this.productIds});
}

class GetCheckoutProducts extends RemoteProductEvent {
  final String productIds;
  const GetCheckoutProducts({required this.productIds});
}

//-----------------------------------------------//

class GetProductById extends RemoteProductEvent {
  final int id;

  GetProductById(this.id);
}

class GetProductByIsbn extends RemoteProductEvent {
  final String isbn;

  GetProductByIsbn(this.isbn);
}
