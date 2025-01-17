import 'package:equatable/equatable.dart';

enum ShowcaseType { none, defaultType, promo }

class ShowcaseItemEntity extends Equatable {
  final String? id;
  final String? imageBase64; // base64 string representation of the image
  final ShowcaseType? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ShowcaseItemEntity({
    this.id,
    this.imageBase64,
    this.type,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        imageBase64,
        type,
        startDate,
        endDate,
        createdAt,
        updatedAt,
      ];
}
