import 'package:json_annotation/json_annotation.dart';

import 'filtering_data.dart';
import 'pagination.dart';

part 'data_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DataResponse<T> {
  final T? data;
  final String? status;
  final PaginationModel? pagination;

  final String? message;

  DataResponse({
    this.data,
    this.status,
    this.pagination,
    this.message,
  });

  factory DataResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$DataResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$DataResponseToJson(this, toJsonT);
}
