import 'package:equatable/equatable.dart';

class FilteringDataEntity extends Equatable {
  final int? inStockCount;
  final int? preorderCount;
  final int? publishedCount;
  final int? publishedPast6MonthsCount;
  final int? publishedWithin3MonthsCount;
  final int? paperbackFormatCount;
  final int? grandFormatCount;

  const FilteringDataEntity({
    this.inStockCount,
    this.preorderCount,
    this.publishedCount,
    this.publishedPast6MonthsCount,
    this.publishedWithin3MonthsCount,
    this.paperbackFormatCount,
    this.grandFormatCount,
  });

  @override
  List<Object?> get props => [
        inStockCount,
        preorderCount,
        publishedCount,
        publishedPast6MonthsCount,
        publishedWithin3MonthsCount,
        paperbackFormatCount,
        grandFormatCount,
      ];
}
