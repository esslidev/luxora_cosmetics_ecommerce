import 'package:equatable/equatable.dart';

import '../../data/models/product.dart';
import '../../data/models/user.dart';

class ReviewEntity extends Equatable {
  final int? id;
  final int? productId;
  final int? userId;
  final String? text;
  final int? rating; // from 0 to 4
  final bool? isPublic;
  final UserModel? user;
  final ProductModel? product;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReviewEntity({
    this.id,
    this.productId,
    this.userId,
    this.text,
    this.rating = 0,
    this.isPublic = false,
    this.user,
    this.product,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        userId,
        text,
        rating,
        isPublic,
        user,
        product,
        createdAt,
        updatedAt,
      ];
}
