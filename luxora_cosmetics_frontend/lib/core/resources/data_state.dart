import 'package:dio/dio.dart';

import '../../features/data/models/pagination.dart';

abstract class DataState<T> {
  final T? data;
  final String? message;
  final PaginationModel? pagination;
  final DioException? error;

  const DataState({this.data, this.message, this.pagination, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess({
    super.data,
    super.pagination,
    super.message,
  });
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioException error) : super(error: error);
}
