// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ProductApiService implements ProductApiService {
  _ProductApiService(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://localhost:4003/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<DataResponse<ProductModel>>> createProduct({
    required String accessToken,
    required String language,
    required ProductModel product,
    String contentType = 'application/json',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': accessToken,
      r'language': language,
      r'Content-Type': contentType,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(product.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<DataResponse<ProductModel>>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/api/products/product/create',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DataResponse<ProductModel>.fromJson(
      _result.data!,
      (json) => ProductModel.fromJson(json as Map<String, dynamic>),
    );
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<DataResponse<ProductModel>>> updateProduct({
    required String accessToken,
    required String language,
    required ProductModel product,
    String contentType = 'application/json',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': accessToken,
      r'language': language,
      r'Content-Type': contentType,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(product.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<DataResponse<ProductModel>>>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/api/products/product/update',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DataResponse<ProductModel>.fromJson(
      _result.data!,
      (json) => ProductModel.fromJson(json as Map<String, dynamic>),
    );
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<DataResponse<dynamic>>> deleteProduct({
    required String accessToken,
    required String language,
    int? id,
    String? isbn,
    String contentType = 'application/json',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'id': id,
      r'isbn': isbn,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': accessToken,
      r'language': language,
      r'Content-Type': contentType,
    };
    _headers.removeWhere((k, v) => v == null);
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<DataResponse<dynamic>>>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/api/products/product/delete',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DataResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<DataResponse<ProductModel>>> getProduct({
    required String apiKey,
    required String language,
    int? id,
    String? isbn,
    String contentType = 'application/json',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'id': id,
      r'isbn': isbn,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'apiKey': apiKey,
      r'language': language,
      r'Content-Type': contentType,
    };
    _headers.removeWhere((k, v) => v == null);
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<DataResponse<ProductModel>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/api/products/product',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DataResponse<ProductModel>.fromJson(
      _result.data!,
      (json) => ProductModel.fromJson(json as Map<String, dynamic>),
    );
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<DataResponse<List<ProductModel>>>> getProducts({
    required String apiKey,
    required String language,
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
    String contentType = 'application/json',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limit': limit,
      r'page': page,
      r'productIds': productIds,
      r'search': search,
      r'isbn': isbn,
      r'title': title,
      r'authorName': authorName,
      r'editor': editor,
      r'categoryNumber': categoryNumber,
      r'categoryName': categoryName,
      r'formatType': formatType?.name,
      r'priceRange': priceRange,
      r'publicationDate': publicationDate,
      r'isPublished': isPublished,
      r'publishedIn': publishedIn,
      r'publishedWithin': publishedWithin,
      r'isNewArrivals': isNewArrivals,
      r'isBestSellers': isBestSellers,
      r'isPreorder': isPreorder,
      r'isInStock': isInStock,
      r'isOutStock': isOutStock,
      r'orderByCreateDate': orderByCreateDate,
      r'orderBySales': orderBySales,
      r'orderByProductIds': orderByProductIds,
      r'orderByTitle': orderByTitle,
      r'orderByAuthor': orderByAuthor,
      r'orderByPrice': orderByPrice,
      r'orderByPublicationDate': orderByPublicationDate,
      r'orderByStock': orderByStock,
      r'orderByPreorder': orderByPreorder,
      r'sortOrder': sortOrder?.name,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'apiKey': apiKey,
      r'language': language,
      r'Content-Type': contentType,
    };
    _headers.removeWhere((k, v) => v == null);
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<DataResponse<List<ProductModel>>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/api/products/products',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DataResponse<List<ProductModel>>.fromJson(
      _result.data!,
      (json) => json is List<dynamic>
          ? json
              .map<ProductModel>(
                  (i) => ProductModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : List.empty(),
    );
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<DataResponse<List<ProductModel>>>>
      getProductsByProductIds({
    required String apiKey,
    required String language,
    String? productIds,
    String contentType = 'application/json',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'productIds': productIds};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'apiKey': apiKey,
      r'language': language,
      r'Content-Type': contentType,
    };
    _headers.removeWhere((k, v) => v == null);
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<DataResponse<List<ProductModel>>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/api/products/products/ids',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DataResponse<List<ProductModel>>.fromJson(
      _result.data!,
      (json) => json is List<dynamic>
          ? json
              .map<ProductModel>(
                  (i) => ProductModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : List.empty(),
    );
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
