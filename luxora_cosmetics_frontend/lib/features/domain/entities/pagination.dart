import 'package:equatable/equatable.dart';

class PaginationEntity extends Equatable {
  final int? limit;
  final int? total;
  final int? page;
  final int? pages;

  const PaginationEntity({
    this.limit,
    this.total,
    this.page,
    this.pages,
  });

  @override
  List<Object?> get props => [limit, total, page, pages];
}
